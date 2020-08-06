USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchCentralMolecularShipmentLog' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchCentralMolecularShipmentLog
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchCentralMolecularShipmentLog] 
(
	@CentralLabId INT
)
AS
BEGIN
	SELECT S.[ID]
		,S.[GenratedShipmentID] AS ShipmentID
		,S.[LabTechnicianName] 
		,S.[LogisticsProviderName]
		,CLM.[CentralLabName]
		,ML.[MLabName] AS MolecularLabName
		,S.[DeliveryExecutiveName] 
		,S.[ExecutiveContactNo]  AS ContactNo
		,CONVERT(VARCHAR,S.[DateofShipment],103) + ' ' + CONVERT(VARCHAR(5),S.[TimeofShipment]) AS ShipmentDateTime
		,SD.[UniqueSubjectID]
		,SD.[BarcodeNo]
		,SPR.[RCHID]
		,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
		,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime]) AS SampleCollectionDateTime
	FROM [dbo].[Tbl_CentralLabShipments] S 
	LEFT JOIN [dbo].[Tbl_CentralLabMaster] CLM WITH (NOLOCK) ON CLM.ID = S.CentralLabId 
	LEFT JOIN [dbo].[Tbl_MolecularLabMaster] ML WITH (NOLOCK) ON S.ReceivingMolecularLabId = ML.ID
	LEFT JOIN [dbo].[Tbl_CentralLabShipmentsDetail]  SD WITH (NOLOCK) ON SD.ShipmentID = S.ID
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo
	WHERE S.[CentralLabId] = @CentralLabId  
	ORDER BY S.[DateofShipment],S.[TimeofShipment] DESC    
END