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
FROM tblVCCTRegistration v
ORDER BY v.id;
