const sql = require('mssql/msnodesqlv8');
const {loadConfig} = require('./src/config.js');

async function run() {
    const config = loadConfig();
    let sqlConfig = { ...config.sqlserver };
    if (!sqlConfig.user && sqlConfig.connectionString) {
        sqlConfig = { connectionString: sqlConfig.connectionString };
    }
    const pool = await sql.connect(sqlConfig);
    
    let q = `SELECT DISTINCT Status FROM tblExposePatient`;
    let r = await pool.request().query(q);
    console.log('tblExposePatient Status:', r.recordset);
    process.exit(0);
}
run().catch(console.error);
