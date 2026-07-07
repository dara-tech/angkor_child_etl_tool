select distinct ci.ClinicID + right('0'+cast(day(fl.VisitDate) as varchar(2)),2) + right('0'+cast(Month(fl.VisitDate) as varchar(2)),2) + cast(year(fl.VisitDate) as varchar(4)) as TestID,
ci.clinicid ClinicID, BloodCollectionDate as DaArrival, BloodCollectionDate as Dat, VisitDate as DaCollect, '-1' as CD4Rapid,
LEFT(iif(cast(CD4 as int)=0,'',cast(floor(CD4) as varchar)), 5) as CD4, LEFT(iif(cast(CD4Percent as int)=0,'',cast(CD4Percent as varchar)), 6) CD, '' CD8,
LEFT(iif(ft.OrderViralLoad is null and cast(ViralLoad as int)=0,'',iif(cast(ViralLoad as int)=1,'0',cast(floor(ViralLoad) as varchar))), 10) as HIVLoad,
'' HIVLog, '' HCV, '' HCVlog, '-1' HIVAb, '-1' HBsAg, '-1' HCVPCR, '-1' HBeAg, '-1' TPHA, '-1' AntiHBcAb, '-1' RPR, '-1' AntiHBeAb,
'' RPRab, '-1' HCVAb, '-1' HBsAb, '' WBC, '' Neutrophils, '' HGB, '' Eosinophis, '' HCT,
iif(cast(Lymphocytes as int)=0,'',cast(floor(Lymphocytes) as varchar)) as Lymphocyte, '' MCV, '' Monocyte, '' PLT, '' Reticulocte,
'' Prothrombin, '' ProReticulocyte, iif(cast(Creatinine as int)=0,'',cast(floor(Creatinine) as varchar)) as Creatinine, '' HDL, '' Bilirubin,
'' Glucose, '' Sodium, '' AlPhosphate, iif(cast(GammaGT as int)=0,'',cast(floor(GammaGT) as varchar)) as GotASAT, '' Potassium, '' Amylase,
iif(cast(ALT as int)=0,'',cast(floor(ALT) as varchar)) as GPTALAT, '' Chloride, '' CK, '' CHOL, '' Bicarbonate, '' Lactate, '' Triglyceride,
'' Urea, '' Magnesium, '' Phosphorus, '' Calcium, '-1' BHCG, '-1' SputumAFB, '-1' AFBCulture, '' AFBCulture1, '-1' UrineMicroscopy,
'' UrineComment, '' CSFCell, '' CSFGram, '' CSFAFB, '-1' CSFIndian, '' CSFCCag, '' CSFProtein, '' CSFGlucose, '-1' BloodCulture,
'' BloodCulture0, '-1' BloodCulture1, '' BloodCulture10, '-1' CTNA, '-1' GCNA, '-1' CXR, '-1' Abdominal
from tblHIVFollowUp fl
left outer join (select FollowUpID, OrderViralLoad from tblHIVFollowUpBloodTest where OrderViralLoad=1) ft on ft.FollowupID=fl.FollowupID 
left outer join tblPatient pt on pt.PtCode=fl.PtCode
left outer join tblCodeID ci on ci.HospitalID=pt.PatientCode and ci.ClinicId like 'P%'
where BloodCollectionDate is not null and ci.clinicid is not null
