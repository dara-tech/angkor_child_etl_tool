SELECT 
    c.CounselorID AS id,
    c.CounselorName AS code_name,
    CASE 
        WHEN CHARINDEX(' ', c.CounselorName) > 0 
        THEN SUBSTRING(c.CounselorName, CHARINDEX(' ', c.CounselorName) + 1, LEN(c.CounselorName))
        ELSE c.CounselorName 
    END AS first_name,
    CASE 
        WHEN CHARINDEX(' ', c.CounselorName) > 0 
        THEN SUBSTRING(c.CounselorName, 1, CHARINDEX(' ', c.CounselorName) - 1)
        ELSE '' 
    END AS last_name,
    NULL AS sex,
    NULL AS phone,
    IIF(c.CounselorID IN (29, 8, 28, 3, 30, 7), 1, 0) AS status_id,
    c.CreationDate AS created_at,
    c.CounselorID AS user_id
FROM Counselors c
ORDER BY c.CounselorID;
