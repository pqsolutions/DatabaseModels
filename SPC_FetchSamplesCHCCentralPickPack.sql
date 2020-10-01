USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSamplesCHCCentralPickPack' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSamplesCHCCentralPickPack
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSamplesCHCCentralPickPack] 
(
	@CHCID INT
)
AS
BEGIN
	SELECT SC.[UniqueSubjectID]
		,SC.[ID] AS SampleCollectionID
		,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
		,SPR.[RCHID] 
		,SC.[BarcodeNo]
		,(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime])) AS SampleDateTime
		,CONVERT(DATETIME,(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime])),103) AS SDT
		,CAST((SELECT [dbo].[FN_CalculateGestationalAge](SPR.[SubjectID])) AS DECIMAL(18,1)) AS GestationalAge
		,(CONVERT(VARCHAR,CBC.[TestCompleteOn],103) + ' ' + CONVERT(VARCHAR(5),CBC.[TestCompleteOn],108)) AS CBCTestCompletedDate
	FROM Tbl_SampleCollection SC
	LEFT JOIN Tbl_SubjectPrimaryDetail SP WITH (NOLOCK) ON SP.ID = SC.SubjectID
	LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPR.SubjectID = SP.ID
	LEFT JOIN Tbl_CHCMaster CM WITH (NOLOCK) ON CM.ID = SP.CHCID
	LEFT JOIN Tbl_CHCMaster C WITH (NOLOCK) ON C.ID = CM.TestingCHCID
	LEFT JOIN Tbl_PositiveResultSubjectsDetail PSD WITH (NOLOCK) ON  PSD.BarcodeNo = SC.BarcodeNo
	LEFT JOIN Tbl_CBCTestResult CBC WITH (NOLOCK) ON  CBC.BarcodeNo = SC.BarcodeNo
	WHERE CM.TestingCHCID = @CHCID 
		AND SC.SampleDamaged = 0 AND SC.SampleTimeoutExpiry = 0
		AND SC.BarcodeNo IN (SELECT BarcodeNo FROM Tbl_CBCTestResult WHERE TestingCHCId = @CHCID)  
		AND SC.BarcodeNo IN (SELECT BarcodeNo FROM Tbl_SSTestResult WHERE TestingCHCId = @CHCID)
		AND SC.BarcodeNo IN (SELECT BarcodeNo FROM Tbl_PositiveResultSubjectsDetail WHERE CBCStatus = 'P' OR SSTStatus = 'P') 
		AND SC.BarcodeNo NOT IN (SELECT BarcodeNo FROM Tbl_CHCShipmentsDetail)
	ORDER BY SDT DESC
END