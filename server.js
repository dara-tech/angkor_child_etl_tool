const express = require('express');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const mysql = require('mysql2/promise');
const dbExporter = require('./db-exporter');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware for parsing JSON and text payloads up to 50MB
app.use(express.json({ limit: '50mb' }));
app.use(express.text({ limit: '50mb', type: 'application/octet-stream' }));
app.use(express.static(path.join(__dirname, 'public'), {
  setHeaders: (res, filePath) => {
    if (/\.(js|css|html)$/.test(filePath)) {
      res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
      res.setHeader('Pragma', 'no-cache');
      res.setHeader('Expires', '0');
    }
  }
}));

// Fetch status of connections
app.get('/api/status', async (req, res) => {
  try {
    const status = await dbExporter.testConnections();
    res.json(status);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Save configuration
app.post('/api/config', (req, res) => {
  try {
    const newConfig = req.body;
    fs.writeFileSync(path.join(__dirname, 'config.json'), JSON.stringify(newConfig, null, 2), 'utf8');
    res.json({ message: 'Configuration saved successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Fetch current config (excluding passwords for safety, or return all if needed for editing)
app.get('/api/config', (req, res) => {
  try {
    const configPath = path.join(__dirname, 'config.json');
    if (fs.existsSync(configPath)) {
      const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
      // Keep passwords in response for editing purposes (local development)
      res.json(config);
    } else {
      res.status(404).json({ error: 'Config file not found' });
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Stream progress of ETL process via SSE
app.get('/api/export-stream', async (req, res) => {
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');

  const log = (message) => {
    res.write(`data: ${JSON.stringify({ message, timestamp: new Date().toLocaleTimeString() })}\n\n`);
  };

  log('Starting database export ETL process...');
  try {
    await dbExporter.runETL(log);
    log('ETL process finished successfully!');
    res.write(`data: ${JSON.stringify({ status: 'done' })}\n\n`);
  } catch (err) {
    log(`ERROR during ETL: ${err.message}`);
    res.write(`data: ${JSON.stringify({ status: 'failed', error: err.message })}\n\n`);
  }
  res.end();
});

// In-memory store for completed backups: token -> { encryptedData, filename }
const backupTokens = new Map();

// Stream backup progress via SSE, then emit a download token when done
app.get('/api/backup-stream', async (req, res) => {
  const password = req.query.password || '090666847';

  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');

  const send = (data) => res.write(`data: ${JSON.stringify(data)}\n\n`);

  send({ message: 'Starting backup generation...' });

  try {
    const encryptedData = await dbExporter.generateBackup(password, (msg) => send({ message: msg }));

    // Store in-memory — no temp files, no Windows path issues
    const token = crypto.randomBytes(16).toString('hex');
    const filename = `preart_backup_${Date.now()}.h149`;

    backupTokens.set(token, { encryptedData, filename });

    // Auto-cleanup after 10 minutes
    setTimeout(() => backupTokens.delete(token), 10 * 60 * 1000);

    send({ status: 'done', token, filename });
  } catch (err) {
    send({ status: 'failed', error: err.message });
  }

  res.end();
});

// Serve the in-memory backup via one-time token
app.get('/api/backup-download', (req, res) => {
  const { token } = req.query;
  const entry = backupTokens.get(token);
  if (!entry) {
    return res.status(404).json({ error: 'Backup not found or expired (10 min limit)' });
  }

  // Burn token immediately to prevent duplicate downloads
  backupTokens.delete(token);

  const { encryptedData, filename } = entry;
  res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
  res.setHeader('Content-Type', 'application/octet-stream');
  res.send(encryptedData);
});


// Restore backup from encrypted data payload
app.post('/api/restore', async (req, res) => {
  const { encryptedData, password } = req.body;
  if (!encryptedData) {
    return res.status(400).json({ error: 'Backup data is required' });
  }
  
  const actualPassword = password || '090666847';
  const logs = [];
  const log = (msg) => {
    logs.push(msg);
  };
  
  try {
    await dbExporter.restoreBackup(encryptedData, actualPassword, log);
    res.json({ message: 'Database restored successfully', logs });
  } catch (err) {
    res.status(500).json({ error: err.message, logs });
  }
});

// Restore SQL Server database from .bak stream
app.post('/api/restore-sqlserver', (req, res) => {
  const tempPath = path.join(__dirname, `sql_restore_${Date.now()}.bak`);
  const writeStream = fs.createWriteStream(tempPath);
  
  req.pipe(writeStream);
  
  writeStream.on('close', async () => {
    const logs = [];
    const log = (msg) => logs.push(msg);
    try {
      await dbExporter.restoreSqlServerBackup(tempPath, log);
      // clean up file after successful restore
      try { if (fs.existsSync(tempPath)) fs.unlinkSync(tempPath); } catch (e) {}
      res.json({ message: 'SQL Server restored successfully', logs });
    } catch (err) {
      try { if (fs.existsSync(tempPath)) fs.unlinkSync(tempPath); } catch (e) {}
      res.status(500).json({ error: err.message, logs });
    }
  });

  writeStream.on('error', (err) => {
    try { if (fs.existsSync(tempPath)) fs.unlinkSync(tempPath); } catch (e) {}
    res.status(500).json({ error: 'Failed to write backup file to disk: ' + err.message });
  });
});

// Initialize MySQL schema by executing schema.sql
app.post('/api/init-schema', async (req, res) => {
  const schemaPath = path.join(__dirname, 'schema.sql');
  if (!fs.existsSync(schemaPath)) {
    return res.status(404).json({ error: 'schema.sql not found in server directory' });
  }

  let config;
  try {
    const configPath = path.join(__dirname, 'config.json');
    config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
  } catch (e) {
    return res.status(500).json({ error: 'Could not load config.json: ' + e.message });
  }

  let conn;
  const logs = [];
  try {
    conn = await mysql.createConnection({ ...config.mysql, multipleStatements: true });
    const schemaSql = fs.readFileSync(schemaPath, 'utf8');

    // Strip comment lines and split by semicolons
    const statements = schemaSql
      .split('\n')
      .filter(line => !line.trim().startsWith('--'))
      .join('\n')
      .split(';')
      .map(s => s.trim())
      .filter(s => s.length > 0);

    for (const stmt of statements) {
      try {
        await conn.query(stmt);
        const firstWord = stmt.split(/\s+/).slice(0, 3).join(' ');
        logs.push(`OK: ${firstWord}...`);
      } catch (err) {
        logs.push(`WARN: ${err.message.substring(0, 120)}`);
      }
    }

    res.json({ message: 'Schema initialization complete', logs });
  } catch (err) {
    res.status(500).json({ error: err.message, logs });
  } finally {
    if (conn) await conn.end();
  }
});

app.listen(PORT, () => {
  console.log(`Exporter dashboard listening on http://localhost:${PORT}`);
});
