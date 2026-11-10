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
    IIF(v.RiskFactorID IN (10, 11), 1, 0) AS risk1,
    0 AS risk2,
    IIF(v.Occupation IN ('Direct Sex Worker', 'Indirect Sex Worker', 'Casino Staff') AND v.Sex = 'F', 1, 0) AS risk3,
    IIF(v.RiskFactorID = 12, 1, 0) AS risk4,
    0 AS risk5,
    IIF(v.RiskFactorID IN (5, 6) OR v.CareGiverHIVStatus = 'Positive', 1, 0) AS risk6,
    IIF(v.RiskFactorID IN (3, 4), 1, 0) AS risk7,
    IIF(v.RiskFactorID = 1, 1, 0) AS risk8,
    IIF(v.RiskFactorID IN (9, 19), 1, 0) AS risk9,
    IIF(v.RiskFactorID = 2, 1, 0) AS risk10,
    IIF(v.RiskFactorID = 16 OR v.ReasonServiceID = 12, 1, 0) AS risk11,
    IIF(v.RiskFactorID = 7, 1, 0) AS risk12,
    IIF(v.RiskFactorID = 8, 1, 0) AS risk13,
    IIF(v.ReasonServiceID IN (11, 15), 1, 0) AS risk14,
    IIF(v.ReasonServiceID IN (4, 8) AND v.Sex = 'F', 1, 0) AS risk15,
    IIF(v.RiskFactorID IN (15, 17, 18) OR v.ReasonServiceID = 16, 1, 0) AS risk16,
    0 AS risk17,
    0 AS risk18,
    v.CreationDate AS created_at
FROM DeduplicatedVCCT v
WHERE v.rn = 1
ORDER BY v.id;
