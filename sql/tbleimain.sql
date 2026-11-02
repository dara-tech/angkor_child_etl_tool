WITH RawData AS (
  SELECT 
    ci.ClinicID, 
    ISNULL(ep.VisitDate, '1900-01-01') as DafirstVisit, 
    ISNULL(p.DOB, '1900-01-01') as DaBirth, 
    ISNULL(iif(p.sex='F',0,1), 0) as Sex, 
    '-1' as AddGuardian, 
    '' as Grou, 
    '' as House, 
    '' as Street, 
    LEFT(ISNULL(av.Village, ''), 20) as Village, 
    LEFT(ISNULL(ac.Commune, ''), 25) as Commune, 
    LEFT(ISNULL(ad.District, ''), 25) as District, 
    LEFT(ISNULL(ap.Province, ''), 25) as Province,
    LEFT(ISNULL(NULLIF(ep.MotherName, ''), ISNULL(p.CareTakerNameKhmer, '')), 25) as NameContact, 
    ISNULL(ep.ContactNo, '') as AddContact, 
    LEFT(ISNULL(ep.ContactNo, ''), 12) as Phone, 
    0 as Fage, 
    0 as FHIV, 
    0 as Fstatus, 
    ISNULL(iif(ep.DOB IS NOT NULL AND ep.DOB > '1900-01-01' AND ep.DOB < ep.VisitDate, DATEDIFF(year, ep.DOB, ep.VisitDate), 0), 0) as Mage, 
    -- Extract site code from OIARTSite name, e.g. "Siem Reap Hospital(17-02)" -> "1702"
    IIF(CHARINDEX('(', os.OIARTSite) > 0 AND CHARINDEX('-', os.OIARTSite) > CHARINDEX('(', os.OIARTSite), 
        REPLACE(SUBSTRING(os.OIARTSite, CHARINDEX('(', os.OIARTSite) + 1, CHARINDEX(')', os.OIARTSite) - CHARINDEX('(', os.OIARTSite) - 1), '-', ''), 
        '') as SiteCode,
    -- Clean Other field to extract digits
    LEFT(ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ep.Other, 'ARTNumber', ''), 'ARV', ''), 'Code', ''), 'code', ''), 'Book', ''), 'No.', ''), 'No', ''), ':', ''), '.', ''), ' ', ''), ''), 20) as CleanedOther,
    os.OIARTSite,
    CASE WHEN ISNULL(ep.Status, '') = 'Died' THEN 1 WHEN ISNULL(ep.Status, '') = 'Alive' THEN 0 ELSE 0 END as Mstatus, 
    '' as CatPlaceDelivery, 
    '' as PlaceDelivery, 
    ISNULL(iif(ep.PMTCT=1, '1', '0'), '0') as PMTCT, 
    ISNULL(ep.DeliveryDate, '1900-01-01') as DaDelivery, 
    CASE 
      WHEN ISNULL(ep.DeliveryStatus, '') = 'Normal' THEN 0 
      WHEN ISNULL(ep.DeliveryStatus, '') = 'C-Section' THEN 1 
      WHEN ISNULL(ep.DeliveryStatus, '') = 'Assisted Delivery' THEN 2 
      ELSE -1 
    END as DeliveryStatus, 
    ISNULL(ep.Height, 0) as LenBaby, 
    ISNULL(ep.Weight, 0) as WBaby, 
    ISNULL(iif(ep.HIVTestHistory=1, 1, 0), 0) as KnownHIV, 
    ISNULL(iif(ep.ReceivedNVP=1, 1, 0), 0) as Received, 
    0 as Syrup, 
    ISNULL(iif(ep.ReceivedCotrim=1, 1, 0), 0) as Cotrim, 
    0 as Offin, 
    '' as SiteName, 
    ISNULL(iif(ep.TestResult=1, 1, 0), 0) as HIVtest, 
    0 as MHIV, 
    '' as MLastvl, 
    '1900-01-01' as DaMLastvl, 
    '' as EOClinicID
  FROM tblExposePatient ep
  LEFT OUTER JOIN tblPatient p ON ep.ptcode=p.ptcode
  LEFT OUTER JOIN tblCodeID ci ON ci.PtCode=ep.PtCode and ci.ClinicId LIKE 'E%'
  LEFT OUTER JOIN Province ap ON ap.ProvinceCode=p.ProvinceCode
  LEFT OUTER JOIN District ad ON ad.DistrictCode=p.DistrictCode
  LEFT OUTER JOIN Commune ac ON ac.CommuneCode=p.CommuneCode
  LEFT OUTER JOIN Village av ON av.VillageCode=p.VillageCode
  LEFT OUTER JOIN OIARTSite os ON os.OIARTSiteID = ep.OIARTSiteID
  WHERE ci.ClinicID IS NOT NULL
)
SELECT 
  ClinicID, 
  DafirstVisit, 
  DaBirth, 
  Sex, 
  AddGuardian, 
  Grou, 
  House, 
  Street, 
  Village, 
  Commune, 
  District, 
  Province,
  NameContact, 
  AddContact, 
  Phone, 
  Fage, 
  FHIV, 
  Fstatus, 
  Mage, 
  -- MClinicID: parse from CleanedOther if it's numeric, otherwise 0
  IIF(ISNUMERIC(CleanedOther) = 1 AND LEN(CleanedOther) > 0,
      TRY_CAST(RIGHT(CleanedOther, 5) AS INT),
      0) as MClinicID,
  -- MArt: formatted full ART number
  LEFT(IIF(ISNUMERIC(CleanedOther) = 1 AND LEN(CleanedOther) > 0,
      IIF(LEN(CleanedOther) <= 5,
          SiteCode + RIGHT('00000' + CleanedOther, 5),
          CleanedOther),
      ''), 10) as MArt,
  -- HospitalName: 4-digit site code (numeric) if found, otherwise name
  LEFT(IIF(SiteCode <> '', SiteCode, ISNULL(OIARTSite, '')), 30) as HospitalName,
  Mstatus, 
  CatPlaceDelivery, 
  PlaceDelivery, 
  PMTCT, 
  DaDelivery, 
  DeliveryStatus, 
  LenBaby, 
  WBaby, 
  KnownHIV, 
  Received, 
  Syrup, 
  Cotrim, 
  Offin, 
  SiteName, 
  HIVtest, 
  MHIV, 
  MLastvl, 
  DaMLastvl, 
  EOClinicID
FROM RawData