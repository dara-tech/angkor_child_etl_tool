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
    'V17-03' AS site_code,
    v.id AS vcct_id,
    CAST(v.TestDate AS DATE) AS registration_date,
    v.PatientCode AS pmrs_code,
    CAST(v.id AS VARCHAR(20)) AS hts_code,
    NULL AS uuic,
    NULL AS idpoor,
    IIF(v.Sex = 'M', 1, 2) AS sex,
    CAST(v.DOB AS DATE) AS dob,
    CASE v.MarriedStatus 
        WHEN 'Single' THEN 1 
        WHEN 'Married' THEN 2 
        WHEN 'Widow-Widower' THEN 3 
        ELSE 1 
    END AS marital_status_id,
    CASE v.Occupation
        WHEN 'Direct Sex Worker' THEN 1
        WHEN 'Garment Factory Staff' THEN 3
        WHEN 'Farmer or Fishery' THEN 4
        WHEN 'Housewife' THEN 9
        WHEN 'Indirect Sex Worker' THEN 10
        WHEN 'Student' THEN 20
        ELSE 24
    END AS occupation_id,
    IIF(v.Occupation NOT IN ('Direct Sex Worker', 'Garment Factory Staff', 'Farmer or Fishery', 'Housewife', 'Indirect Sex Worker', 'Student'), ISNULL(v.Occupation, ''), '') AS occupation_other,
    CASE v.StudyGrade
        WHEN 'No Study' THEN 1
        WHEN 'Primary School' THEN 2
        WHEN 'Secondary School' THEN 3
        WHEN 'High School' THEN 4
        WHEN 'University' THEN 5
        ELSE 0
    END AS education_id,
    v.ProvinceCode AS province_id,
    v.DistrictCode AS district_id,
    v.CommuneCode AS commune_id,
    v.VillageCode AS village_id,
    p.Phone AS phone_number,
    33 AS country_of_birth_id,
    IIF(v.Race <> 'Cambodia', ISNULL(v.Race, ''), '') AS country_of_birth_other,
    0 AS is_migrant,
    ISNULL(v.TransferInID, 0) AS refer_from_id,
    CASE 
        WHEN (DATEDIFF(YEAR, v.DOB, v.TestDate) - 
              CASE WHEN (MONTH(v.DOB) > MONTH(v.TestDate) OR (MONTH(v.DOB) = MONTH(v.TestDate) AND DAY(v.DOB) > DAY(v.TestDate))) THEN 1 ELSE 0 END) < 15 THEN 6
        WHEN v.RiskFactorID = 12 THEN 2
        WHEN v.RiskFactorID IN (10, 11) THEN 5
        WHEN v.Occupation IN ('Direct Sex Worker', 'Indirect Sex Worker', 'Casino Staff') AND v.Sex = 'F' THEN 1
        WHEN v.Occupation IN ('Direct Sex Worker', 'Indirect Sex Worker', 'Casino Staff') AND v.Sex = 'M' THEN 7
        WHEN v.ReasonServiceID IN (4, 8) AND v.Sex = 'F' THEN 8
        ELSE 6
    END AS patient_type_id,
    IIF(v.TestingHistory = 'Tested', 1, 0) AS history_of_test,
    CASE v.TestingHistoryResult WHEN 'Positive' THEN 1 WHEN 'Negative' THEN 2 ELSE 0 END AS history_of_test_result,
    CASE v.CareGiverHIVStatus WHEN 'Positive' THEN 1 WHEN 'Negative' THEN 2 ELSE 0 END AS history_partner_result1,
    0 AS history_partner_result2,
    IIF(v.ApprovedTest = 1, 1, 0) AS is_agree_test_hiv,
    CASE v.TestResult WHEN 'Positive' THEN 2 WHEN 'Negative' THEN 1 ELSE 3 END AS combo_result,
    CASE v.TestResult WHEN 'Positive' THEN 2 WHEN 'Negative' THEN 1 ELSE 3 END AS hiv_result,
    0 AS is_agree_test_rtri,
    0 AS rtri_result_id,
    0 AS is_first_invalid,
    0 AS is_agree_test_vl,
    0 AS vl_result,
    0 AS rita_result,
    IIF(v.PostCounselling = 1, 1, 0) AS post_counseling_id,
    CAST(v.PostCounsellingDate AS DATE) AS post_counseling_date,
    ISNULL(v.TransferToID, 0) AS refer_to_service_id,
    NULL AS refer_to_other,
    v.CounselorID AS counselor_id,
    v.CreationDate AS created_at
FROM DeduplicatedVCCT v
LEFT OUTER JOIN tblPatient p ON v.PatientCode = p.PatientCode
WHERE v.rn = 1
ORDER BY v.id;
