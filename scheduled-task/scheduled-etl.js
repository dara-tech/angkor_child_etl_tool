const { runETL } = require('../src/etl');
const { generateBackup } = require('../src/backup');
const { decryptText } = require('../src/crypto-utils');
const fs = require('fs');
const path = require('path');

async function main() {
  console.log(`[${new Date().toISOString()}] Starting scheduled ETL process...`);
  
  try {
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
    
    // 3. Save it to a 'converted_sql' folder
    const outputDir = path.join(__dirname, 'converted_sql');
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
    
    process.exit(0);
  } catch (error) {
    console.error(`[${new Date().toISOString()}] ERROR during scheduled task:`, error);
    process.exit(1);
  }
}

main();
