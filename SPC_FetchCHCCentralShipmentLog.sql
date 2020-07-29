USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchCHCCentralShipmentLog' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchCHCCentralShipmentLog
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchCHCCentralShipmentLog] 
(
	@TestingCHCID INT
)
AS
BEGIN
	SELECT S.[ID]
		,S.[GenratedShipmentID] AS ShipmentID
		,S.[LabTechnicianName] 
		,CM.[CHCname] AS TestingCHC
		,LPM.[ProviderName] AS LogisticsProviderName
		,CLM.[CentralLabName] AS ReceivingCentralLab
		,S.[DeliveryExecutiveName] 
		,S.[ExecutiveContactNo]  AS ContactNo
		,CONVERT(VARCHAR,S.[DateofShipment],103) + ' ' + CONVERT(VARCHAR(5),S.[TimeofShipment]) AS ShipmentDateTime
		,SD.[UniqueSubjectID]
		,SD.[BarcodeNo]
		,SPR.[RCHID]
		,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
		,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime]) AS SampleCollectionDateTime

	FROM [dbo].[Tbl_CHCShipments] S 
	LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.ID = S.TestingCHCID
	LEFT JOIN [dbo].[Tbl_CentralLabMaster] CLM WITH (NOLOCK) ON CLM.ID = S.ReceivingCentralLabId 
	LEFT JOIN [dbo].[Tbl_LogisticsProviderMaster]  LPM WITH (NOLOCK) ON LPM.ID = S.LogisticsProviderId
	LEFT JOIN [dbo].[Tbl_CHCShipmentsDetail]  SD WITH (NOLOCK) ON SD.ShipmentID = S.ID
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo
	WHERE S.[TestingCHCID] = @TestingCHCID 
	ORDER BY S.[GenratedShipmentID] DESC   
END