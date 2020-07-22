

USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_GenerateANMCHCShipmentId' AND [type] = 'FN')
BEGIN
	DROP FUNCTION FN_GenerateANMCHCShipmentId   
END
GO
CREATE FUNCTION [dbo].[FN_GenerateANMCHCShipmentId]   
(
	@SenderId INT
	,@Source CHAR(1)
	,@ShipmentFrom INT
) 
RETURNS VARCHAR(250)        
AS    
BEGIN
	DECLARE
		@SenderCode  VARCHAR(100)
		,@Month VARCHAR(5)
		,@Year VARCHAR(5)
		,@MonthYear VARCHAR(5)
		,@LastShipmentId VARCHAR(MAX)
		,@LastShipmentId1 VARCHAR(MAX)
		,@ShipmentId VARCHAR(MAX)
		,@Serial INT
		,@SerialValue CHAR(1)
		,@Lastvalue CHAR(1)
		,@NumValue INT
		,@ReturnValue VARCHAR(200)
		,@Shipment VARCHAR(50)
		
	SELECT @Shipment = CommonName FROM Tbl_constantValues WHERE Comments = 'ShipmentFrom' AND ID = @ShipmentFrom
	
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
	
	IF @Shipment = 'ANM - CHC'
	BEGIN		
		SELECT @SenderCode = User_gov_code FROM Tbl_UserMaster WHERE ID = @SenderId
		SET @LastShipmentId =(SELECT TOP 1 GenratedShipmentID 
							FROM Tbl_ANMCHCShipments WITH(NOLOCK) WHERE ANM_ID = @SenderId  AND GenratedShipmentID LIKE '%'+@Source   
							AND GenratedShipmentID LIKE @SenderCode +'/'+@MonthYear+'/%'   
							ORDER BY GenratedShipmentID DESC)

		SET @LastShipmentId1 =(SELECT ISNULL(LEFT(@LastShipmentId,(LEN(@LastShipmentId)-2)),''))
	
		SELECT @ShipmentId = @SenderCode + '/' + @MonthYear + '/' +     
			CAST(STUFF('000',4-LEN(ISNULL(MAX(RIGHT(@LastShipmentId1,3)),0)+1),        
			LEN(ISNULL(MAX(RIGHT(@LastShipmentId1,3)),0)+1),        
			CONVERT(VARCHAR,ISNULL(MAX(RIGHT(@LastShipmentId1,3)),0)+1)) AS NVARCHAR(15))+ '/'
		FROM Tbl_ANMCHCShipments 
		WHERE ANM_ID = @SenderId AND GenratedShipmentID LIKE '%'+@Source  AND GenratedShipmentID LIKE @SenderCode +'/'+@MonthYear+'/%'  
		
	END
	ELSE IF @Shipment = 'CHC - CHC'
	BEGIN
		SELECT @SenderCode = CHC_gov_code FROM Tbl_CHCMaster WHERE ID = @SenderId
		SET @LastShipmentId =(SELECT TOP 1 GenratedShipmentID 
							FROM Tbl_ANMCHCShipments WITH(NOLOCK) WHERE CollectionCHCID = @SenderId  AND GenratedShipmentID LIKE '%'+@Source   
							AND GenratedShipmentID LIKE @SenderCode +'/'+@MonthYear+'/%'   
							ORDER BY GenratedShipmentID DESC)

		SET @LastShipmentId1 =(SELECT ISNULL(LEFT(@LastShipmentId,(LEN(@LastShipmentId)-2)),''))
	
		SELECT @ShipmentId = @SenderCode + '/' + @MonthYear + '/' +     
			CAST(STUFF('000',4-LEN(ISNULL(MAX(RIGHT(@LastShipmentId1,3)),0)+1),        
			LEN(ISNULL(MAX(RIGHT(@LastShipmentId1,3)),0)+1),        
			CONVERT(VARCHAR,ISNULL(MAX(RIGHT(@LastShipmentId1,3)),0)+1)) AS NVARCHAR(15))+ '/'
		FROM Tbl_ANMCHCShipments 
		WHERE CollectionCHCID = @SenderId AND GenratedShipmentID LIKE '%'+@Source  AND GenratedShipmentID LIKE @SenderCode +'/'+@MonthYear+'/%'  
	END

	SET  @ReturnValue = @ShipmentId + @Source

RETURN @ReturnValue
END