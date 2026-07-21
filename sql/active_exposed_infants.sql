SELECT 
    ci.ClinicID,
    p.PtCode,
    p.PatientCode,
    p.Sex,
    p.DOB,
    '' AS Column1,
    DATEDIFF(MONTH, p.DOB, GETDATE()) AS Age_Month,
    ep.VisitDate AS FirstVisit,
    ep.TransferInID AS TransferIN,
    ep.FeedingOption,
    ep.FeedingStartDate,
    ep.LeaveProgramDate,
    ep.LeaveProgramReason,
    ap.Province,
    ad.District,
    ac.Commune,
    av.Village,
    fu.NextAppointment AS AppointmentDate,
    DATEDIFF(DAY, fu.NextAppointment, GETDATE()) AS [MissAppointment(dd)]
FROM tblExposePatient ep
LEFT JOIN tblPatient p ON ep.PtCode = p.PtCode
LEFT JOIN tblCodeID ci ON ci.PtCode = ep.PtCode AND ci.ClinicId LIKE 'E%'
OUTER APPLY (
    SELECT TOP 1 NextAppointment 
    FROM tblExposeFollowUp f 
    WHERE f.PtCode = ep.PtCode 
    ORDER BY VisitDate DESC
) fu
LEFT JOIN Province ap ON ap.ProvinceCode = p.ProvinceCode
LEFT JOIN District ad ON ad.DistrictCode = p.DistrictCode
LEFT JOIN Commune ac ON ac.CommuneCode = p.CommuneCode
LEFT JOIN Village av ON av.VillageCode = p.VillageCode
WHERE ci.ClinicID IS NOT NULL
  AND (ep.LeaveProgramDate IS NULL AND (ep.LeaveProgramReason IS NULL OR ep.LeaveProgramReason = ''));
