select clinicid, Hospitalid as Codes, 'HospitalID' as Typecode, '-1' as ARTIss, '1900-01-01' as DaExpiry, CURRENT_TIMESTAMP as Dacreate from tblcodeid where clinicid like 'P%'
