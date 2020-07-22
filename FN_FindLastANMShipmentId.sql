
USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_FindLastANMShipmentId' AND [type] = 'FN')
BEGIN
	DROP FUNCTION [dbo].[FN_FindLastANMShipmentId]
END
GO
CREATE FUNCTION [dbo].[FN_FindLastANMShipmentId]     
(  
 @ANMId INT   
)   
RETURNS VARCHAR(250)          
AS      
BEGIN  
	DECLARE @LastGeneratedShipmentId VARCHAR(250)
			,@LastShipmentId VARCHAR(250)
			,@SenderCode  VARCHAR(100)
			,@Month VARCHAR(5)
			,@Year VARCHAR(5)
			,@MonthYear VARCHAR(5)
	SELECT @SenderCode = User_gov_code FROM Tbl_UserMaster WHERE ID = @ANMId
	SET @Year = (SELECT CONVERT(VARCHAR,RIGHT(YEAR(GETDATE()),2)))
	
	IF (LEN(MONTH(GETDATE())) > 1)
	BEGIN
		SET @Month = (SELECT CONVERT(VARCHAR,MONTH(GETDATE())))
	END
	ELSE
	BEGIN
		SET @Month = (SELECT '0' + CAST(MONTH(GETDATE()) AS VARCHAR))
	END
	
	SET @MonthYear = @Month + @Year
	SET @LastGeneratedShipmentId = (SELECT TOP 1 ISNULL(GenratedShipmentID,0)
									FROM Tbl_ANMCHCShipments
									WHERE ANM_ID = @ANMId 
									AND GenratedShipmentID LIKE  '%/F' AND GenratedShipmentID LIKE @SenderCode +'/'+@MonthYear+'/%'
									ORDER BY GenratedShipmentID DESC)
	SET @LastShipmentId = @LastGeneratedShipmentId						
	IF LEN(@LastShipmentId) <= 0
	BEGIN
		SET @LastShipmentId = NULL
	END
	RETURN  @LastShipmentId  
END