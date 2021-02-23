--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Specimen Shipment Details Receipt  in Molecular Lab

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchPNDTShipmentReceiptInMolLab' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchPNDTShipmentReceiptInMolLab 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchPNDTShipmentReceiptInMolLab] 
(
	@MolecularLabId INT
)
AS
BEGIN

	SELECT S.[ID]
		  ,S.[GenratedShipmentID] AS ShipmentID
		  ,(CONVERT(VARCHAR,S.[ShipmentDateTime],103) + ' ' + CONVERT(VARCHAR(5),S.[ShipmentDateTime],108))  AS ShipmentDateTime
		  ,S.[SenderName]
		  ,S.[SenderContact]
		  ,S.[SenderLocation]
		  ,MM.[MLabName] as ReceivingMolecularLab
		  ,PL.[PNDTLocationName] AS PNDTLocation
		  ,PT.[ANWSubjectId]
		  ,PT.[SpouseSubjectId]
		  ,(CONVERT(VARCHAR,PT.[PNDTDateTime],103))  AS SpecimenCollectionDate
		  ,PT.[PregnancyType]
		  ,PF.[CVSSampleRefId]
		  ,PF.[FoetusName]
		  ,PF.[SampleRefId]
		  ,SPD.[RCHID]
		  ,(SP.[FirstName] + ' ' + SP.[LastName]) SubjectName
		  ,SD.[ShipmentID] AS PNDTShipmentId
		  ,SD.[PNDTestId]
		  ,SD.[PNDTFoetusId]
	FROM [dbo].[Tbl_PNDTShipments] S
	LEFT JOIN [dbo].[Tbl_PNDTShipmentsDetail] SD  WITH (NOLOCK) ON SD.ShipmentID = S.ID
	LEFT JOIN [dbo].[Tbl_MolecularLabMaster] MM  WITH (NOLOCK) ON S.ReceivingMolecularLabId = MM.ID
	LEFT JOIN [dbo].[Tbl_PNDTLocationMaster] PL  WITH (NOLOCK) ON S.PNDTLocationId = PL.ID
	LEFT JOIN [dbo].[Tbl_PNDTFoetusDetail] PF  WITH (NOLOCK) ON SD.PNDTFoetusId = PF.ID
	LEFT JOIN [dbo].[Tbl_PNDTestNew] PT  WITH (NOLOCK) ON PF.PNDTestId = PT.ID
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.UniqueSubjectID = PT.ANWSubjectId
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.UniqueSubjectID = PT.ANWSubjectId
	WHERE  ISNULL(S.[ReceivedDateTime],'') = '' AND S.[ReceivingMolecularLabId] = @MolecularLabId  
	ORDER BY S.[GenratedShipmentID] DESC
END