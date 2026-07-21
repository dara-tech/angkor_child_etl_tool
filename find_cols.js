const sql = require('mssql/msnodesqlv8');
const {loadConfig} = require('./src/config.js');

async function run() {
    const config = loadConfig();
    let sqlConfig = { ...config.sqlserver };
    if (!sqlConfig.user && sqlConfig.connectionString) {
        sqlConfig = { connectionString: sqlConfig.connectionString };
    }
    const pool = await sql.connect(sqlConfig);
    
    // search for columns like %Feeding%, %Age_Month%, %Appointment%, %Transfer%
    const q = `
    SELECT TABLE_NAME, COLUMN_NAME
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE COLUMN_NAME LIKE '%Feeding%'
       OR COLUMN_NAME LIKE '%Age_Month%'
       OR COLUMN_NAME LIKE '%PatientCode%'
       OR COLUMN_NAME LIKE '%Appointment%'
       OR COLUMN_NAME LIKE '%TransferIN%'
       OR COLUMN_NAME LIKE '%LeaveProgram%'
       OR COLUMN_NAME LIKE '%MissAppointment%'
    `;
    const r = await pool.request().query(q);
    console.log('Columns found:', r.recordset);
    process.exit(0);
}
run().catch(console.error);
