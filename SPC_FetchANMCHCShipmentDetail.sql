USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Shipment Details (Log) of particular ANM user/ CHC

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchANMCHCShipmentDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchANMCHCShipmentDetail
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchANMCHCShipmentDetail] 
(
	@UserID INT
	,@ShipmentFrom VARCHAR(10)
)
AS
BEGIN

	IF @ShipmentFrom = 'ANM'
	BEGIN
		SELECT 
		   S.[ShipmentID]
		  ,(UM.[FirstName] + ' ' + UM.[MiddleName] + ' ' + UM.[LastName]) AS ANMName
		  ,CM.[CHCname] AS TestingCHC
		  ,AM.[AVDName]
		  ,IM.[ILRPoint]
		  ,CONVERT(VARCHAR,S.[DateofShipment],105) AS ShipmentDate
		  ,S.[TimeofShipment] AS ShipmentTime
		FROM [dbo].[Tbl_ANMCHCShipment] S 
		LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.ID = S.ANM_ID
		LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.ID = S.TestingCHCID
		LEFT JOIN [dbo].[Tbl_AVDMaster] AM WITH (NOLOCK) ON AM.ID = S.AVDID
		LEFT JOIN [dbo].[Tbl_ILRMaster] IM WITH (NOLOCK) ON IM.ID = S.ILR_ID
		WHERE S.[ANM_ID] = @UserID AND S.[ShipmentFrom] = @ShipmentFrom
		GROUP BY  S.[ShipmentID],(UM.[FirstName] + ' ' + UM.[MiddleName] + ' ' + UM.[LastName])
				,CM.[CHCname],AM.[AVDName],IM.[ILRPoint],S.[DateofShipment],S.[TimeofShipment]
		ORDER BY S.[DateofShipment] DESC  
	END
	ELSE IF @ShipmentFrom = 'CHC'
	BEGIN
		DECLARE @CHCID INT
		SET @CHCID = (SELECT CHCID FROM Tbl_UserMaster WHERE ID = @UserID)
		SELECT 
		   S.[ShipmentID]
		  ,(UM.[FirstName] + ' ' + UM.[MiddleName] + ' ' + UM.[LastName]) AS ANMName  -- << CHC Lab Technician Name >>
		  ,CM.[CHCname] AS TestingCHC
		  ,S.[DeliveryExecutiveName] AS [AVDName]  -- << CHC Delivery Executive Name >>
		  ,LP.[ProviderName] AS [ILRPoint] -- << CHC Logistics Sservice Provider >>
		  ,CONVERT(VARCHAR,S.[DateofShipment],105)  AS ShipmentDate
		  ,S.[TimeofShipment] AS ShipmentTime
		FROM [dbo].[Tbl_ANMCHCShipment] S 
		LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.ID = S.ANM_ID
		LEFT JOIN [dbo].[Tbl_CHCMaster] CMT WITH (NOLOCK) ON CMT.ID = S.TestingCHCID
		LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.ID = S.RIID
		LEFT JOIN [dbo].[Tbl_LogisticsProviderMaster] LP WITH (NOLOCK) ON LP.ID = S.ILR_ID
		WHERE S.[ShipmentFrom] = @ShipmentFrom AND S.RIID = @CHCID
		GROUP BY  S.[ShipmentID],(UM.[FirstName] + ' ' + UM.[MiddleName] + ' ' + UM.[LastName])
				,CM.[CHCname],S.[DeliveryExecutiveName],LP.[ProviderName] ,S.[DateofShipment],S.[TimeofShipment]
		ORDER BY S.[DateofShipment] DESC  
	
	END
END


