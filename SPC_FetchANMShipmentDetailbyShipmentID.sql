USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Samples detail of particular shipment of ANM user 
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchANMShipmentDetailbyShipmentID' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchANMShipmentDetailbyShipmentID
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchANMShipmentDetailbyShipmentID](@ShipmentID VARCHAR(200))
As
BEGIN
	SELECT S.[ID]
		,S.[SubjectID]
		,S.[UniqueSubjectID]
		,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
		,S.[SampleCollectionID]
		,SC.[BarcodeNo] 
		,S.[ShipmentFrom]
		,S.[ShipmentID]
		,S.[ANM_ID]
		,(UM.[FirstName] + ' ' + UM.[MiddleName] + ' ' + UM.[LastName]) AS ANMName
		,S.[TestingCHCID]
		,CM.[CHCname] AS TestingCHC
		,S.[ILR_ID] 
		,IM.[ILRPoint]
		,S.[AVDID] 
		,AM.[AVDName]
		,S.[ContactNo]
		,CONVERT(VARCHAR,S.[DateofShipment],105) AS ShipmentDate
		,CONVERT(VARCHAR(5),S.[TimeofShipment]) AS ShipmentTime
	FROM [dbo].[Tbl_ANMShipment] S
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.ID = S.SubjectID AND SP.UniqueSubjectID = S.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.ID = S.SampleCollectionID
	LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.ID = S.ANM_ID
	LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.ID = S.TestingCHCID
	LEFT JOIN [dbo].[Tbl_AVDMaster] AM WITH (NOLOCK) ON AM.ID = S.AVDID
	LEFT JOIN [dbo].[Tbl_ILRMaster] IM WITH (NOLOCK) ON IM.ID = S.ILR_ID
	WHERE S.ShipmentID = @ShipmentID

END


