USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Samples detail of particular shipment of ANM user / CHC 

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchANMCHCShipmentDetailbyShipmentID' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchANMCHCShipmentDetailbyShipmentID
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchANMCHCShipmentDetailbyShipmentID]
(
	@ShipmentID VARCHAR(200)
	,@ShipmentFrom VARCHAR(10)
)
As
BEGIN
	IF @ShipmentFrom = 'ANM'
	BEGIN
		SELECT S.[ID]
			,S.[SubjectID]
			,S.[UniqueSubjectID]
			,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
			,SPR.[RCHID] 
			,S.[SampleCollectionID]
			,SC.[BarcodeNo] 
			,S.[ShipmentFrom]
			,S.[ShipmentID]
			,S.[ANM_ID]
			,(UM.[FirstName] + ' ' + UM.[MiddleName] + ' ' + UM.[LastName]) AS ANMName
			,S.[TestingCHCID]
			,CM.[CHCname] AS TestingCHC
			,S.[RIID] 
			,RI.[RIsite] AS RIPoint
			,S.[ILR_ID] 
			,IM.[ILRPoint]
			,S.[AVDID] 
			,AM.[AVDName]
			,S.[ContactNo]
			,CONVERT(VARCHAR,S.[DateofShipment],105) AS ShipmentDate
			,CONVERT(VARCHAR(5),S.[TimeofShipment]) AS ShipmentTime
		FROM [dbo].[Tbl_ANMCHCShipment] S
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.ID = S.SubjectID AND SP.UniqueSubjectID = S.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail]  SPR WITH (NOLOCK) ON SP.ID = SPR.SubjectID
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.ID = S.SampleCollectionID
		LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.ID = S.ANM_ID
		LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.ID = S.TestingCHCID
		LEFT JOIN [dbo].[Tbl_AVDMaster] AM WITH (NOLOCK) ON AM.ID = S.AVDID
		LEFT JOIN [dbo].[Tbl_ILRMaster] IM WITH (NOLOCK) ON IM.ID = S.ILR_ID
		LEFT JOIN [dbo].[Tbl_RIMaster] RI WITH (NOLOCK) ON RI.ID = S.RIID
		WHERE S.ShipmentID = @ShipmentID AND S.ShipmentFrom = @ShipmentFrom
	END
	ELSE IF @ShipmentFrom = 'CHC'
	BEGIN
		SELECT S.[ID]
			,S.[SubjectID]
			,S.[UniqueSubjectID]
			,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
			,SPR.[RCHID] 
			,S.[SampleCollectionID]
			,SC.[BarcodeNo] 
			,S.[ShipmentFrom]
			,S.[ShipmentID]
			,S.[ANM_ID]
			,(UM.[FirstName] + ' ' + UM.[MiddleName] + ' ' + UM.[LastName]) AS ANMName -- << CHC Lab Technician Name >>
			,S.[TestingCHCID]
			,CM.[CHCname] AS TestingCHC
			,S.[RIID] 
			,CM1.[CHCname] AS RIPoint -- << Collection CHC >>
			,S.[ILR_ID] 
			,LP.[ProviderName] AS ILRPoint -- << Logistics Service Provider >>
			,isNULL(S.[AVDID],0) AS AVDID 
			,S.[DeliveryExecutiveName] AS AVDName -- << Delivery Executive Name >>
			,S.[ContactNo]
			,CONVERT(VARCHAR,S.[DateofShipment],105) AS ShipmentDate
			,CONVERT(VARCHAR(5),S.[TimeofShipment]) AS ShipmentTime
		FROM [dbo].[Tbl_ANMCHCShipment] S
		LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.ID = S.SubjectID AND SP.UniqueSubjectID = S.UniqueSubjectID
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail]  SPR WITH (NOLOCK) ON SP.ID = SPR.SubjectID
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.ID = S.SampleCollectionID
		LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.ID = S.ANM_ID
		LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.ID = S.TestingCHCID
		LEFT JOIN [dbo].[Tbl_CHCMaster] CM1 WITH (NOLOCK) ON CM1.ID = S.RIID 
		LEFT JOIN [dbo].[Tbl_LogisticsProviderMaster]  LP WITH (NOLOCK) ON LP.ID = S.ILR_ID 
		WHERE S.ShipmentID = @ShipmentID AND S.ShipmentFrom = @ShipmentFrom
	END
END


