select art.clinicid, 'P1703'+ right(clinicid,5) as ART, art.dat as Daart from (
  select ci.ClinicID, Min(fl.VisitDate) as dat
  from tblHIVFollowUp fl
  inner join tblCodeID ci on ci.PtCode = fl.PtCode
  inner join tblHIVFollowUpDrug fd on fd.FollowupID = fl.FollowupID
  inner join Drug d on d.DrugID = fd.DrugID
  where d.DrugShort not like 'xxx%' and d.DrugShort not like 'RH%' 
    and d.DrugShort !='INH' 
    and d.DrugShort not like 'FLU%' 
    and d.DrugShort not like 'CAT%' 
    and d.DrugShort not like 'TB%'
    and d.DrugShort not like 'COT%'
    and d.DrugShort not in('ITR','DAP','MYC','3HP')
  group by ci.clinicid
) art

