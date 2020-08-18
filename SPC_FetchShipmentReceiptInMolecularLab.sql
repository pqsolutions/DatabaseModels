USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchShipmentReceiptInMolecularLab' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchShipmentReceiptInMolecularLab 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchShipmentReceiptInMolecularLab] 
(
	@MolecularLabId INT
)
AS
BEGIN
	SELECT S.[ID]
		,S.[GenratedShipmentID] AS ShipmentID
		,S.[LabTechnicianName] 
		,CLM.[CentralLabName]
		,ML.[MLabName] AS MolecularLabName
		,CONVERT(VARCHAR,S.[DateofShipment],103) + ' ' + CONVERT(VARCHAR(5),S.[TimeofShipment]) AS ShipmentDateTime
		,CONVERT(DATETIME,(CONVERT(VARCHAR,S.[DateofShipment],103) + ' ' + CONVERT(VARCHAR(5),S.[TimeofShipment])),103) AS ShipmentDate
		,SD.[UniqueSubjectID]
		,SD.[BarcodeNo]
		,SPR.[RCHID]
		,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
		,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime]) AS SampleCollectionDateTime
		,(CONVERT(VARCHAR,HT.[HPLCTestCompletedOn],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime],108)) AS HPLCTestDateTime
	FROM [dbo].[Tbl_CentralLabShipments] S 
	LEFT JOIN [dbo].[Tbl_CentralLabMaster] CLM WITH (NOLOCK) ON CLM.ID = S.CentralLabId 
	LEFT JOIN [dbo].[Tbl_MolecularLabMaster] ML WITH (NOLOCK) ON S.ReceivingMolecularLabId = ML.ID
	LEFT JOIN [dbo].[Tbl_CentralLabShipmentsDetail]  SD WITH (NOLOCK) ON SD.ShipmentID = S.ID
	LEFT JOIN [dbo].[Tbl_HPLCTestResult] HT WITH (NOLOCK) ON SD.BarcodeNo = HT.BarcodeNo 
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo
	WHERE ISNULL(S.[ReceivedDate],'') = '' AND S.[ReceivingMolecularLabId] = @MolecularLabId   
	ORDER BY ShipmentDate DESC

END