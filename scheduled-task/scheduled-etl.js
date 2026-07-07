const { runETL } = require('../src/etl');
const { generateBackup } = require('../src/backup');
const { decryptText } = require('../src/crypto-utils');
const { testConnections } = require('../src/db');
const fs = require('fs');
const path = require('path');

function holdWindowOnFailure() {
  if (process.stdin.isTTY) {
    console.log('\n[!] Press any key to exit...');
    process.stdin.setRawMode(true);
    process.stdin.resume();
    process.stdin.on('data', () => process.exit(1));
  } else {
    process.exit(1);
  }
}

async function main() {
  console.log(`[${new Date().toISOString()}] Starting scheduled ETL process...`);
  
  try {
    // 0. Test connections first to provide clean errors to the user
    console.log(`[${new Date().toISOString()}] Validating database connections...`);
    const status = await testConnections();
    
    if (!status.sqlserver.connected) {
      console.error(`\n[ERROR] Could not connect to SQL Server!`);
      console.error(`Reason: ${status.sqlserver.error}`);
      console.error(`Please check your config.json file and ensure the SQL Server is running.`);
      return holdWindowOnFailure();
    }
    
    if (!status.mysql.connected) {
      console.error(`\n[ERROR] Could not connect to MySQL!`);
      console.error(`Reason: ${status.mysql.error}`);
      console.error(`Please check your config.json file and ensure MySQL is running.`);
      return holdWindowOnFailure();
    }
    
    console.log(`[${new Date().toISOString()}] Connections validated successfully.`);

    // 1. Run the ETL process (SQL Server -> MySQL)
    await runETL((msg) => {
      console.log(`[${new Date().toISOString()}] ETL: ${msg}`);
    });
    
    console.log(`[${new Date().toISOString()}] ETL process completed successfully. Generating backup...`);
    
    // 2. Generate the backup from MySQL
    // Default password used in the dashboard API is '090666847'
    const password = '090666847'; 
    const encryptedData = await generateBackup(password, (msg) => {
      console.log(`[${new Date().toISOString()}] BACKUP: ${msg}`);
    });
    
    // Decrypt the data back into plain SQL
    console.log(`[${new Date().toISOString()}] Decrypting backup to raw SQL format...`);
    const plainSql = decryptText(encryptedData, password);
    
    // 3. Save it to a 'converted_sql' folder alongside the executable
    let outputDir;
    if (process.pkg) {
      outputDir = path.join(path.dirname(process.execPath), 'converted_sql');
    } else {
      outputDir = path.join(__dirname, 'converted_sql');
    }
    
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir);
    }
    
    // Create a filename with timestamp
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const filename = `preart_backup_${timestamp}.sql`;
    const outputPath = path.join(outputDir, filename);
    
    fs.writeFileSync(outputPath, plainSql);
    
    console.log(`[${new Date().toISOString()}] SQL script saved successfully to: ${outputPath}`);
    console.log(`[${new Date().toISOString()}] Scheduled task finished completely.`);
    
    // Hold window on success as well so they know it finished if double-clicked
    if (process.stdin.isTTY) {
      console.log('\n[SUCCESS] Press any key to exit...');
      process.stdin.setRawMode(true);
      process.stdin.resume();
      process.stdin.on('data', () => process.exit(0));
    } else {
      process.exit(0);
    }
  } catch (error) {
    console.error(`\n[FATAL ERROR] An unexpected error occurred:`);
    console.error(error.message || error);
    holdWindowOnFailure();
  }
}

main();
