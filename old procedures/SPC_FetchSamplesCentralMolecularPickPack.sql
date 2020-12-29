USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSamplesCentralMolecularPickPack' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSamplesCentralMolecularPickPack
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSamplesCentralMolecularPickPack] 
(
	@CentralLabId INT
)
AS
BEGIN
	SELECT SC.[UniqueSubjectID]
		,SC.[ID] AS SampleCollectionID
		,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
		,SPR.[RCHID] 
		,SC.[BarcodeNo]
		,(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime])) AS SampleDateTime
		,CAST((SELECT [dbo].[FN_CalculateGestationalAge](SPR.[SubjectID])) AS DECIMAL(18,1)) AS GestationalAge
		,HT.[HPLCResult] 
	FROM Tbl_SampleCollection SC
	LEFT JOIN Tbl_SubjectPrimaryDetail SP WITH (NOLOCK) ON SP.ID = SC.SubjectID
	LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPR.SubjectID = SP.ID
	LEFT JOIN Tbl_HPLCTestResult HT WITH (NOLOCK) ON HT.BarcodeNo = SC.BarcodeNo 
	LEFT JOIN Tbl_PositiveResultSubjectsDetail PSD WITH (NOLOCK) ON  PSD.BarcodeNo = HT.BarcodeNo
	WHERE HT.CentralLabId  = @CentralLabId AND HT.IsPositive = 1 AND PSD.HPLCStatus = 'P'
		AND HT.BarcodeNo NOT IN (SELECT BarcodeNo FROM Tbl_CentralLabShipmentsDetail)
	ORDER BY GestationalAge DESC
END