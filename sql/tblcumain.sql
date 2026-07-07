select distinct ci.ClinicID, fv.datvisit as Daupdate,
iif(Relationship='Mother','0',iif(Relationship='Father','1',iif(Relationship='Grandmother','2',iif(Relationship='Grandfather',3,4)))) as AddGuardian,
'' Grou, '' House, '' Street, LEFT(av.Village, 20) as Village, LEFT(ac.Commune, 25) as Commune, LEFT(ad.District, 25) as District, LEFT(ap.Province, 25) as Province,
LEFT(Address, 30) as AddContact, LEFT(Phone, 12) as Phone, '-1' ChildStatus, '-1' Foccupation, '-1' Moccupation, '-1' Education, '' ChildSupport, '-1' Vaccine,
ci.ClinicID + right('0'+cast(day(fv.datvisit) as varchar(2)),2) + right('0'+cast(Month(fv.datvisit) as varchar(2)),2) + right(cast(year(fv.datvisit) as varchar(4)),2) as CUID
from tblHIVPatient hp
left join tblPatient p on p.PtCode=hp.PtCode
left outer join tblCodeID ci on ci.HospitalID=p.PatientCode and ci.ClinicId like 'P%'
left outer join Province ap on ap.ProvinceCode=p.ProvinceCode
left outer join District ad on ad.DistrictCode=p.DistrictCode
left outer join Commune ac on ac.CommuneCode=p.CommuneCode
left outer join Village av on av.VillageCode=p.VillageCode
left outer join (SELECT PtCode, min(VisitDate) as datvisit FROM tblHIVFollowUp group by PtCode) fv on fv.ptcode=p.PtCode
where p.PtCode is not null
