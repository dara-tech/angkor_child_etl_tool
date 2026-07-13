select ci.ClinicID, 
CASE ISNULL(pcr.DNAPCR, '') 
  WHEN 'First PCR' THEN 1 
  WHEN 'Confirm First PCR' THEN 2 
  WHEN 'Second PCR' THEN 3 
  WHEN 'Confirm Second PCR' THEN 4 
  ELSE 0 
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


