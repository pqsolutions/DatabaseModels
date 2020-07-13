USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchDetailforSSTest' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchDetailforSSTest 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchDetailforSSTest] 
(
	@TestingCHCId int
)

AS
BEGIN
	SELECT (SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
		,SD.[UniqueSubjectID]
		,SD.[BarcodeNo]
		,SPR.[RCHID]
		,ISNULL(C.[MCV],0) AS MCV
		,ISNULL(C.[RDW],0) AS RDW
	FROM [dbo].[Tbl_ANMCHCShipmentsDetail]  SD 
	LEFT JOIN  [dbo].[Tbl_ANMCHCShipments] S WITH (NOLOCK) ON SD.ShipmentID = S.ID
	LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_CBCTestResult]  C  WITH (NOLOCK) ON C.BarcodeNo = SD.BarcodeNo
	WHERE S.[TestingCHCID] = @TestingCHCId AND SC.IsAccept = 1 
	AND SD.[BarcodeNo] NOT IN (SELECT BarcodeNo FROM Tbl_SSTestResult)
END
