select ci.clinicid, fv.datvisit as DaFirstVisit, '' as LClinicID, dob as DaBirth, 
iif(sex='F',0,1) as sex, '-1' as Referred, '' as Oreferred, '' as EClinicID, hp.DateOfHIVPositive as DaTest,
iif(HIVTest='PCR',0,iif(HIVTest='SERO',2,-1)) as TypeTest, '' as Vcctcode, '' as VcctID, iif(ti.TransferDate is null,0,1) as OffIn, '' as SiteName,
'1900-01-01' as DaART, '' as Artnum, '-1' as Feeding, '-1' as TbPast, '-1' as TypeTB, '-1' as ResultTB,
'1900-01-01' as Daonset, '-1' as Tbtreat, '1900-01-01' as Datreat, '-1' as ResultTreat, '1900-01-01' as DaResultTreat, '-1' as Inh,
'-1' as TPTdrug, null as DaStartTPT, null as DaEndTPT, '-1' as OtherPast, '-1' as Cotrim, '-1' as Fluco, '-1' as Allergy, '' as ClinicIDold, '' as SiteNameold, '33' as Nationality
from tblhivpatient hp
left outer join tblPatient p on hp.ptcode=p.ptcode
left outer join tblCodeID ci on ci.HospitalID=p.PatientCode and ci.ClinicId like 'P%'
left outer join (SELECT PtCode, min(VisitDate) as datvisit FROM tblHIVFollowUp group by PtCode) fv on fv.ptcode=hp.PtCode
left outer join (SELECT id, FollowUpID, PtCode, TransferDate, TransferType, TransferLocationID FROM tblHIVPatientTransfer where TransferType='Transfer In') ti on ti.PtCode=hp.PtCode
where p.patientcode is not null
order by fv.datvisit
