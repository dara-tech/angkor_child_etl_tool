SELECT 
    v.id AS vcct_id,
    'V17-03' AS site_code,
    IIF(v.ReasonServiceID = 1, 1, 0) AS rs1,
    IIF(v.ReasonServiceID = 2, 1, 0) AS rs2,
    IIF(v.ReasonServiceID = 3, 1, 0) AS rs3,
    IIF(v.ReasonServiceID IN (4, 8), 1, 0) AS rs4,
    IIF(v.ReasonServiceID = 5, 1, 0) AS rs5,
    IIF(v.ReasonServiceID = 6, 1, 0) AS rs6,
    IIF(v.ReasonServiceID = 7, 1, 0) AS rs7,
    IIF(v.ReasonServiceID = 9, 1, 0) AS rs8,
    IIF(v.ReasonServiceID = 10, 1, 0) AS rs9,
    IIF(v.ReasonServiceID IN (11, 15), 1, 0) AS rs10,
    IIF(v.ReasonServiceID = 12, 1, 0) AS rs11,
    IIF(v.ReasonServiceID = 13, 1, 0) AS rs12,
    IIF(v.ReasonServiceID = 14, 1, 0) AS rs13,
    IIF(v.ReasonServiceID = 16, 1, 0) AS rs14,
    v.CreationDate AS created_at,
    v.CounselorID AS created_by_user_id
FROM tblVCCTRegistration v
ORDER BY v.id;
