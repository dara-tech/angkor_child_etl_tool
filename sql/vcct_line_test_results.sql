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
    1 AS line_control,
    IIF(v.TestResult = 'Positive', 1, 0) AS line_positive,
    0 AS line_longterm,
    0 AS cambo_ag,
    IIF(v.TestResult = 'Positive', 1, 0) AS cambo_ab,
    v.CreationDate AS created_at,
    v.CounselorID AS created_by_user_id
FROM DeduplicatedVCCT v
WHERE v.rn = 1
ORDER BY v.id;
