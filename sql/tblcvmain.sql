select distinct ci.clinicid as ClinicID, '' as ARTnum, VisitDate as DatVisit,
iif(VisitType='Unplanned','2',iif(VisitType='NS','0',iif(VisitType='On Time','1',iif(VisitType='Late','3','-1')))) as TypeVisit, 
'0' as Temp, '0' as Pulse, '0' as Resp, '/' as Blood, cast(round(fl.Weight,0) as integer) as Weight, cast(fl.Height as integer) as Height,
'-1' as Malnutrition, '-1' WH, '-1' PTB, iif(TBScreen=0,'1',0) as Wlost, iif(TBScreen=0,'1',0) as Cough, iif(TBScreen=0,'1',0) as Fever,
'-1' as Enlarg, '-1' Hospital, '0' as NumDay, '' as CauseHospital, '-1' Miss1, '0' as Miss1Time, '-1' Miss3, '0' as Miss3Time,
'-1' as [Function], iif(right(WHO,1)='s','-1',right(WHO,1)) as WHO, '-1' as Eligible, '-1' as Treatfail, '-1' as TypeFail,
iif(TBScreenResult='Positive',0,-1) as TB, '-1' as TypeTB, iif(tb.StartTreatment is null,-1,0) as TBtreat,
iif(tb.StartTreatment is null,'1900-01-01',tb.StartTreatment) as DaTBtreat, '' as TestID, '' as TestHIV, '-1' ResultHIV,
'-1' as ReCD4, '-1' as ReVL, '-1' as CrAG, '-1' as CrAGResult, '-1' as VLDetectable, '-1' as Referred, '-1' as OReferred,
iif(AppointmentDate is null,'1900-01-01',AppointmentDate) as DaApp, null as TPTout,
ci.ClinicID + right('0'+cast(day(VisitDate) as varchar(2)),2) + right('0'+cast(Month(VisitDate) as varchar(2)),2) + right(cast(year(VisitDate) as varchar(4)),2) as vid
from tblHIVFollowUp fl
left join (
  select tbs.PtCode, tbs.ScreenedDate, tbt.StartTreatment, tbt.EndTreatment from tblHIVTBScreen tbs
  left join tblHIVTBTreatment tbt on tbs.ScreenID=tbt.ScreenID
) tb on tb.PtCode=fl.PtCode and fl.VisitDate=tb.ScreenedDate
left join tblPatient pt on pt.PtCode=fl.PtCode
left join tblCodeID ci on ci.HospitalID=pt.PatientCode and ci.ClinicId like 'P%'
