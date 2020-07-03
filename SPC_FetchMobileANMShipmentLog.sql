USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Shipment Details (Log) of particular ANM user

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMobileANMShipmentLog' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMobileANMShipmentLog
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMobileANMShipmentLog] 
(
	@UserID INT
)
AS
BEGIN
	
	SELECT S.[ID]
	  ,S.[GenratedShipmentID]
	  ,S.[ANM_ID] 
	  ,(UM.[FirstName] + ' ' + UM.[MiddleName] + ' ' + UM.[LastName]) AS ANMName
	  ,S.[TestingCHCID] 
	  ,CM.[CHCname] AS ReceivingTestingCHC
	  ,S.[AVDID] 
	  ,AM.[AVDName]
	  ,S.[AVDContactNo]
	  ,S.[ILR_ID] 
	  ,IM.[ILRPoint]
	  ,S.[RIID] 
	  ,RM.[RIsite] AS RIPoint
	  ,CONVERT(VARCHAR,S.[DateofShipment],103) AS ShipmentDate
	  ,CONVERT(VARCHAR(5),S.[TimeofShipment]) AS ShipmentTime
	  ,SD.[ShipmentID]
	  ,SD.[UniqueSubjectID]
	  ,SD.[BarcodeNo]
	  ,SPR.[RCHID]
	  ,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
	  ,CONVERT(VARCHAR,SC.[SampleCollectionDate],103)AS SampleCollectionDate
	  ,CONVERT(VARCHAR(5),SC.[SampleCollectionTime]) AS SampleCollectionTime
	  ,S.[CreatedBy] 
	  ,RIGHT(LTRIM(RTRIM(S.[GenratedShipmentID])),1) AS Sources
	FROM [dbo].[Tbl_ANMCHCShipments] S 
	LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.ID = S.ANM_ID
	LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.ID = S.TestingCHCID
	LEFT JOIN [dbo].[Tbl_AVDMaster] AM WITH (NOLOCK) ON AM.ID = S.AVDID
	LEFT JOIN [dbo].[Tbl_ILRMaster] IM WITH (NOLOCK) ON IM.ID = S.ILR_ID
	LEFT JOIN [dbo].[Tbl_RIMaster] RM WITH (NOLOCK) ON RM.ID = S.RIID
	LEFT JOIN [dbo].[Tbl_ANMCHCShipmentsDetail]  SD WITH (NOLOCK) ON SD.ShipmentID = S.ID
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
	LEFT Join [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo
	WHERE S.[ANM_ID] = @UserID
	ORDER BY S.[DateofShipment],S.[TimeofShipment] DESC   
	
END


