
USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_GenerateCentralLabShipmentId' AND [type] = 'FN')
BEGIN
	DROP FUNCTION FN_GenerateCentralLabShipmentId  
END
GO
CREATE FUNCTION [dbo].[FN_GenerateCentralLabShipmentId]   
(
	@CentralLabId INT
	,@Source CHAR(1)
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
		,@ReturnValue VARCHAR(200)
	
	SET @Year = (SELECT CONVERT(VARCHAR,RIGHT(YEAR(GETDATE()),2)))
	
	IF (LEN(MONTH(GETDATE())) > 1)
	BEGIN
		SET @Month = (SELECT CONVERT(VARCHAR,MONTH(GETDATE())))
	END
	ELSE
	BEGIN
		SET @Month = (SELECT '0' + CAST(MONTH(GETDATE()) AS VARCHAR))
	END
	
	SET @MonthYear = @Year + @Month 
			
		SELECT @SenderCode = CentralLabCode FROM Tbl_CentralLabMaster WHERE ID = @CentralLabId
		SET @LastShipmentId =(SELECT TOP 1 GenratedShipmentID 
							FROM Tbl_CentralLabShipments WITH(NOLOCK) WHERE CentralLabId = @CentralLabId  
							AND GenratedShipmentID LIKE '%'+@Source   
							AND GenratedShipmentID LIKE @SenderCode +'/HPLC/'+@MonthYear+'/%'   
							ORDER BY GenratedShipmentID DESC)

		SET @LastShipmentId1 =(SELECT ISNULL(LEFT(@LastShipmentId,(LEN(@LastShipmentId)-2)),''))
	
		SELECT @ShipmentId = @SenderCode + '/HPLC/' + @MonthYear + '/' +     
			CAST(STUFF('00000',6-LEN(ISNULL(MAX(RIGHT(@LastShipmentId1,5)),0)+1),        
			LEN(ISNULL(MAX(RIGHT(@LastShipmentId1,5)),0)+1),        
			CONVERT(VARCHAR,ISNULL(MAX(RIGHT(@LastShipmentId1,5)),0)+1)) AS NVARCHAR(15))+ '/'
		FROM Tbl_CentralLabShipments 
		WHERE CentralLabId = @CentralLabId  AND GenratedShipmentID LIKE '%'+@Source  
			AND GenratedShipmentID LIKE @SenderCode +'/HPLC/'+@MonthYear+'/%'  

	SET  @ReturnValue = @ShipmentId + @Source

RETURN @ReturnValue
END