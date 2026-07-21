select ci.ClinicID, 
CASE 
  WHEN pcr.TestDate IS NULL OR pcr.TestDate = '1900-01-01' THEN -1
  WHEN pcr.DNAPCR IN ('Confirm First PCR', 'Confirm Second PCR') THEN 4
  WHEN DATEDIFF(day, p.DOB, pcr.TestDate) <= 28 THEN 0
  WHEN DATEDIFF(day, p.DOB, pcr.TestDate) BETWEEN 29 AND 76 THEN 1
  WHEN DATEDIFF(day, p.DOB, pcr.TestDate) BETWEEN 77 AND 242 THEN 3
  WHEN DATEDIFF(day, p.DOB, pcr.TestDate) BETWEEN 243 AND 302 THEN 5
  ELSE 3
END as DNAPcr, 
ISNULL(pcr.TestDate, '1900-01-01') as DaPcrArr, '' as OI, ISNULL(pcr.TestDate, '1900-01-01') as DaBlood, '' as LabID, 
ISNULL(pcr.ResultDate, '1900-01-01') as DaReceive, ISNULL(pcr.ResultDate, '1900-01-01') as DaAnalys, 
CASE ISNULL(pcr.PCRResult, '')
  WHEN 'Positive' THEN 1
  WHEN 'Negative' THEN 0
  ELSE 2
END as Result, 
ISNULL(pcr.ResultDate, '1900-01-01') as DaRresult, 
'' as DBS, '' as Technic, '' as ResultIn, '' as Other, 
ci.ClinicID + right('0'+cast(day(ISNULL(ef.VisitDate, pcr.TestDate)) as varchar(2)),2) + right('0'+cast(Month(ISNULL(ef.VisitDate, pcr.TestDate)) as varchar(2)),2) + cast(year(ISNULL(ef.VisitDate, pcr.TestDate)) as varchar(4)) as TID
from tblExposePatientBloodTestPCR pcr
left join tblExposeFollowUp ef on pcr.ExpFollowUpID = ef.ExpFollowUpID
left outer join tblPatient p on p.PtCode = ISNULL(pcr.ptcode, ef.ptcode)
left outer join tblCodeID ci on ci.PtCode=ISNULL(pcr.ptcode, ef.ptcode) and ci.ClinicId like 'E%'
where ci.ClinicID is not null

UNION ALL

-- EXTRACT ALL ACTUAL ANTIBODY TESTS
select ci.ClinicID, 
5 as DNAPcr, 
ISNULL(ab.TestDate, '1900-01-01') as DaPcrArr, '' as OI, ISNULL(ab.TestDate, '1900-01-01') as DaBlood, '' as LabID, 
ISNULL(ab.ResultDate, '1900-01-01') as DaReceive, ISNULL(ab.ResultDate, '1900-01-01') as DaAnalys, 
CASE ISNULL(ab.AntibodyResult, '')
  WHEN 'Positive' THEN 1
  WHEN 'Negative' THEN 0
  ELSE 2
END as Result, 
ISNULL(ab.ResultDate, '1900-01-01') as DaRresult, 
'' as DBS, '' as Technic, '' as ResultIn, '' as Other, 
ci.ClinicID + right('0'+cast(day(ISNULL(ef.VisitDate, ab.TestDate)) as varchar(2)),2) + right('0'+cast(Month(ISNULL(ef.VisitDate, ab.TestDate)) as varchar(2)),2) + cast(year(ISNULL(ef.VisitDate, ab.TestDate)) as varchar(4)) as TID
from tblExposePatientBloodTestAntibody ab
left join tblExposeFollowUp ef on ab.ExpFollowUpID = ef.ExpFollowUpID
left outer join tblCodeID ci on ci.PtCode=ISNULL(ab.ptcode, ef.ptcode) and ci.ClinicId like 'E%'
where ci.ClinicID is not null


