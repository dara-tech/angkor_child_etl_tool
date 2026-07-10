const sql = require('mssql/msnodesqlv8');
const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');
const { loadConfig } = require('./config');

// Format values (especially Date objects) for MySQL insertion
function formatValue(value) {
  if (value === null || value === undefined) return null;
  if (value instanceof Date) {
    if (isNaN(value.getTime())) return '1900-01-01';
    // Format to YYYY-MM-DD
    return value.toISOString().split('T')[0];
  }
  return value;
}

// Helper to read SQL file content
function readSqlFile(filename) {
  return fs.readFileSync(path.join(__dirname, '..', 'sql', filename), 'utf8');
}

// Run the ETL pipeline
async function runETL(logCallback) {
  const config = loadConfig();
  logCallback('Connecting to SQL Server (Source)...');
  let sqlConfig = { ...config.sqlserver, requestTimeout: 300000 };
  if (!config.sqlserver.user && config.sqlserver.connectionString) {
    sqlConfig = { connectionString: config.sqlserver.connectionString, requestTimeout: 300000 };
  }
  const sqlPool = await sql.connect(sqlConfig);
  
  logCallback('Connecting to MySQL (Target)...');
  const mysqlConn = await mysql.createConnection(config.mysql);
  
  try {
    // 0. Drop and Recreate tblCodeID on SQL Server
    logCallback('Initializing tblCodeID on SQL Server...');
    const createTblQuery = readSqlFile('init_tblCodeID.sql');
    await sqlPool.request().query(createTblQuery);
    logCallback('tblCodeID initialized successfully.');

    logCallback('Enforcing NULL schema allowances on MySQL target...');
    try {
      await mysqlConn.execute('ALTER TABLE tbletest MODIFY Result int NULL');
      await mysqlConn.execute('ALTER TABLE tbletest MODIFY TID VARCHAR(50)');
      await mysqlConn.execute('ALTER TABLE tblevmain MODIFY DNA int NULL');
      await mysqlConn.execute('ALTER TABLE tblevmain MODIFY DNAPre int NULL');
      await mysqlConn.execute('ALTER TABLE tblevmain MODIFY Antibody int NULL');
      await mysqlConn.execute('ALTER TABLE tblevmain MODIFY TestID VARCHAR(50)');
    } catch (e) {
      logCallback(`Schema warning: ${e.message}`);
    }

    // List of ETL steps (source query file, target table name)
    const etlSteps = [
      { name: 'tblcimain', queryFile: 'tblcimain.sql' },
      { name: 'tblcumain', queryFile: 'tblcumain.sql' },
      { name: 'tblpatienttest', queryFile: 'tblpatienttest.sql' },
      { name: 'tblcvpatientstatus', queryFile: 'tblcvpatientstatus.sql' },
      { name: 'tblcvmain', queryFile: 'tblcvmain.sql' },
      { name: 'tblcart', queryFile: 'tblcart.sql' },
      { name: 'tblclink', queryFile: 'tblclink.sql' },
      { name: 'tblcvtbdrug', queryFile: 'tblcvtbdrug.sql' },
      { name: 'tblcvoidrug', queryFile: 'tblcvoidrug.sql' },
      { name: 'tblcvarvdrug', queryFile: 'tblcvarvdrug.sql' },
      { name: 'tbleimain', queryFile: 'tbleimain.sql' },
      { name: 'tblelink', queryFile: 'tblelink.sql' },
      { name: 'tbletest', queryFile: 'tbletest.sql' },
      { name: 'tblevarvdrug', queryFile: 'tblevarvdrug.sql' },
      { name: 'tblevmain', queryFile: 'tblevmain.sql' },
      { name: 'tblevpatientstatus', queryFile: 'tblevpatientstatus.sql' }
    ];

    for (const step of etlSteps) {
      logCallback(`Transferring ${step.name}...`);
      
      // 1. Delete target data in MySQL
      await mysqlConn.query(`TRUNCATE TABLE ${step.name}`);
      
      // 2. Fetch data from SQL Server
      const query = readSqlFile(step.queryFile);
      const result = await sqlPool.request().query(query);
      const rows = result.recordset;
      
      if (rows && rows.length > 0) {
        logCallback(`Fetched ${rows.length} rows for ${step.name}. Inserting into MySQL...`);
        
        // Use column names from the SQL Server result so extra columns
        // in the MySQL table (not in our SELECT) get their default values
        const columnNames = Object.keys(rows[0]).map(c => `\`${c}\``).join(', ');
        const columnsCount = Object.keys(rows[0]).length;
        const formattedRows = rows.map(row => Object.values(row).map(val => formatValue(val)));
        
        // Chunk sizes of 500 to keep queries within size limits
        const chunkSize = 500;
        for (let i = 0; i < formattedRows.length; i += chunkSize) {
          const chunk = formattedRows.slice(i, i + chunkSize);
          
          const placeholders = chunk.map(() => `(${Array(columnsCount).fill('?').join(', ')})`).join(', ');
          const values = chunk.flat();
          const sqlInsert = `INSERT IGNORE INTO ${step.name} (${columnNames}) VALUES ${placeholders}`;
          
          await mysqlConn.query(sqlInsert, values);
        }
        
        logCallback(`Successfully transferred ${rows.length} rows to ${step.name}.`);
      } else {
        logCallback(`No rows fetched for ${step.name}.`);
      }
    }

    logCallback('ETL Export process completed successfully.');
  } finally {
    // Close connections
    await sqlPool.close();
    await mysqlConn.end();
  }
}

module.exports = {
  runETL
};
