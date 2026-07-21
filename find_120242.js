const sql = require('mssql/msnodesqlv8');
const {loadConfig} = require('./src/config.js');

async function run() {
    const config = loadConfig();
    let sqlConfig = { ...config.sqlserver };
    if (!sqlConfig.user && sqlConfig.connectionString) {
        sqlConfig = { connectionString: sqlConfig.connectionString };
    }
    const pool = await sql.connect(sqlConfig);
    
    const finalQ = `
    SELECT 
        ci.ClinicID,
        ep.PtCode,
        p.PatientCode,
        p.Sex,
        p.DOB,
        '' AS Column1,
        DATEDIFF(MONTH, p.DOB, GETDATE()) AS Age_Month,
        ep.VisitDate AS FirstVisit,
        ep.TransferInID AS TransferIN,
        ep.FeedingOption,
        ep.FeedingStartDate,
        ep.LeaveProgramDate,
        ep.LeaveProgramReason,
        ap.Province,
        ad.District,
        ac.Commune,
        av.Village,
        fu.NextAppointment AS AppointmentDate,
        DATEDIFF(DAY, fu.NextAppointment, GETDATE()) AS [MissAppointment_dd]
    FROM tblExposePatient ep
    LEFT JOIN tblPatient p ON ep.PtCode = p.PtCode
    LEFT JOIN tblCodeID ci ON ci.PtCode = ep.PtCode AND ci.ClinicId LIKE 'E%'
    OUTER APPLY (
        SELECT TOP 1 NextAppointment 
        FROM tblExposeFollowUp f 
        WHERE f.PtCode = ep.PtCode 
        ORDER BY VisitDate DESC
    ) fu
    LEFT JOIN Province ap ON ap.ProvinceCode = p.ProvinceCode
    LEFT JOIN District ad ON ad.DistrictCode = p.DistrictCode
    LEFT JOIN Commune ac ON ac.CommuneCode = p.CommuneCode
    LEFT JOIN Village av ON av.VillageCode = p.VillageCode
    WHERE ep.PtCode = '120242'
    `;
    const r = await pool.request().query(finalQ);
    console.log(JSON.stringify(r.recordset, null, 2));
    
    process.exit(0);
}
run().catch(console.error);
