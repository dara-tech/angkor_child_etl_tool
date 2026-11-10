WITH DeduplicatedVCCT AS (
    SELECT 
        v.*,
        ROW_NUMBER() OVER (
            PARTITION BY 
                CASE 
                    WHEN v.PatientCode IS NOT NULL AND v.PatientCode <> '' THEN v.PatientCode 
                    ELSE CAST(v.id AS VARCHAR) 
                END,
                v.TestResult,
                YEAR(v.TestDate),
                MONTH(v.TestDate)
            ORDER BY v.TestDate ASC, v.id ASC
        ) AS rn
    FROM tblVCCTRegistration v
)
SELECT 
    v.id AS vcct_id,
    'V17-03' AS site_code,
    IIF(v.ReasonServiceID IN (1, 2, 7), 1, 0) AS rs1,
    0 AS rs2,
    0 AS rs3,
    IIF(v.ReasonServiceID IN (4, 8), 1, 0) AS rs4,
    IIF(v.ReasonServiceID IN (11, 15), 1, 0) AS rs5,
    0 AS rs6,
    0 AS rs7,
    IIF(v.ReasonServiceID IN (5, 9), 1, 0) AS rs8,
    IIF(v.ReasonServiceID = 3, 1, 0) AS rs9,
    0 AS rs10,
    0 AS rs11,
    0 AS rs12,
    IIF(v.ReasonServiceID = 12, 1, 0) AS rs13,
    IIF(v.ReasonServiceID IN (6, 10, 13, 14, 16), 1, 0) AS rs14,
    v.CreationDate AS created_at,
    v.CounselorID AS created_by_user_id
FROM DeduplicatedVCCT v
WHERE v.rn = 1
ORDER BY v.id;
