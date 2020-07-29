
USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchDetailforHPLCTest' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchDetailforHPLCTest
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchDetailforHPLCTest] 
(
	@CentralLabId INT
)

AS
BEGIN
	SELECT (SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
		,SD.[UniqueSubjectID]
		,SD.[BarcodeNo]
		,SPR.[RCHID]
		,0 AS [HbF]
		,0 AS [HbA0]
		,0 AS [HbA2]
		,0 AS [HbS]
		,0 AS [HbC]
		,0 AS [HbD]
	FROM [dbo].[Tbl_CHCShipmentsDetail]  SD 
	LEFT JOIN  [dbo].[Tbl_CHCShipments] S WITH (NOLOCK) ON SD.ShipmentID = S.ID
	LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
	WHERE S.[ReceivingCentralLabId] = @CentralLabId  AND SC.[IsAccept] = 1 
	AND S.[ReceivedDate] IS NOT NULL AND SD.[BarcodeNo] NOT IN (SELECT BarcodeNo FROM Tbl_HPLCTestResult)
END
