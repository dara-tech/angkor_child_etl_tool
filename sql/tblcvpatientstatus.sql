select * from (
  select ci.clinicid, iif(ne<getdate() and Status is null,'0',iif(status is not null,status,null)) as Status, '-1' as Place, '' as Oplace,
  iif(ne<getdate() and Da is null,ne,iif(da is not null,Da,null)) as Da, '' as Cause,
  ci.ClinicID + right('0'+cast(day(VisitDate) as varchar(2)),2) + right('0'+cast(Month(VisitDate) as varchar(2)),2) + right(cast(year(VisitDate) as varchar(4)),2) as vid
  from (
    select p.PatientCode, p.PtCode, mfp.VisitDate, pf.TransferDate, d.DischargeDate,
    DATEADD(d,28,mfp.VisitDate) as ne,
    iif(d.DischargeDate is not null,d.DischargeDate, iif(pf.TransferDate is not null and pf.TransferDate>=VisitDate,pf.TransferDate,null)) as Da,
    iif(d.DischargeDate is not null,'1',iif(pf.TransferDate is not null and pf.TransferDate>=VisitDate,'3',null)) as Status
    from tblHIVPatient hp
    left join tblPatient p on p.PtCode=hp.PtCode
    left join (SELECT ptCode, Max(VisitDate) as VisitDate FROM tblHIVFollowUp group by PtCode) mfp on mfp.ptcode=p.ptcode 
    left join (select ptcode, Max(TransferDate) as TransferDate from tblHIVPatientTransfer group by ptcode) pf on pf.PtCode=p.PtCode
    left join (SELECT PtCode, max(DischargeDate) as DischargeDate FROM tblHIVAdmission where DischargeStatus='Died' group by PtCode) d on d.PtCode=p.PtCode
  ) lp
  left join tblCodeID ci on ci.HospitalID=lp.PatientCode and ci.ClinicId like 'P%'
) l
where l.status is not null
order by l.clinicid
