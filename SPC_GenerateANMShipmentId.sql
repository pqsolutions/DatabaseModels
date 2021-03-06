USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_GenerateANMShipmentId' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_GenerateANMShipmentId
END
GO
CREATE PROCEDURE [dbo].[SPC_GenerateANMShipmentId] (  
 @SenderId INT  
 ,@Source CHAR(1)  
 ,@ShipmentFrom VARCHAR(20)  
) AS BEGIN  
 DECLARE   
  @ShipmentID VARCHAR(200)  
   
 SET @ShipmentID = (SELECT  [dbo].[FN_GenerateANMShipmentId](@SenderId,@Source,@ShipmentFrom))  
   
 SELECT  @ShipmentID AS ShipmentID  
END  
  

