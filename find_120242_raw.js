const sql = require('mssql/msnodesqlv8');
const {loadConfig} = require('./src/config.js');

async function run() {
    const config = loadConfig();
    let sqlConfig = { ...config.sqlserver };
    if (!sqlConfig.user && sqlConfig.connectionString) {
        sqlConfig = { connectionString: sqlConfig.connectionString };
    }
    const pool = await sql.connect(sqlConfig);
    
    let q = `SELECT * FROM tblPatient WHERE PtCode = '120242' OR PatientCode LIKE '%120242%'`;
    let r = await pool.request().query(q);
    console.log('tblPatient:', r.recordset);
    
    q = `SELECT * FROM tblExposePatient WHERE PtCode = '120242'`;
    r = await pool.request().query(q);
    console.log('tblExposePatient:', r.recordset);
    
    process.exit(0);
}
run().catch(console.error);
