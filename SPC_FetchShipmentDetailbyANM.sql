USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchShipmentDetailbyANM' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchShipmentDetailbyANM
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchShipmentDetailbyANM] (@ANMID INT)
AS
BEGIN
	SELECT 
       S.[ShipmentID]
      ,(UM.[FirstName] + ' ' + UM.[MiddleName] + ' ' + UM.[LastName]) AS ANMName
      ,CM.[CHCname] AS TestingCHC
      ,AM.[AVDName]
      ,IM.[ILRPoint]
      ,CONVERT(VARCHAR,S.[DateofShipment],105) AS ShipmentDate
	FROM [dbo].[Tbl_Shipment] S 
	LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.ID = S.ANM_ID
	LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.ID = S.TestingCHCID
	LEFT JOIN [dbo].[Tbl_AVDMaster] AM WITH (NOLOCK) ON AM.ID = S.AVDID
	LEFT JOIN [dbo].[Tbl_ILRMaster] IM WITH (NOLOCK) ON IM.ID = S.ILR_ID
	WHERE S.[ANM_ID] = @ANMID
	GROUP BY  S.[ShipmentID],S.ANM_ID,(UM.[FirstName] + ' ' + UM.[MiddleName] + ' ' + UM.[LastName])
		,CM.[CHCname],AM.[AVDName],IM.[ILRPoint],S.[DateofShipment]
	ORDER BY S.[DateofShipment] DESC  
END


