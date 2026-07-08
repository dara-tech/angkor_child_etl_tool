const fs = require('fs');
const path = require('path');

// Load configurations
function loadConfig() {
  let configPath;
  if (process.pkg) {
    // If running inside a pkg executable, look for config.json in the same folder as the .exe
    configPath = path.join(path.dirname(process.execPath), 'config.json');
  } else {
    // Standard node environment
    configPath = path.join(__dirname, '..', 'config.json');
  }
  
  if (fs.existsSync(configPath)) {
    const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
    if (config.sqlserver) {
      const server = config.sqlserver.server || 'localhost';
      const port = config.sqlserver.port || 1433;
      const database = config.sqlserver.database || 'HIS';
      const user = config.sqlserver.user;
      
      const password = config.sqlserver.password;
      
      let serverStr = server;
      if (config.sqlserver.options && config.sqlserver.options.instanceName) {
        serverStr += `\\${config.sqlserver.options.instanceName}`;
      } else if (port) {
        serverStr += `,${port}`;
      }
      
      if (!user) {
        config.sqlserver.connectionString = `Driver={ODBC Driver 17 for SQL Server};Server=${serverStr};Database=${database};Trusted_Connection=yes;TrustServerCertificate=yes;`;
      } else {
        config.sqlserver.connectionString = `Driver={ODBC Driver 17 for SQL Server};Server=${serverStr};Database=${database};Uid=${user};Pwd=${password};TrustServerCertificate=yes;`;
      }
    }
    return config;
  }
  throw new Error('config.json not found');
}

module.exports = {
  loadConfig
};
