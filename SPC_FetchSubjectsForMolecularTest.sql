USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSubjectsForMolecularTest' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSubjectsForMolecularTest
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSubjectsForMolecularTest] 
(
	@MolecularLabId INT
)
AS
BEGIN
	SELECT SP.[ID] AS SubjectId
		,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
		,SD.[UniqueSubjectID]
		,ST.[SubjectType] 
		,ISNULL(SPR.[RCHID] ,'') AS RCHID
		,SP.[Age] 
		,SP.[Gender] 
		,CASE WHEN ISNULL(SP.[DOB],'') = '' THEN '' ELSE CONVERT(VARCHAR,SP.[DOB],103) END DOB
		,SP.[MobileNo] AS ContactNo
		,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
			CONVERT(VARCHAR,SPR.[LMP_Date],103) ELSE '' END AS LMPDate
		,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
		 CONVERT(DECIMAL(10,1),(SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID]))) ELSE '' END AS GestationalAge
		,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
		 ('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+
		 CONVERT(VARCHAR,SPR.[A])) ELSE '' END AS ObstetricScore
		,ISNULL(SPR.[ECNumber],'') AS ECNumber
		,SD.[BarcodeNo]
		,DM.[Districtname]
		,CR.[MCV] 
		,CR.[RDW] 
		,PRSD.[CBCResult] 
		,CASE WHEN PRSD.[SSTStatus] = 'P' THEN 'Positive' ELSE 'Negative' END AS SSTResult
		,PRSD.[HPLCTestResult]
		,HR.[HbA0]
		,HR.[HbA2] 
		,HR.[HbC]
		,HR.[HbD]
		,HR.[HbF]
		,HR.[HbS] 
		,CDM.[DiagnosisName] AS HPLCDiagnosis
	FROM [dbo].[Tbl_CentralLabShipments] S 
	LEFT JOIN [dbo].[Tbl_CentralLabShipmentsDetail]  SD WITH (NOLOCK) ON SD.ShipmentID = S.ID
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.[ChildSubjectTypeID] 
	LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo 
	LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID
	LEFT JOIN [dbo].[Tbl_CBCTestResult] CR WITH (NOLOCK) ON CR.BarcodeNo = SD.BarcodeNo 
	LEFT JOIN [dbo].[Tbl_SSTestResult] SR WITH (NOLOCK) ON SR.BarcodeNo = SD.BarcodeNo 
	LEFT JOIN [dbo].[Tbl_HPLCTestResult] HR WITH (NOLOCK) ON HR.BarcodeNo = SD.BarcodeNo 
	LEFT JOIN [dbo].[Tbl_PositiveResultSubjectsDetail] PRSD WITH (NOLOCK) ON PRSD.BarcodeNo = SD.BarcodeNo 
	LEFT JOIN [dbo].[Tbl_HPLCDiagnosisResult] HD WITH (NOLOCK) ON HD.BarcodeNo = PRSD.BarcodeNo 
	LEFT JOIN [dbo].[Tbl_ClinicalDiagnosisMaster] CDM WITH (NOLOCK) ON HD.ClinicalDiagnosisId = CDM.ID 
	WHERE S.[ReceivedDate] IS NOT NULL AND S.[ReceivingMolecularLabId] = @MolecularLabId 
	AND SD.[BarcodeNo]   NOT IN (SELECT BarcodeNo FROM Tbl_MolecularTestResult)
	
END