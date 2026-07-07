// Select elements
const btnRunEtl = document.getElementById('btn-run-etl');
const btnClearTerminal = document.getElementById('btn-clear-terminal');
const terminalConsole = document.getElementById('terminal-console');
const btnUploadBackup = document.getElementById('btn-upload-backup');
const fileRestoreUpload = document.getElementById('file-restore-upload');

const sqlStatusCard = document.getElementById('sql-status-card');
const mysqlStatusCard = document.getElementById('mysql-status-card');
const sqlStatusText = sqlStatusCard.querySelector('.db-status');
const mysqlStatusText = mysqlStatusCard.querySelector('.db-status');

// Helper: Append log line to terminal console
function appendLog(message, type = 'system') {
  const line = document.createElement('div');
  line.className = `log-line ${type}`;
  
  const time = new Date().toLocaleTimeString();
  line.textContent = `[${time}] ${message}`;
  
  terminalConsole.appendChild(line);
  terminalConsole.scrollTop = terminalConsole.scrollHeight;
}

// Helper: Clear terminal
btnClearTerminal.addEventListener('click', () => {
  terminalConsole.innerHTML = '';
  appendLog('Console cleared.');
});

// Run ETL Pipeline (SSE Connection)
btnRunEtl.addEventListener('click', () => {
  // Clear and disable UI buttons during execution
  terminalConsole.innerHTML = '';
  appendLog('Starting new ETL extraction...', 'system');
  
  btnRunEtl.disabled = true;
  btnRunEtl.classList.add('pending');
  btnRunEtl.querySelector('svg').classList.add('spinning');
  
  // Add animation class to body/terminal
  document.body.classList.add('extraction-active');

  const eventSource = new EventSource('/api/export-stream');

  eventSource.onmessage = (event) => {
    const data = JSON.parse(event.data);
    
    if (data.message) {
      if (data.message.includes('ERROR') || data.message.includes('failed')) {
        appendLog(data.message, 'error');
      } else if (data.message.includes('successfully') || data.message.includes('completed')) {
        appendLog(data.message, 'success');
      } else {
        appendLog(data.message, 'system');
      }
    }

    if (data.status === 'done' || data.status === 'failed') {
      eventSource.close();
      resetEtlButton();
    }
  };

  eventSource.onerror = (err) => {
    appendLog('SSE EventSource disconnected or met an error.', 'error');
    eventSource.close();
    resetEtlButton();
  };
});

function resetEtlButton() {
  btnRunEtl.disabled = false;
  btnRunEtl.classList.remove('pending');
  btnRunEtl.querySelector('svg').classList.remove('spinning');
  document.body.classList.remove('extraction-active');
}

// Upload Backup Logic
btnUploadBackup.addEventListener('click', () => {
  fileRestoreUpload.click();
});

fileRestoreUpload.addEventListener('change', (e) => {
  const files = e.target.files;
  if (files.length > 0) {
    handleRestoreFile(files[0]);
  }
  // Reset input so the same file can be selected again if needed
  e.target.value = '';
});

function handleRestoreFile(file) {
  if (file.name.endsWith('.bak')) {
    handleSqlRestoreUpload(file);
    return;
  }
  
  if (!file.name.endsWith('.h149')) {
    appendLog('Invalid file format. Only .h149 or .bak files are accepted.', 'error');
    return;
  }

  appendLog(`Reading backup file for restore: ${file.name}...`, 'system');
  const reader = new FileReader();
  
  reader.onload = async (e) => {
    const fileContent = e.target.result;
    appendLog('Sending encrypted backup file to server for restore process...', 'system');
    
    try {
      // Hardcoded password from previous implementation, or let it be default
      const res = await fetch('/api/restore', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          encryptedData: fileContent,
          password: '090666847'
        })
      });

      const result = await res.json();
      
      if (result.logs && result.logs.length > 0) {
        result.logs.forEach(logLine => appendLog(logLine, 'system'));
      }
      
      if (res.ok) {
        appendLog(`Backup restore completed successfully!`, 'success');
      } else {
        appendLog(`Restore failed: ${result.error}`, 'error');
      }
    } catch (err) {
      appendLog(`Error executing restore: ${err.message}`, 'error');
    }
  };

  reader.onerror = () => {
    appendLog('Error reading backup file from filesystem.', 'error');
  };

  reader.readAsText(file);
}

async function handleSqlRestoreUpload(file) {
  appendLog(`Preparing to restore SQL Server backup: ${file.name}...`, 'system');
  appendLog('Uploading backup file to server. This may take a while depending on file size...', 'system');
  
  try {
    const res = await fetch('/api/restore-sqlserver', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-mssql-bak',
        'X-File-Name': encodeURIComponent(file.name)
      },
      body: file
    });
    
    const data = await res.json();
    
    if (res.ok) {
      if (data.logs && data.logs.length > 0) {
        data.logs.forEach(msg => appendLog(msg, 'system'));
      }
      appendLog('SQL Server backup restored successfully!', 'success');
    } else {
      appendLog(`Failed to restore SQL Server: ${data.error}`, 'error');
    }
  } catch (err) {
    appendLog(`Error executing SQL Server restore: ${err.message}`, 'error');
  }
}

// Check Database Connections Status
async function checkStatus() {
  sqlStatusCard.className = 'status-card pending';
  sqlStatusText.textContent = 'Checking...';
  mysqlStatusCard.className = 'status-card pending';
  mysqlStatusText.textContent = 'Checking...';

  try {
    const res = await fetch('/api/status');
    const status = await res.json();

    if (status.sqlserver.connected) {
      sqlStatusCard.className = 'status-card connected';
      sqlStatusText.textContent = 'Connected';
    } else {
      sqlStatusCard.className = 'status-card error';
      sqlStatusText.textContent = 'Error';
    }

    if (status.mysql.connected) {
      mysqlStatusCard.className = 'status-card connected';
      mysqlStatusText.textContent = 'Connected';
    } else {
      mysqlStatusCard.className = 'status-card error';
      mysqlStatusText.textContent = 'Error';
    }
  } catch (err) {
    sqlStatusCard.className = 'status-card error';
    sqlStatusText.textContent = 'Offline';
    mysqlStatusCard.className = 'status-card error';
    mysqlStatusText.textContent = 'Offline';
  }
}

// Check on load
checkStatus();
