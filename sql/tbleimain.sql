select ci.ClinicID, ISNULL(ep.VisitDate, '1900-01-01') as DafirstVisit, ISNULL(p.DOB, '1900-01-01') as DaBirth, 
ISNULL(iif(p.sex='F',0,1), 0) as Sex, '-1' as AddGuardian, '' as Grou, '' as House, '' as Street, LEFT(ISNULL(av.Village, ''), 20) as Village, LEFT(ISNULL(ac.Commune, ''), 25) as Commune, LEFT(ISNULL(ad.District, ''), 25) as District, LEFT(ISNULL(ap.Province, ''), 25) as Province,
LEFT(ISNULL(ep.MotherName, ''), 25) as NameContact, ISNULL(ep.ContactNo, '') as AddContact, LEFT(ISNULL(ep.ContactNo, ''), 12) as Phone, 
0 as Fage, 0 as FHIV, 0 as Fstatus, 0 as Mage, 0 as MClinicID, '' as MArt, '' as HospitalName, 0 as Mstatus, 
'' as CatPlaceDelivery, '' as PlaceDelivery, ISNULL(iif(ep.PMTCT=1, '1', '0'), '0') as PMTCT, ISNULL(ep.DeliveryDate, '1900-01-01') as DaDelivery, 
CASE 
  WHEN ISNULL(ep.DeliveryStatus, '') = 'Normal' THEN 0 
  WHEN ISNULL(ep.DeliveryStatus, '') = 'C-Section' THEN 1 
  WHEN ISNULL(ep.DeliveryStatus, '') = 'Assisted Delivery' THEN 2 
  ELSE -1 
END as DeliveryStatus, 
ISNULL(ep.Height, 0) as LenBaby, ISNULL(ep.Weight, 0) as WBaby, ISNULL(iif(ep.HIVTestHistory=1, 1, 0), 0) as KnownHIV, ISNULL(iif(ep.ReceivedNVP=1, 1, 0), 0) as Received, 
0 as Syrup, ISNULL(iif(ep.ReceivedCotrim=1, 1, 0), 0) as Cotrim, 0 as Offin, '' as SiteName, ISNULL(iif(ep.TestResult=1, 1, 0), 0) as HIVtest, 
ISNULL(iif(ep.MotherHIVResult=1, 1, 0), 0) as MHIV, '' as MLastvl, '1900-01-01' as DaMLastvl, '' as EOClinicID
from tblExposePatient ep
left outer join tblPatient p on ep.ptcode=p.ptcode
left outer join tblCodeID ci on ci.PtCode=ep.PtCode and ci.ClinicId like 'E%'
left outer join Province ap on ap.ProvinceCode=p.ProvinceCode
left outer join District ad on ad.DistrictCode=p.DistrictCode
left outer join Commune ac on ac.CommuneCode=p.CommuneCode
left outer join Village av on av.VillageCode=p.VillageCode
where ci.ClinicID is not null
