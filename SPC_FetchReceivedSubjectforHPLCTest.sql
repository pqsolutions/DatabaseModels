
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
		,HTD.HbF
		,HTD.HbA0
		,HTD.HbA2
		,HTD.HbD
		,HTD.HbS
		,HTD.ID AS HPLCID
		,CONVERT(VARCHAR,HTD.TestedDateTime,103)AS TestedDate
		,CONVERT(DATE,HTD.TestedDateTime,103)AS DateOfTest
		,HTD.InjectionNo
		,HTD.RunNo
	FROM [dbo].[Tbl_CHCShipmentsDetail]  SD 
	LEFT JOIN  [dbo].[Tbl_CHCShipments] S WITH (NOLOCK) ON SD.ShipmentID = S.ID
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_HPLCTestedDetail] HTD WITH(NOLOCK) ON HTD.[Barcode] = SD.[BarcodeNo] 
	WHERE S.[ReceivingCentralLabId] = @CentralLabId  AND SD.[IsAccept] = 1  
	AND S.[ReceivedDate] IS NOT NULL AND SD.[BarcodeNo] NOT IN (SELECT BarcodeNo FROM Tbl_HPLCTestResult)
	AND HTD.ID = (SELECT  TOP 1  ID
		FROM Tbl_HPLCTestedDetail H WHERE H.Barcode = HTD.barcode AND ISNULL(H.ProcessStatus,0) = 0  AND H.SampleStatus  IS NULL 
		AND H.RunNo = (SELECT TOP 1 MAX(HD.RunNo) FROM Tbl_HPLCTestedDetail HD WHERE HD.Barcode = HTD.barcode) ORDER BY H.InjectionNo,H.ID DESC)
	ORDER BY DateOfTest DESC
END
