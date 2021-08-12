
--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchReceivedSubjectforHPLCTest' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchReceivedSubjectforHPLCTest 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchReceivedSubjectforHPLCTest] 
(
	@CentralLabId INT
)

AS
BEGIN
	SELECT  DISTINCT (SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
		,SD.[UniqueSubjectID]
		,SD.[BarcodeNo]
		,CASE WHEN SP.ChildSubjectTypeID = 1 THEN SPR.[RCHID] ELSE '' END AS RCHID
		,(SELECT [dbo].[FN_FetchHbFResults] (SD.BarcodeNo)) AS HbF
		,(SELECT [dbo].[FN_FetchHbA0Results] (SD.BarcodeNo)) AS HbA0
		,(SELECT [dbo].[FN_FetchHbA2Results] (SD.BarcodeNo)) AS HbA2
		,(SELECT [dbo].[FN_FetchHbDResults] (SD.BarcodeNo)) AS HbD
		,(SELECT [dbo].[FN_FetchHbSResults] (SD.BarcodeNo)) AS HbS
		,(SELECT [dbo].[FN_FetchHPLCTestedDateResults] (SD.BarcodeNo)) AS TestedDate
		,(SELECT [dbo].[FN_FetchHPLCTestedIDResults] (SD.BarcodeNo)) AS HPLCID
		--,CONVERT(DATETIME,(SELECT [dbo].[FN_FetchHPLCTestedDateResults] (SD.BarcodeNo)),103) AS DateOfTest
	FROM [dbo].[Tbl_CHCShipmentsDetail]  SD 
	LEFT JOIN  [dbo].[Tbl_CHCShipments] S WITH (NOLOCK) ON SD.ShipmentID = S.ID
	--LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
	--LEFT JOIN [dbo].[Tbl_HPLCTestedDetail] HTD WITH(NOLOCK) ON HTD.[Barcode] = SD.[BarcodeNo] 
	WHERE S.[ReceivingCentralLabId] = @CentralLabId  AND SD.[IsAccept] = 1  
	AND S.[ReceivedDate] IS NOT NULL AND SD.[BarcodeNo] NOT IN (SELECT BarcodeNo FROM Tbl_HPLCTestResult)
	--ORDER BY DateOfTest DESC
END
