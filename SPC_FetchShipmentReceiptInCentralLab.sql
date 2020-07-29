USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchShipmentReceiptInCentralLab' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchShipmentReceiptInCentralLab 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchShipmentReceiptInCentralLab] 
(
	@CentralLabId INT
)

AS
BEGIN
	SELECT S.[ID]
		,S.[GenratedShipmentID] AS ShipmentID
		,S.[LabTechnicianName] 
		,S.[TestingCHCID] 
		,CM.[CHCname] AS TestingCHC
		,D.[Districtname]
		,CONVERT(VARCHAR,S.[DateofShipment],103) + ' ' + CONVERT(VARCHAR(5),S.[TimeofShipment]) AS ShipmentDateTime
		,S.[ReceivingCentralLabId] 
		,CL.[CentralLabName] 
		,SD.[UniqueSubjectID]
		,SD.[BarcodeNo]
		,SPR.[RCHID]
		,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
		,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime]) AS SampleCollectionDateTime
		FROM [dbo].[Tbl_CHCShipments] S 
		LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.ID = S.TestingCHCID
		LEFT JOIN [dbo].[Tbl_CentralLabMaster] CL WITH (NOLOCK) ON S.ReceivingCentralLabId = CL.ID
		LEFT JOIN [dbo].[Tbl_DistrictMaster] D WITH (NOLOCK) ON D.ID = CM.DistrictID 
		LEFT JOIN [dbo].[Tbl_CHCShipmentsDetail]  SD WITH (NOLOCK) ON SD.ShipmentID = S.ID
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo

	WHERE ISNULL(S.[ReceivedDate],'') = '' AND S.[ReceivingCentralLabId] = @CentralLabId  
	ORDER BY S.[GenratedShipmentID]  

END