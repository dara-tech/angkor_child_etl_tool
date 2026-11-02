SELECT 
    v.id AS vcct_id,
    'V17-03' AS site_code,
    IIF(v.RiskFactorID = 1, 1, 0) AS risk1,
    IIF(v.RiskFactorID = 2, 1, 0) AS risk2,
    IIF(v.RiskFactorID = 3, 1, 0) AS risk3,
    IIF(v.RiskFactorID = 4, 1, 0) AS risk4,
    IIF(v.RiskFactorID = 5, 1, 0) AS risk5,
    IIF(v.RiskFactorID = 6, 1, 0) AS risk6,
    IIF(v.RiskFactorID = 7, 1, 0) AS risk7,
    IIF(v.RiskFactorID = 8, 1, 0) AS risk8,
    IIF(v.RiskFactorID IN (9, 19), 1, 0) AS risk9,
    IIF(v.RiskFactorID = 10, 1, 0) AS risk10,
    IIF(v.RiskFactorID = 11, 1, 0) AS risk11,
    IIF(v.RiskFactorID = 12, 1, 0) AS risk12,
    IIF(v.RiskFactorID = 13, 1, 0) AS risk13,
    IIF(v.RiskFactorID = 14, 1, 0) AS risk14,
    IIF(v.RiskFactorID = 15, 1, 0) AS risk15,
    IIF(v.RiskFactorID = 16, 1, 0) AS risk16,
    IIF(v.RiskFactorID IN (17, 18), 1, 0) AS risk17,
    IIF(v.RiskFactorID = 20, 1, 0) AS risk18,
    v.CreationDate AS created_at
FROM tblVCCTRegistration v
ORDER BY v.id;
