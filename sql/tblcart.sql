select art.clinicid, 'P1703'+ right(clinicid,5) as ART, art.dat as Daart from (
  select ci.ClinicID, Min(fl.VisitDate) as dat
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
  group by ci.clinicid
) art
