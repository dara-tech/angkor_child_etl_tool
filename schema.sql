-- ============================================================
-- preart MySQL Schema
-- Created for the DB Exporter ETL pipeline
-- ============================================================

CREATE DATABASE IF NOT EXISTS preart CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE preart;

-- ============================================================
-- tblcimain: Core HIV patient registration / intake record
-- ============================================================
CREATE TABLE IF NOT EXISTS `tblcimain` (
  `ClinicID`      VARCHAR(20)  DEFAULT NULL,
  `DaFirstVisit`  DATE         DEFAULT NULL,
  `LClinicID`     VARCHAR(50)  DEFAULT NULL,
  `DaBirth`       DATE         DEFAULT NULL,
  `sex`           TINYINT      DEFAULT NULL,
  `Referred`      VARCHAR(5)   DEFAULT NULL,
  `Oreferred`     VARCHAR(100) DEFAULT NULL,
  `EClinicID`     VARCHAR(20)  DEFAULT NULL,
  `DaTest`        DATE         DEFAULT NULL,
  `TypeTest`      VARCHAR(5)   DEFAULT NULL,
  `Vcctcode`      VARCHAR(50)  DEFAULT NULL,
  `VcctID`        VARCHAR(50)  DEFAULT NULL,
  `OffIn`         TINYINT      DEFAULT NULL,
  `SiteName`      VARCHAR(200) DEFAULT NULL,
  `DaART`         DATE         DEFAULT NULL,
  `Artnum`        VARCHAR(50)  DEFAULT NULL,
  `Feeding`       VARCHAR(5)   DEFAULT NULL,
  `TbPast`        VARCHAR(5)   DEFAULT NULL,
  `TypeTB`        VARCHAR(5)   DEFAULT NULL,
  `ResultTB`      VARCHAR(5)   DEFAULT NULL,
  `Daonset`       DATE         DEFAULT NULL,
  `Tbtreat`       VARCHAR(5)   DEFAULT NULL,
  `Datreat`       DATE         DEFAULT NULL,
  `ResultTreat`   VARCHAR(5)   DEFAULT NULL,
  `DaResultTreat` DATE         DEFAULT NULL,
  `Inh`           VARCHAR(5)   DEFAULT NULL,
  `OtherPast`     VARCHAR(5)   DEFAULT NULL,
  `Cotrim`        VARCHAR(5)   DEFAULT NULL,
  `Fluco`         VARCHAR(5)   DEFAULT NULL,
  `Allergy`       VARCHAR(5)   DEFAULT NULL,
  `ClinicIDold`   VARCHAR(20)  DEFAULT NULL,
  `SiteNameold`   VARCHAR(200) DEFAULT NULL,
  `Nationality`   VARCHAR(10)  DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- tblcumain: Patient update / socio-demographic info
-- ============================================================
CREATE TABLE IF NOT EXISTS `tblcumain` (
  `ClinicID`    VARCHAR(20)  DEFAULT NULL,
  `Daupdate`    DATE         DEFAULT NULL,
  `AddGuardian` VARCHAR(5)   DEFAULT NULL,
  `Grou`        VARCHAR(100) DEFAULT NULL,
  `House`       VARCHAR(100) DEFAULT NULL,
  `Street`      VARCHAR(100) DEFAULT NULL,
  `Village`     VARCHAR(100) DEFAULT NULL,
  `Commune`     VARCHAR(100) DEFAULT NULL,
  `District`    VARCHAR(100) DEFAULT NULL,
  `Province`    VARCHAR(100) DEFAULT NULL,
  `AddContact`  VARCHAR(255) DEFAULT NULL,
  `Phone`       VARCHAR(50)  DEFAULT NULL,
  `ChildStatus` VARCHAR(5)   DEFAULT NULL,
  `Foccupation` VARCHAR(5)   DEFAULT NULL,
  `Moccupation` VARCHAR(5)   DEFAULT NULL,
  `Education`   VARCHAR(5)   DEFAULT NULL,
  `ChildSupport`VARCHAR(100) DEFAULT NULL,
  `Vaccine`     VARCHAR(5)   DEFAULT NULL,
  `CUID`        VARCHAR(50)  DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- tblpatienttest: Lab test results per visit
-- ============================================================
CREATE TABLE IF NOT EXISTS `tblpatienttest` (
  `TestID`          VARCHAR(50)  DEFAULT NULL,
  `ClinicID`        VARCHAR(20)  DEFAULT NULL,
  `DaArrival`       DATE         DEFAULT NULL,
  `Dat`             DATE         DEFAULT NULL,
  `DaCollect`       DATE         DEFAULT NULL,
  `CD4`             VARCHAR(20)  DEFAULT NULL,
  `CD`              VARCHAR(20)  DEFAULT NULL,
  `CD8`             VARCHAR(20)  DEFAULT NULL,
  `HIVLoad`         VARCHAR(20)  DEFAULT NULL,
  `HIVLog`          VARCHAR(20)  DEFAULT NULL,
  `HCV`             VARCHAR(20)  DEFAULT NULL,
  `HCVlog`          VARCHAR(20)  DEFAULT NULL,
  `HIVAb`           VARCHAR(5)   DEFAULT NULL,
  `HBsAg`           VARCHAR(5)   DEFAULT NULL,
  `HCVPCR`          VARCHAR(5)   DEFAULT NULL,
  `HBeAg`           VARCHAR(5)   DEFAULT NULL,
  `TPHA`            VARCHAR(5)   DEFAULT NULL,
  `AntiHBcAb`       VARCHAR(5)   DEFAULT NULL,
  `RPR`             VARCHAR(5)   DEFAULT NULL,
  `AntiHBeAb`       VARCHAR(5)   DEFAULT NULL,
  `RPRab`           VARCHAR(20)  DEFAULT NULL,
  `HCVAb`           VARCHAR(5)   DEFAULT NULL,
  `HBsAb`           VARCHAR(5)   DEFAULT NULL,
  `WBC`             VARCHAR(20)  DEFAULT NULL,
  `Neutrophils`     VARCHAR(20)  DEFAULT NULL,
  `HGB`             VARCHAR(20)  DEFAULT NULL,
  `Eosinophis`      VARCHAR(20)  DEFAULT NULL,
  `HCT`             VARCHAR(20)  DEFAULT NULL,
  `Lymphocyte`      VARCHAR(20)  DEFAULT NULL,
  `MCV`             VARCHAR(20)  DEFAULT NULL,
  `Monocyte`        VARCHAR(20)  DEFAULT NULL,
  `PLT`             VARCHAR(20)  DEFAULT NULL,
  `Reticulocte`     VARCHAR(20)  DEFAULT NULL,
  `Prothrombin`     VARCHAR(20)  DEFAULT NULL,
  `ProReticulocyte` VARCHAR(20)  DEFAULT NULL,
  `Creatinine`      VARCHAR(20)  DEFAULT NULL,
  `HDL`             VARCHAR(20)  DEFAULT NULL,
  `Bilirubin`       VARCHAR(20)  DEFAULT NULL,
  `Glucose`         VARCHAR(20)  DEFAULT NULL,
  `Sodium`          VARCHAR(20)  DEFAULT NULL,
  `AlPhosphate`     VARCHAR(20)  DEFAULT NULL,
  `GotASAT`         VARCHAR(20)  DEFAULT NULL,
  `Potassium`       VARCHAR(20)  DEFAULT NULL,
  `Amylase`         VARCHAR(20)  DEFAULT NULL,
  `GPTALAT`         VARCHAR(20)  DEFAULT NULL,
  `Chloride`        VARCHAR(20)  DEFAULT NULL,
  `CK`              VARCHAR(20)  DEFAULT NULL,
  `CHOL`            VARCHAR(20)  DEFAULT NULL,
  `Bicarbonate`     VARCHAR(20)  DEFAULT NULL,
  `Lactate`         VARCHAR(20)  DEFAULT NULL,
  `Triglyceride`    VARCHAR(20)  DEFAULT NULL,
  `Urea`            VARCHAR(20)  DEFAULT NULL,
  `Magnesium`       VARCHAR(20)  DEFAULT NULL,
  `Phosphorus`      VARCHAR(20)  DEFAULT NULL,
  `Calcium`         VARCHAR(20)  DEFAULT NULL,
  `BHCG`            VARCHAR(5)   DEFAULT NULL,
  `SputumAFB`       VARCHAR(5)   DEFAULT NULL,
  `AFBCulture`      VARCHAR(5)   DEFAULT NULL,
  `AFBCulture1`     VARCHAR(20)  DEFAULT NULL,
  `UrineMicroscopy` VARCHAR(5)   DEFAULT NULL,
  `UrineComment`    VARCHAR(100) DEFAULT NULL,
  `CSFCell`         VARCHAR(20)  DEFAULT NULL,
  `CSFGram`         VARCHAR(20)  DEFAULT NULL,
  `CSFAFB`          VARCHAR(20)  DEFAULT NULL,
  `CSFIndian`       VARCHAR(5)   DEFAULT NULL,
  `CSFCCag`         VARCHAR(20)  DEFAULT NULL,
  `CSFProtein`      VARCHAR(20)  DEFAULT NULL,
  `CSFGlucose`      VARCHAR(20)  DEFAULT NULL,
  `BloodCulture`    VARCHAR(5)   DEFAULT NULL,
  `BloodCulture0`   VARCHAR(20)  DEFAULT NULL,
  `BloodCulture1`   VARCHAR(5)   DEFAULT NULL,
  `BloodCulture10`  VARCHAR(20)  DEFAULT NULL,
  `CTNA`            VARCHAR(5)   DEFAULT NULL,
  `GCNA`            VARCHAR(5)   DEFAULT NULL,
  `CXR`             VARCHAR(5)   DEFAULT NULL,
  `Abdominal`       VARCHAR(5)   DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- tblcvpatientstatus: Patient outcome / status tracking
-- ============================================================
CREATE TABLE IF NOT EXISTS `tblcvpatientstatus` (
  `ClinicID` VARCHAR(20)  DEFAULT NULL,
  `Status`   VARCHAR(5)   DEFAULT NULL,
  `Place`    VARCHAR(5)   DEFAULT NULL,
  `Oplace`   VARCHAR(100) DEFAULT NULL,
  `Da`       DATE         DEFAULT NULL,
  `Cause`    VARCHAR(200) DEFAULT NULL,
  `vid`      VARCHAR(50)  DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- tblcvmain: Clinical visit / follow-up details
-- ============================================================
CREATE TABLE IF NOT EXISTS `tblcvmain` (
  `ClinicID`     VARCHAR(20)  DEFAULT NULL,
  `ARTnum`       VARCHAR(50)  DEFAULT NULL,
  `DatVisit`     DATE         DEFAULT NULL,
  `TypeVisit`    VARCHAR(5)   DEFAULT NULL,
  `Temp`         VARCHAR(10)  DEFAULT NULL,
  `Pulse`        VARCHAR(10)  DEFAULT NULL,
  `Resp`         VARCHAR(10)  DEFAULT NULL,
  `Blood`        VARCHAR(20)  DEFAULT NULL,
  `Weight`       INT          DEFAULT NULL,
  `Height`       INT          DEFAULT NULL,
  `Malnutrition` VARCHAR(5)   DEFAULT NULL,
  `WH`           VARCHAR(5)   DEFAULT NULL,
  `PTB`          VARCHAR(5)   DEFAULT NULL,
  `Wlost`        VARCHAR(5)   DEFAULT NULL,
  `Cough`        VARCHAR(5)   DEFAULT NULL,
  `Fever`        VARCHAR(5)   DEFAULT NULL,
  `Enlarg`       VARCHAR(5)   DEFAULT NULL,
  `Hospital`     VARCHAR(5)   DEFAULT NULL,
  `NumDay`       VARCHAR(10)  DEFAULT NULL,
  `CauseHospital`VARCHAR(200) DEFAULT NULL,
  `Miss1`        VARCHAR(5)   DEFAULT NULL,
  `Miss1Time`    VARCHAR(10)  DEFAULT NULL,
  `Miss3`        VARCHAR(5)   DEFAULT NULL,
  `Miss3Time`    VARCHAR(10)  DEFAULT NULL,
  `Function1`    VARCHAR(5)   DEFAULT NULL,
  `WHO`          VARCHAR(5)   DEFAULT NULL,
  `Eligible`     VARCHAR(5)   DEFAULT NULL,
  `Treatfail`    VARCHAR(5)   DEFAULT NULL,
  `TypeFail`     VARCHAR(5)   DEFAULT NULL,
  `TB`           VARCHAR(5)   DEFAULT NULL,
  `TypeTB`       VARCHAR(5)   DEFAULT NULL,
  `TBtreat`      VARCHAR(5)   DEFAULT NULL,
  `DaTBtreat`    DATE         DEFAULT NULL,
  `TestID`       VARCHAR(50)  DEFAULT NULL,
  `TestHIV`      VARCHAR(50)  DEFAULT NULL,
  `ResultHIV`    VARCHAR(5)   DEFAULT NULL,
  `ReCD4`        VARCHAR(5)   DEFAULT NULL,
  `ReVL`         VARCHAR(5)   DEFAULT NULL,
  `CrAG`         VARCHAR(5)   DEFAULT NULL,
  `CrAGResult`   VARCHAR(5)   DEFAULT NULL,
  `VLDetectable` VARCHAR(5)   DEFAULT NULL,
  `Referred`     VARCHAR(5)   DEFAULT NULL,
  `OReferred`    VARCHAR(5)   DEFAULT NULL,
  `DaApp`        DATE         DEFAULT NULL,
  `vid`          VARCHAR(50)  DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- tblcart: ART (antiretroviral therapy) start records
-- ============================================================
CREATE TABLE IF NOT EXISTS `tblcart` (
  `ClinicID` VARCHAR(20) DEFAULT NULL,
  `ART`      VARCHAR(20) DEFAULT NULL,
  `Daart`    DATE        DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- tblclink: Linking table (ClinicID <-> HospitalID codes)
-- ============================================================
CREATE TABLE IF NOT EXISTS `tblclink` (
  `ClinicID`  VARCHAR(20)  DEFAULT NULL,
  `Codes`     VARCHAR(50)  DEFAULT NULL,
  `Typecode`  VARCHAR(50)  DEFAULT NULL,
  `Da1`       DATE         DEFAULT NULL,
  `Da2`       DATE         DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- tblcvtbdrug: TB drug prescriptions per visit
-- ============================================================
CREATE TABLE IF NOT EXISTS `tblcvtbdrug` (
  `DrugName` VARCHAR(100) DEFAULT NULL,
  `Dose`     VARCHAR(50)  DEFAULT NULL,
  `Quantity` VARCHAR(20)  DEFAULT NULL,
  `Freq`     VARCHAR(50)  DEFAULT NULL,
  `Form`     VARCHAR(50)  DEFAULT NULL,
  `Status`   VARCHAR(5)   DEFAULT NULL,
  `Da`       DATE         DEFAULT NULL,
  `Reason`   VARCHAR(200) DEFAULT NULL,
  `Remark`   VARCHAR(200) DEFAULT NULL,
  `vid`      VARCHAR(50)  DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- tblcvoidrug: OI prophylaxis / other drugs per visit
-- ============================================================
CREATE TABLE IF NOT EXISTS `tblcvoidrug` (
  `DrugName` VARCHAR(100) DEFAULT NULL,
  `Dose`     VARCHAR(50)  DEFAULT NULL,
  `Quantity` VARCHAR(20)  DEFAULT NULL,
  `Freq`     VARCHAR(50)  DEFAULT NULL,
  `Form`     VARCHAR(50)  DEFAULT NULL,
  `Status`   VARCHAR(5)   DEFAULT NULL,
  `Da`       DATE         DEFAULT NULL,
  `Reason`   VARCHAR(200) DEFAULT NULL,
  `Remark`   VARCHAR(200) DEFAULT NULL,
  `vid`      VARCHAR(50)  DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- tblcvarvdrug: ARV drug prescriptions per visit
-- ============================================================
CREATE TABLE IF NOT EXISTS `tblcvarvdrug` (
  `DrugName` VARCHAR(100) DEFAULT NULL,
  `Dose`     VARCHAR(50)  DEFAULT NULL,
  `Quantity` VARCHAR(20)  DEFAULT NULL,
  `Freq`     VARCHAR(50)  DEFAULT NULL,
  `Form`     VARCHAR(50)  DEFAULT NULL,
  `Status`   VARCHAR(5)   DEFAULT NULL,
  `Da`       DATE         DEFAULT NULL,
  `Reason`   VARCHAR(200) DEFAULT NULL,
  `Remark`   VARCHAR(200) DEFAULT NULL,
  `vid`      VARCHAR(50)  DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- tblsitename: Site/facility name reference (used in backup)
-- ============================================================
CREATE TABLE IF NOT EXISTS `tblsitename` (
  `SiteCode` VARCHAR(20)  DEFAULT NULL,
  `SiteName` VARCHAR(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- tblexposepatient
-- ============================================================
CREATE TABLE IF NOT EXISTS `tblexposepatient` (
  `PtCode`             BIGINT       DEFAULT NULL,
  `VisitDate`          DATE         DEFAULT NULL,
  `Weight`             DECIMAL(10,2) DEFAULT NULL,
  `Height`             DECIMAL(10,2) DEFAULT NULL,
  `WeightHeight`       DECIMAL(10,2) DEFAULT NULL,
  `MotherName`         VARCHAR(50)  DEFAULT NULL,
  `DOB`                DATE         DEFAULT NULL,
  `Status`             VARCHAR(50)  DEFAULT NULL,
  `MotherHIVResult`    TINYINT(1)   DEFAULT NULL,
  `TestResult`         TINYINT(1)   DEFAULT NULL,
  `FUBook`             TINYINT(1)   DEFAULT NULL,
  `Other`              VARCHAR(50)  DEFAULT NULL,
  `Program`            VARCHAR(50)  DEFAULT NULL,
  `DurationInMonth`    INT          DEFAULT NULL,
  `OIARTSiteID`        INT          DEFAULT NULL,
  `NGOID`              INT          DEFAULT NULL,
  `ContactNo`          VARCHAR(50)  DEFAULT NULL,
  `DeliveryPlaceID`    INT          DEFAULT NULL,
  `DeliveryDate`       DATE         DEFAULT NULL,
  `DeliveryStatus`     VARCHAR(50)  DEFAULT NULL,
  `PMTCT`              TINYINT(1)   DEFAULT NULL,
  `ReceivedNVP`        TINYINT(1)   DEFAULT NULL,
  `ReceivedNVPDate`    DATE         DEFAULT NULL,
  `ReceivedCotrim`     TINYINT(1)   DEFAULT NULL,
  `ReceivedCotrimDate` DATE         DEFAULT NULL,
  `FeedingOption`      VARCHAR(50)  DEFAULT NULL,
  `FeedingStartDate`   DATE         DEFAULT NULL,
  `HIVTestHistory`     TINYINT(1)   DEFAULT NULL,
  `DNAPCRResult`       VARCHAR(50)  DEFAULT NULL,
  `AntibodyResult`     VARCHAR(50)  DEFAULT NULL,
  `VCCTSiteID`         INT          DEFAULT NULL,
  `TransferInID`       INT          DEFAULT NULL,
  `LeaveProgramDate`   DATE         DEFAULT NULL,
  `LeaveProgramReason` VARCHAR(50)  DEFAULT NULL,
  `CreationDate`       DATETIME     DEFAULT NULL,
  `InsertedBy`         VARCHAR(50)  DEFAULT NULL,
  `ModifiedDate`       DATETIME     DEFAULT NULL,
  `ModifiedBy`         VARCHAR(50)  DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- tblexposefollowup
-- ============================================================
CREATE TABLE IF NOT EXISTS `tblexposefollowup` (
  `ExpFollowUpID`      INT          DEFAULT NULL,
  `PtCode`             BIGINT       DEFAULT NULL,
  `VisitDate`          DATE         DEFAULT NULL,
  `Weight`             DECIMAL(10,2) DEFAULT NULL,
  `Height`             DECIMAL(10,2) DEFAULT NULL,
  `WeightHeight`       DECIMAL(10,2) DEFAULT NULL,
  `ReasonOfFU`         VARCHAR(50)  DEFAULT NULL,
  `FUStatus`           VARCHAR(50)  DEFAULT NULL,
  `DoctorID`           INT          DEFAULT NULL,
  `CounselorID`        INT          DEFAULT NULL,
  `PLHAID`             INT          DEFAULT NULL,
  `NextAppointment`    DATE         DEFAULT NULL,
  `DrugShort1`         VARCHAR(50)  DEFAULT NULL,
  `DrugShort2`         VARCHAR(50)  DEFAULT NULL,
  `DrugShort3`         VARCHAR(50)  DEFAULT NULL,
  `DrugShort4`         VARCHAR(50)  DEFAULT NULL,
  `DrugShort5`         VARCHAR(50)  DEFAULT NULL,
  `FormulaType`        SMALLINT     DEFAULT NULL,
  `FormulaTypeAmount`  DECIMAL(10,2) DEFAULT NULL,
  `Transportation`     DECIMAL(19,4) DEFAULT NULL,
  `CreationDate`       DATETIME     DEFAULT NULL,
  `InsertedBy`         VARCHAR(50)  DEFAULT NULL,
  `ModifiedDate`       DATETIME     DEFAULT NULL,
  `ModifiedBy`         VARCHAR(50)  DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- tblexposepatientbloodtestpcr
-- ============================================================
CREATE TABLE IF NOT EXISTS `tblexposepatientbloodtestpcr` (
  `id`                 INT          DEFAULT NULL,
  `ExpFollowUpID`      INT          DEFAULT NULL,
  `PtCode`             BIGINT       DEFAULT NULL,
  `TestDate`           DATE         DEFAULT NULL,
  `DNAPCR`             VARCHAR(50)  DEFAULT NULL,
  `ResultDate`         DATE         DEFAULT NULL,
  `PCRResult`          VARCHAR(20)  DEFAULT NULL,
  `Status`             VARCHAR(20)  DEFAULT NULL,
  `CreationDate`       DATETIME     DEFAULT NULL,
  `InsertedBy`         VARCHAR(50)  DEFAULT NULL,
  `ModifiedDate`       DATETIME     DEFAULT NULL,
  `ModifiedBy`         VARCHAR(50)  DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- tblexposepatientbloodtestantibody
-- ============================================================
CREATE TABLE IF NOT EXISTS `tblexposepatientbloodtestantibody` (
  `id`                 INT          DEFAULT NULL,
  `ExpFollowUpID`      INT          DEFAULT NULL,
  `PtCode`             BIGINT       DEFAULT NULL,
  `TestDate`           DATE         DEFAULT NULL,
  `Antibody`           TINYINT(1)   DEFAULT NULL,
  `ResultDate`         DATE         DEFAULT NULL,
  `AntibodyResult`     VARCHAR(20)  DEFAULT NULL,
  `Status`             VARCHAR(20)  DEFAULT NULL,
  `CreationDate`       DATETIME     DEFAULT NULL,
  `InsertedBy`         VARCHAR(50)  DEFAULT NULL,
  `ModifiedDate`       DATETIME     DEFAULT NULL,
  `ModifiedBy`         VARCHAR(50)  DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- tbleimain: Exposed infant main registration
-- ============================================================
CREATE TABLE IF NOT EXISTS `tbleimain` (
  `ClinicID` char(10) DEFAULT NULL,
  `DafirstVisit` date DEFAULT NULL,
  `DaBirth` date DEFAULT NULL,
  `Sex` int(1) DEFAULT NULL,
  `AddGuardian` int(1) DEFAULT NULL,
  `Grou` char(10) DEFAULT NULL,
  `House` char(20) DEFAULT NULL,
  `Street` char(20) DEFAULT NULL,
  `Village` char(20) DEFAULT NULL,
  `Commune` char(25) DEFAULT NULL,
  `District` char(25) DEFAULT NULL,
  `Province` char(25) DEFAULT NULL,
  `NameContact` char(25) DEFAULT NULL,
  `AddContact` char(50) DEFAULT NULL,
  `Phone` char(12) DEFAULT NULL,
  `Fage` int(2) DEFAULT NULL,
  `FHIV` int(1) DEFAULT NULL,
  `Fstatus` int(1) DEFAULT NULL,
  `Mage` int(2) DEFAULT NULL,
  `MClinicID` int(6) DEFAULT NULL,
  `MArt` char(10) DEFAULT NULL,
  `HospitalName` char(30) DEFAULT NULL,
  `Mstatus` int(1) DEFAULT NULL,
  `CatPlaceDelivery` char(25) DEFAULT NULL,
  `PlaceDelivery` char(50) DEFAULT NULL,
  `PMTCT` char(10) DEFAULT NULL,
  `DaDelivery` date DEFAULT NULL,
  `DeliveryStatus` int(1) DEFAULT NULL,
  `LenBaby` float DEFAULT NULL,
  `WBaby` float DEFAULT NULL,
  `KnownHIV` int(1) DEFAULT NULL,
  `Received` int(1) DEFAULT NULL,
  `Syrup` int(1) DEFAULT NULL,
  `Cotrim` int(1) DEFAULT NULL,
  `Offin` int(1) DEFAULT NULL,
  `SiteName` char(40) DEFAULT NULL,
  `HIVtest` int(1) DEFAULT NULL,
  `MHIV` int(1) DEFAULT NULL,
  `MLastvl` char(10) DEFAULT NULL,
  `DaMLastvl` date DEFAULT NULL,
  `EOClinicID` char(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- tblevmain: Exposed infant follow-up visits
-- ============================================================
CREATE TABLE IF NOT EXISTS `tblevmain` (
  `ClinicID` char(10) DEFAULT NULL,
  `DatVisit` date DEFAULT NULL,
  `TypeVisit` int(1) DEFAULT NULL,
  `Temp` char(5) DEFAULT NULL,
  `Pulse` float DEFAULT NULL,
  `Resp` float DEFAULT NULL,
  `Head` float DEFAULT NULL,
  `Weight` float DEFAULT NULL,
  `Height` float DEFAULT NULL,
  `Malnutrition` int(1) DEFAULT NULL,
  `WH` int(11) DEFAULT NULL,
  `BCG` int(11) DEFAULT NULL,
  `OPV` int(11) DEFAULT NULL,
  `Measles` int(11) DEFAULT NULL,
  `Other` char(20) DEFAULT NULL,
  `Feeding` int(1) DEFAULT NULL,
  `DNA` int(1) DEFAULT NULL,
  `DaResult` date DEFAULT NULL,
  `Vid` char(17) DEFAULT NULL,
  `TestID` char(17) DEFAULT NULL,
  `DaApp` date DEFAULT NULL,
  `Antibody` int(1) DEFAULT NULL,
  `DaAntibody` date DEFAULT NULL,
  `Antiaffeeding` int(1) DEFAULT NULL,
  `OtherDNA` char(30) DEFAULT NULL,
  `DNAPre` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- tblevarvdrug: Exposed infant ARV drugs
-- ============================================================
CREATE TABLE IF NOT EXISTS `tblevarvdrug` (
  `DrugName` char(16) DEFAULT NULL,
  `Dose` char(20) DEFAULT NULL,
  `Quantity` int(3) DEFAULT NULL,
  `Freq` char(5) DEFAULT NULL,
  `Form` char(15) DEFAULT NULL,
  `Status` int(1) DEFAULT NULL,
  `Da` date DEFAULT NULL,
  `Reason` char(40) DEFAULT NULL,
  `Remark` char(6) DEFAULT NULL,
  `Vid` char(17) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- tbletest: Exposed infant lab tests
-- ============================================================
CREATE TABLE IF NOT EXISTS `tbletest` (
  `ClinicID` char(9) DEFAULT NULL,
  `DNAPcr` int(1) DEFAULT NULL,
  `DaPcrArr` date DEFAULT NULL,
  `OI` char(6) DEFAULT NULL,
  `DaBlood` date DEFAULT NULL,
  `LabID` char(10) DEFAULT NULL,
  `DaReceive` date DEFAULT NULL,
  `DaAnalys` date DEFAULT NULL,
  `Result` int(1) DEFAULT NULL,
  `DaRresult` date DEFAULT NULL,
  `DBS` char(6) DEFAULT NULL,
  `Technic` char(6) DEFAULT NULL,
  `ResultIn` char(6) DEFAULT NULL,
  `Other` char(30) DEFAULT NULL,
  `TID` char(17) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- tblevpatientstatus: Exposed infant status
-- ============================================================
CREATE TABLE IF NOT EXISTS `tblevpatientstatus` (
  `ClinicID` char(10) DEFAULT NULL,
  `Status` int(1) DEFAULT NULL,
  `DaStatus` date DEFAULT NULL,
  `Vid` char(17) DEFAULT NULL,
  `transfer_to_site` VARCHAR(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- tblelink: Linking table
-- ============================================================
CREATE TABLE IF NOT EXISTS `tblelink` (
  `ClinicID`  VARCHAR(20)  DEFAULT NULL,
  `Codes`     VARCHAR(50)  DEFAULT NULL,
  `Typecode`  VARCHAR(50)  DEFAULT NULL,
  `ARTIss`    VARCHAR(50)  DEFAULT NULL,
  `DaExpiry`  DATE         DEFAULT NULL,
  `Dacreate`  DATETIME     DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
