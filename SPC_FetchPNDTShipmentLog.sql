--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Shipment Details (Log) of particular PNDT Location 

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchPNDTShipmentLog' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchPNDTShipmentLog 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchPNDTShipmentLog] 
(
	@PNDTLocationId INT
	
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
		FROM [dbo].[Tbl_PNDTShipments] S
		LEFT JOIN [dbo].[Tbl_PNDTShipmentsDetail] SD  WITH (NOLOCK) ON SD.ShipmentID = S.ID
		LEFT JOIN [dbo].[Tbl_MolecularLabMaster] MM  WITH (NOLOCK) ON S.ReceivingMolecularLabId = MM.ID
		LEFT JOIN [dbo].[Tbl_PNDTLocationMaster] PL  WITH (NOLOCK) ON S.PNDTLocationId = PL.ID
		LEFT JOIN [dbo].[Tbl_PNDTFoetusDetail] PF  WITH (NOLOCK) ON SD.PNDTFoetusId = PF.ID
		LEFT JOIN [dbo].[Tbl_PNDTestNew] PT  WITH (NOLOCK) ON PF.PNDTestId = PT.ID
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.UniqueSubjectID = PT.ANWSubjectId
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.UniqueSubjectID = PT.ANWSubjectId
	WHERE S.PNDTLocationId = @PNDTLocationId 
	ORDER BY S.[GenratedShipmentID] DESC
END