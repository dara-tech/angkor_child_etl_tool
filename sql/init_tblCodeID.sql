IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblCodeID')
BEGIN
  DROP TABLE tblCodeID;
END
CREATE TABLE tblCodeID (ClinicId NVARCHAR(20), HospitalID NVARCHAR(20), PtCode INT);

INSERT INTO tblCodeID (ClinicId,HospitalID, PtCode) 
select 'P'+right('000000'+ cast(row_number() over( order by fv.datvisit ) as varchar(6)),6) as ClinicID, cast(p.patientcode as varchar) as code, p.PtCode
from tblhivpatient hp
left join tblPatient p on p.PtCode=hp.PtCode
left join (SELECT PtCode,min( VisitDate) as datvisit FROM tblHIVFollowUp group by PtCode) fv on fv.ptcode=hp.PtCode;

INSERT INTO tblCodeID (ClinicId,HospitalID, PtCode) 
select 'E1703' + right('0000'+ cast(row_number() over( order by ep.VisitDate ) as varchar(4)),4) as ClinicID, cast(p.patientcode as varchar) as code, ep.PtCode
from tblExposePatient ep
left join tblPatient p on p.PtCode=ep.PtCode
where not exists (select 1 from tblCodeID where PtCode = ep.PtCode and ClinicId like 'E%');
