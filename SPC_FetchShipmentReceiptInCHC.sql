--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchShipmentReceiptInCHC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchShipmentReceiptInCHC 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchShipmentReceiptInCHC] 
(
	@TestingCHCId INT
)

AS
DECLARE @TestingCHC INT
BEGIN
	SET @TestingCHC = (SELECT TestingCHCID FROM Tbl_CHCMaster WHERE ID = @TestingCHCId)
	SELECT S.[ID]
		,S.[GenratedShipmentID] AS ShipmentID
		,S.[ShipmentFrom]
		,CV.[CommonName] AS ShippedFrom
		,CASE WHEN((SELECT Commonname FROM Tbl_ConstantValues  WHERE ID = S.[ShipmentFrom] ) = 'ANM - CHC') THEN
		(UM.[FirstName] + ' ' + UM.[MiddleName] + ' ' + UM.[LastName])
		ELSE (UMC.[FirstName] + ' ' + UMC.[MiddleName] + ' ' + UMC.[LastName]) END AS SenderName
		,CASE WHEN((SELECT Commonname FROM Tbl_ConstantValues  WHERE ID = S.[ShipmentFrom] ) = 'ANM - CHC') THEN
		RM.[RIsite]
		ELSE CM1.[CHCname] END AS SendingLocation
		,CONVERT(VARCHAR,S.[DateofShipment],103) + ' ' + CONVERT(VARCHAR(5),S.[TimeofShipment]) AS ShipmentDateTime
		,CONVERT(DATETIME,(CONVERT(VARCHAR,S.[DateofShipment],103) + ' ' + CONVERT(VARCHAR(5),S.[TimeofShipment])),103) AS ShipmentDate
		,CM1.[CHCname] AS CollectionCHC
		,CM.[CHCname] AS ReceivingTestingCHC
		,IM.[ILRPoint]
		,RM.[RIsite] AS RIPoint
		,SD.[UniqueSubjectID]
		,SD.[BarcodeNo]
		,SPR.[RCHID]
		,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
		,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime]) AS SampleCollectionDateTime
	FROM [dbo].[Tbl_ANMCHCShipments] S 
	LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.ID = S.ANM_ID
	LEFT JOIN [dbo].[Tbl_UserMaster] UMC WITH (NOLOCK) ON UMC.ID = S.CHCUserId 
	LEFT JOIN [dbo].[Tbl_ConstantValues]  CV WITH (NOLOCK) ON CV.ID = S.ShipmentFrom 
	LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.ID = S.TestingCHCID
	LEFT JOIN [dbo].[Tbl_CHCMaster] CM1 WITH (NOLOCK) ON CM1.ID = S.CollectionCHCID
	LEFT JOIN [dbo].[Tbl_ILRMaster] IM WITH (NOLOCK) ON IM.ID = S.ILR_ID
	LEFT JOIN [dbo].[Tbl_RIMaster] RM WITH (NOLOCK) ON RM.ID = S.RIID
	LEFT JOIN [dbo].[Tbl_ANMCHCShipmentsDetail]  SD WITH (NOLOCK) ON SD.ShipmentID = S.ID
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = SD.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = SD.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.UniqueSubjectID = SD.UniqueSubjectID
	WHERE ISNULL(S.[ReceivedDate],'') = '' AND S.[TestingCHCID] = @TestingCHC
	AND S.ID IN(SELECT ShipmentID FROM [dbo].[Tbl_ANMCHCShipmentsDetail] )
	ORDER BY ShipmentDate DESC  
END


