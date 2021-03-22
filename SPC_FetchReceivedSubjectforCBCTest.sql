
--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchReceivedSubjectforCBCTest' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchReceivedSubjectforCBCTest 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchReceivedSubjectforCBCTest] 
(
	@TestingCHCId INT
)

AS
BEGIN
	SELECT  DISTINCT (SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
		,SD.[UniqueSubjectID]
		,SD.[BarcodeNo]
		,CASE WHEN SP.ChildSubjectTypeID = 1 THEN SPR.[RCHID] ELSE '' END AS RCHID
		,(SELECT [dbo].[FN_FetchMCVResults] (SD.BarcodeNo)) AS MCV
		,(SELECT [dbo].[FN_FetchRDWResults] (SD.BarcodeNo)) AS RDW
		,(SELECT [dbo].[FN_FetchRBCResults] (SD.BarcodeNo)) AS RBC
		,(SELECT [dbo].[FN_FetchCBCTestedIdResults] (SD.BarcodeNo)) AS TestedId
		,(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime])) AS SampleDateTime
		,(SELECT [dbo].[FN_FetchCBCTesedDateResults] (SD.BarcodeNo)) AS TestedDateTime
		,(SELECT [dbo].[FN_FindTimeoutCBCResults] (SD.BarcodeNo,
		CONVERT(DATETIME,(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime])),103))) AS TimeOutStatus
	FROM [dbo].[Tbl_ANMCHCShipmentsDetail]  SD 
	LEFT JOIN [dbo].[Tbl_ANMCHCShipments] S WITH (NOLOCK) ON SD.ShipmentID = S.ID
	LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_CBCTestedDetail] CTD WITH(NOLOCK) ON CTD.[Barcode] = SD.[BarcodeNo] 
	WHERE S.[TestingCHCID] = @TestingCHCId AND SC.[IsAccept] = 1 AND SC.[SampleDamaged] = 0 AND SC.[SampleTimeoutExpiry] = 0
	AND SD.[BarcodeNo] NOT IN (SELECT BarcodeNo FROM Tbl_CBCTestResult)
	ORDER BY   TestedDateTime DESC
END
