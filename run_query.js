const sql = require('mssql/msnodesqlv8');
const {loadConfig} = require('./src/config.js');

const ids = [
120321, 130428, 130495, 130488, 130471, 120257, 130490, 130496, 130452, 120258,
130436, 120097, 130489, 120311, 130421, 130504, 130501, 130466, 130500, 130503,
130338, 130387, 120117, 120145, 130483, 120294, 120239, 120266, 120289, 120275,
130502, 130425, 130498, 130347, 120179, 120161, 130399, 130427, 120278, 120253,
120265, 130323, 120026, 120222, 120201, 130337, 120107, 120198, 120288, 130487,
120158, 120171, 120190, 120090, 119998, 119995, 120315, 120007, 120053
];

async function run() {
    const config = loadConfig();
    let sqlConfig = { ...config.sqlserver };
    if (!sqlConfig.user && sqlConfig.connectionString) {
        sqlConfig = { connectionString: sqlConfig.connectionString };
    }
    const pool = await sql.connect(sqlConfig);
    
    const idList = ids.map(id => `'${id}'`).join(',');
    
    let q = `SELECT count(*) as c FROM tblPatient WHERE PatientCode IN (${idList})`;
    let r = await pool.request().query(q);
    console.log('Match PatientCode:', r.recordset[0].c);
    
    q = `SELECT count(*) as c FROM tblPatient WHERE PtCode IN (${idList})`;
    r = await pool.request().query(q);
    console.log('Match PtCode:', r.recordset[0].c);

    // Let's actually pull the data and write it to CSV
    const finalQ = `
    SELECT 
        ci.ClinicID,
        p.PtCode,
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
    WHERE p.PatientCode IN (${idList}) OR p.PtCode IN (${idList})
    `;
    r = await pool.request().query(finalQ);
    console.log('Data count:', r.recordset.length);
    
    if (r.recordset.length > 0) {
        const fs = require('fs');
        const headers = Object.keys(r.recordset[0]).join(',');
        const rows = r.recordset.map(row => 
            Object.values(row).map(v => {
                if (v instanceof Date) return v.toISOString().split('T')[0];
                return v === null ? '' : v;
            }).join(',')
        );
        fs.writeFileSync('C:\\Users\\Dell\\.gemini\\antigravity-ide\\brain\\f8035620-2447-43b7-bf98-fd07edad0772\\scratch\\output.csv', headers + '\\n' + rows.join('\\n'));
        console.log('Wrote output.csv');
    }
    
    process.exit(0);
}
run().catch(console.error);
