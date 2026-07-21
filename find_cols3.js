const sql = require('mssql/msnodesqlv8');
const {loadConfig} = require('./src/config.js');

async function run() {
    const config = loadConfig();
    let sqlConfig = { ...config.sqlserver };
    if (!sqlConfig.user && sqlConfig.connectionString) {
        sqlConfig = { connectionString: sqlConfig.connectionString };
    }
    const pool = await sql.connect(sqlConfig);
    
    let q = `SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblPatient'`;
    let r = await pool.request().query(q);
    console.log('tblPatient:', r.recordset.map(x => x.COLUMN_NAME).join(', '));
    process.exit(0);
}
run().catch(console.error);
