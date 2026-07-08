select ci.ClinicID, 
CASE 
  WHEN ISNULL(ep.LeaveProgramReason, '') = 'Died' THEN 3
  WHEN ISNULL(ep.LeaveProgramReason, '') = 'Defaulter' THEN 4
  WHEN ISNULL(ep.LeaveProgramReason, '') = 'Left Program Negative' OR ISNULL(ep.LeaveProgramReason, '') LIKE 'HIV -%' THEN 2
  WHEN ISNULL(ep.LeaveProgramReason, '') = 'Left Program Positive' OR ISNULL(ep.LeaveProgramReason, '') = 'HIV+' THEN 1
  ELSE -1
END as Status, 
ISNULL(ep.LeaveProgramDate, '1900-01-01') as DaStatus, '' as Vid, ISNULL(ep.TransferInID, '0') as transfer_to_site
from tblExposePatient ep
left outer join tblPatient p on ep.ptcode=p.ptcode
left outer join tblCodeID ci on ci.PtCode=ep.ptcode and ci.ClinicId like 'E%'
where (ISNULL(ep.LeaveProgramReason, '') != '') and ci.ClinicID is not null
