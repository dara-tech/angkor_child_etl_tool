select ci.ClinicID, ISNULL(ef.VisitDate, '1900-01-01') as DatVisit, iif(ef.FUStatus='Unplanned','1',iif(ef.FUStatus='OnTime','2',iif(ef.FUStatus='Late','3','-1'))) as TypeVisit, '0' as Temp, '0' as Pulse, '0' as Resp, '0' as Head, 
ISNULL(ef.Weight, 0) as Weight, ISNULL(ef.Height, 0) as Height, '-1' as Malnutrition, ISNULL(ef.WeightHeight, 0) as WH, '-1' as BCG, '-1' as OPV, '-1' as Measles, '' as Other, ISNULL(ef.FormulaType, -1) as Feeding, 
CASE ISNULL(pcr.PCRResult, '')
  WHEN 'Positive' THEN 1
  WHEN 'Negative' THEN 0
  ELSE NULL
END as DNA, 
ISNULL(pcr.ResultDate, '1900-01-01') as DaResult, 
LEFT(CAST(ISNULL(ef.ExpFollowUpID, ABS(CHECKSUM(NEWID()))) AS VARCHAR(17)), 17) as Vid, 
CASE ISNULL(pcr.DNAPCR, '') 
  WHEN 'First PCR' THEN 1 
  WHEN 'Confirm First PCR' THEN 2 
  WHEN 'Second PCR' THEN 3 
  WHEN 'Confirm Second PCR' THEN 4 
  ELSE NULL 
END as DNAPre, 
LEFT(CAST(ISNULL(pcr.id, ABS(CHECKSUM(NEWID()))) AS VARCHAR(17)), 17) as TestID, ISNULL(ef.NextAppointment, '1900-01-01') as DaApp, 
CASE ISNULL(ab.AntibodyResult, '')
  WHEN 'Positive' THEN 1
  WHEN 'Negative' THEN 0
  ELSE NULL
END as Antibody, 
ISNULL(ab.ResultDate, '1900-01-01') as DaAntibody, '-1' as Antiaffeeding, '' as OtherDNA
from tblExposeFollowUp ef
left outer join tblPatient p on ef.ptcode=p.ptcode
left outer join tblCodeID ci on ci.PtCode=ef.ptcode and ci.ClinicId like 'E%'
left outer join tblExposePatientBloodTestPCR pcr on pcr.ExpFollowUpID = ef.ExpFollowUpID
left outer join tblExposePatientBloodTestAntibody ab on ab.ExpFollowUpID = ef.ExpFollowUpID
where ci.ClinicID is not null
