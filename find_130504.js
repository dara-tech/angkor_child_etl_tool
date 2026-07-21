const sql = require('mssql/msnodesqlv8');
const {loadConfig} = require('./src/config.js');

async function run() {
    const config = loadConfig();
    let sqlConfig = { ...config.sqlserver };
    if (!sqlConfig.user && sqlConfig.connectionString) {
        sqlConfig = { connectionString: sqlConfig.connectionString };
    }
    const pool = await sql.connect(sqlConfig);
    
    let q = `SELECT PtCode, PatientCode, Sex, DOB FROM tblPatient WHERE PtCode IN (130504, 120222)`;
    let r = await pool.request().query(q);
    console.log('tblPatient:', r.recordset);
    
    q = `SELECT PtCode, VisitDate, LeaveProgramDate FROM tblExposePatient WHERE PtCode IN (130504, 120222)`;
    r = await pool.request().query(q);
    console.log('tblExposePatient:', r.recordset);
    
    // Check if they have an active status based on our recent query
    q = `SELECT 
    ci.ClinicID,
    p.PtCode,
    p.PatientCode,
    ep.LeaveProgramDate,
    ep.LeaveProgramReason
FROM tblExposePatient ep
LEFT JOIN tblPatient p ON ep.PtCode = p.PtCode
LEFT JOIN tblCodeID ci ON ci.PtCode = ep.PtCode AND ci.ClinicId LIKE 'E%'
WHERE ep.PtCode IN (130504, 120222)`;
    r = await pool.request().query(q);
    console.log('QueryResult for these two:', r.recordset);
    
    process.exit(0);
}
run().catch(console.error);
