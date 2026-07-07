const sql = require('mssql/msnodesqlv8');
const mysql = require('mysql2/promise');
const { loadConfig } = require('./config');

// Test connections to SQL Server and MySQL
async function testConnections() {
  const config = loadConfig();
  const status = {
    sqlserver: { connected: false, error: null },
    mysql: { connected: false, error: null }
  };
  
  // Test SQL Server
  try {
    let sqlConfig = { ...config.sqlserver, requestTimeout: 3000 };
    if (config.sqlserver.connectionString) {
      sqlConfig = { connectionString: config.sqlserver.connectionString, requestTimeout: 3000 };
    }
    const sqlPool = await sql.connect(sqlConfig);
    await sqlPool.close();
    status.sqlserver.connected = true;
  } catch (err) {
    status.sqlserver.error = err.message || (typeof err === 'string' ? err : JSON.stringify(err));
  }
  
  // Test MySQL
  try {
    const mysqlConn = await mysql.createConnection({ ...config.mysql, connectTimeout: 3000 });
    await mysqlConn.end();
    status.mysql.connected = true;
  } catch (err) {
    status.mysql.error = err.message || (typeof err === 'string' ? err : JSON.stringify(err));
  }
  
  return status;
}

module.exports = {
  testConnections
};
