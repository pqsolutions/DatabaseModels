USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Shipment Details (Log) of particular ANM user/ CHC

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchANMCHCShipmentLog' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchANMCHCShipmentLog
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchANMCHCShipmentLog] 
(
	@UserID INT
	,@ShipmentFrom INT
)
AS
BEGIN
	DECLARE @ShipFrom VARCHAR(10),@CHCID INT
	SELECT @ShipFrom = UPPER(CommonName) FROM Tbl_ConstantValues WHERE ID = @ShipmentFrom  AND comments='ShipmentFrom'
	SELECT @CHCID = CHCID FROM Tbl_UserMaster WHERE ID = @UserID
	IF @ShipFrom = 'ANM - CHC'
	BEGIN
		SELECT S.[ID]
		  ,S.[GenratedShipmentID] AS ShipmentID
		  ,(UM.[FirstName] + ' ' + UM.[MiddleName] + ' ' + UM.[LastName]) AS ANMName
		  ,CM.[CHCname] AS ReceivingTestingCHC
		  ,AM.[AVDName]
		  ,S.[AVDContactNo] AS ContactNo
		  ,ISNULL(S.[AlternateAVD] ,'') AS AlternateAVD
	      ,ISNULL(S.[AlternateAVDContactNo] ,'') AS AlternateAVDContactNo
		  ,IM.[ILRPoint]
		  ,RM.[RIsite] AS RIPoint
		  ,CONVERT(VARCHAR,S.[DateofShipment],103) + ' ' + CONVERT(VARCHAR(5),S.[TimeofShipment]) AS ShipmentDateTime
		  ,SD.[UniqueSubjectID]
		  ,SD.[BarcodeNo]
		  ,SPR.[RCHID]
		  ,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
		  ,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime]) AS SampleCollectionDateTime
		FROM [dbo].[Tbl_ANMCHCShipments] S 
		LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.ID = S.ANM_ID
		LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.ID = S.TestingCHCID
		LEFT JOIN [dbo].[Tbl_AVDMaster] AM WITH (NOLOCK) ON AM.ID = S.AVDID
		LEFT JOIN [dbo].[Tbl_ILRMaster] IM WITH (NOLOCK) ON IM.ID = S.ILR_ID
		LEFT JOIN [dbo].[Tbl_RIMaster] RM WITH (NOLOCK) ON RM.ID = S.RIID
		LEFT JOIN [dbo].[Tbl_ANMCHCShipmentsDetail]  SD WITH (NOLOCK) ON SD.ShipmentID = S.ID
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo
		WHERE S.[ANM_ID] = @UserID AND S.[ShipmentFrom] = @ShipmentFrom
		ORDER BY S.[GenratedShipmentID] DESC   
	END
	ELSE IF @ShipFrom = 'CHC - CHC'
	BEGIN
		SELECT S.[ID]
		   ,S.[GenratedShipmentID] AS ShipmentID
		  ,(UM.[FirstName] + ' ' + UM.[MiddleName] + ' ' + UM.[LastName]) AS CHCLabTechnicianName
		  ,(UM1.[FirstName] + ' ' + UM1.[MiddleName] + ' ' + UM1.[LastName]) AS AssociatedANMName
		  ,CM.[CHCname] AS ReceivingTestingCHC
		  ,CM1.[CHCname] AS CollectionCHC
		  ,LPM.[ProviderName] AS LogisticsProviderName
		  ,S.[DeliveryExecutiveName] 
		  ,S.[ExecutiveContactNo]  AS ContactNo
		  ,CONVERT(VARCHAR,S.[DateofShipment],103) + ' ' + CONVERT(VARCHAR(5),S.[TimeofShipment]) AS ShipmentDateTime
		  ,SD.[UniqueSubjectID]
		  ,SD.[BarcodeNo]
		  ,SPR.[RCHID]
		  ,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
		  ,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime]) AS SampleCollectionDateTime
		FROM [dbo].[Tbl_ANMCHCShipments] S 
		LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.ID = S.CHCUserId 
		LEFT JOIN [dbo].[Tbl_CHCMaster] CM1 WITH (NOLOCK) ON CM1.ID = S.CollectionCHCID
		LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.ID = S.TestingCHCID
		LEFT JOIN [dbo].[Tbl_LogisticsProviderMaster]  LPM WITH (NOLOCK) ON LPM.ID = S.LogisticsProviderId
		LEFT JOIN [dbo].[Tbl_ANMCHCShipmentsDetail]  SD WITH (NOLOCK) ON SD.ShipmentID = S.ID
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_UserMaster] UM1 WITH (NOLOCK) ON UM1.ID = SP.AssignANM_ID  
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = SD.BarcodeNo
		WHERE  S.[ShipmentFrom] = @ShipmentFrom AND S.[CollectionCHCID] = @CHCID
		ORDER BY S.[DateofShipment],S.[TimeofShipment] DESC  
	END
	
END


