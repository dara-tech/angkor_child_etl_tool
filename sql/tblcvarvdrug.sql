select dd.DrugName, '' as Dose, '0' as Quantity, '' as Freq, 'tab or cap' as Form, Status, fl.VisitDate as Da, '' as Reason, '' as Remark,
ci.ClinicID + right('0'+cast(day(VisitDate) as varchar(2)),2) + right('0'+cast(Month(VisitDate) as varchar(2)),2) + right(cast(year(VisitDate) as varchar(4)),2) as vid
from tblHIVFollowUp fl
left join (
  select distinct fd.FollowUpID, iif(fd.Prescription='Continued','2',iif(fd.Prescription='Begun','0','1')) as Status, d.DrugName from tblHIVFollowUpDrug fd
  left join (
    select distinct DrugID, iif(left(DrugShort,3)='FDC',DrugShort,left(DrugShort,3)) as DrugName from Drug
    where DrugShort not like 'xxx%' and DrugShort not like 'RH%' 
    and DrugShort !='INH' 
    and DrugShort not like 'FLU%' 
    and DrugShort not like 'CAT%' 
    and DrugShort not like 'TB%'
    and DrugShort not like 'COT%'
    and DrugShort not in('ITR','DAP','MYC','3HP')
  ) d on d.DrugID=fd.DrugID
  where d.DrugName is not null
) dd on dd.FollowUpID=fl.FollowupID
left join tblPatient p on p.PtCode=fl.PtCode
left join tblcodeid ci on ci.HospitalID=p.PatientCode and ci.ClinicId like 'P%'
where dd.DrugName is not null
order by fl.PtCode, fl.VisitDate
