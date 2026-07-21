const mysql = require('mysql2/promise');
const sql = require('mssql/msnodesqlv8');
const { loadConfig } = require('./config');
const { encryptText, decryptText } = require('./crypto-utils');

// Generate the encrypted database dump text of specific tables from MySQL
async function generateBackup(password, logCallback) {
  const log = logCallback || (() => {});
  const config = loadConfig();
  const mysqlConn = await mysql.createConnection(config.mysql);
  
  try {
    let sqlText = '';
    
    // Header
    sqlText += `-- Database Exporter Backup\n`;
    sqlText += `-- Generated: ${new Date().toISOString()}\n\n`;
    
    // Fetch all tables dynamically from MySQL target database for full schema backup
    const [tableRows] = await mysqlConn.query(`SHOW TABLES`);
    const tables = tableRows.map(row => Object.values(row)[0]);
    
    const BATCH_SIZE = 500; // rows per INSERT statement

    for (const table of tables) {
      // Fetch table creation DDL
      try {
        const [createResult] = await mysqlConn.query(`SHOW CREATE TABLE ${table}`);
        if (createResult.length > 0) {
          sqlText += `DROP TABLE IF EXISTS \`${table}\`;\n`;
          sqlText += `${createResult[0]['Create Table']};\n\n`;
        }
      } catch (err) {
        // Table might not exist yet
        log(`Skipping ${table}: ${err.message}`);
        continue;
      }
      
      // Fetch data
      const [rows] = await mysqlConn.query(`SELECT * FROM ${table}`);
      log(`Backing up ${table}: ${rows.length} rows...`);

      if (rows.length > 0) {
        const columns = Object.keys(rows[0]).map(col => `\`${col}\``).join(', ');

        for (let i = 0; i < rows.length; i += BATCH_SIZE) {
          const batch = rows.slice(i, i + BATCH_SIZE);
          const valueSets = batch.map(row => {
            const vals = Object.values(row).map(val => {
              if (val === null || val === undefined) return 'NULL';
              if (typeof val === 'string') return mysqlConn.escape(val);
              if (val instanceof Date) return mysqlConn.escape(val.toISOString().split('T')[0]);
              return val;
            }).join(', ');
            return `(${vals})`;
          }).join(',\n  ');

          sqlText += `INSERT INTO \`${table}\` (${columns}) VALUES\n  ${valueSets};\n`;
        }
        sqlText += `\n`;
      }
    }
    
    log(`SQL dump built (${Math.round(sqlText.length / 1024)} KB). Encrypting...`);

    // Encrypt the SQL script
    const encryptedData = encryptText(sqlText, password);
    log('Encryption complete.');
    return encryptedData;
  } finally {
    await mysqlConn.end();
  }
}

// Restore MySQL Database from encrypted backup data
async function restoreBackup(encryptedData, password, logCallback) {
  const config = loadConfig();
  const mysqlConn = await mysql.createConnection(config.mysql);
  
  try {
    logCallback('Decrypting backup file...');
    const decryptedSql = decryptText(encryptedData, password);
    logCallback('Backup decrypted successfully. Executing SQL commands...');
    
    // Split SQL commands (naive split by semicolon followed by newline)
    const commands = decryptedSql.split(/;\s*\n/);
    let successCount = 0;
    
    for (let cmd of commands) {
      cmd = cmd.trim();
      if (cmd && !cmd.startsWith('--')) {
        await mysqlConn.query(cmd);
        successCount++;
      }
    }
    logCallback(`Successfully executed ${successCount} restore statements.`);
  } finally {
    await mysqlConn.end();
  }
}

// Restore SQL Server database from a .bak file on disk
async function restoreSqlServerBackup(filePath, logCallback) {
  const config = loadConfig();
  if (!config.sqlserver || !config.sqlserver.database) {
    throw new Error('SQL Server target database configuration is missing');
  }

  const dbName = config.sqlserver.database;
  
  // Connect to the master database instead of the target database so we can restore
  let masterConfig;
  if (!config.sqlserver.user) {
    // Windows Auth via connection string wrapped in object
    masterConfig = { connectionString: config.sqlserver.connectionString.replace(`Database=${dbName}`, 'Database=master') };
  } else {
    masterConfig = { ...config.sqlserver, database: 'master' };
  }
  
  logCallback(`Connecting to SQL Server master database...`);
  const pool = await sql.connect(masterConfig);
  
  try {
    logCallback(`Forcing single user mode on [${dbName}] to drop existing connections...`);
    try {
      await pool.request().query(`ALTER DATABASE [${dbName}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE`);
    } catch (e) {
      logCallback(`Note: Database might not exist yet or error on SINGLE_USER: ${e.message}`);
    }

    logCallback(`Starting RESTORE DATABASE operation from ${filePath}...`);
    // Note: The SQL Server service must have read access to the filePath
    await pool.request().query(`RESTORE DATABASE [${dbName}] FROM DISK = '${filePath}' WITH REPLACE`);
    logCallback(`RESTORE command executed successfully.`);

    logCallback(`Restoring multi-user mode...`);
    await pool.request().query(`ALTER DATABASE [${dbName}] SET MULTI_USER`);
    logCallback(`SQL Server restore completed.`);
  } finally {
    try {
      // Always try to set multi user back if we fail
      await pool.request().query(`ALTER DATABASE [${dbName}] SET MULTI_USER`);
    } catch (e) {}
    await pool.close();
  }
}

module.exports = {
  generateBackup,
  restoreBackup,
  restoreSqlServerBackup
};
