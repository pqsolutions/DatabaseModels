USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_GenerateANMCHCShipmentId' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_GenerateANMCHCShipmentId
END
GO
CREATE PROCEDURE [dbo].[SPC_GenerateANMCHCShipmentId]
(
	@SenderId INT
	,@Source CHAR(1)
	,@ShipmentFrom INT
)
AS
BEGIN
	DECLARE 
		@ShipmentID VARCHAR(200)
	
	SET @ShipmentID = (SELECT  [dbo].[FN_GenerateANMCHCShipmentId](@SenderId,@Source,@ShipmentFrom))
	
	SELECT 	@ShipmentID AS ShipmentID
END

