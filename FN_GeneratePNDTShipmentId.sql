
--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_GeneratePNDTShipmentId' AND [type] = 'FN')
BEGIN
	DROP FUNCTION FN_GeneratePNDTShipmentId  
END
GO
CREATE FUNCTION [dbo].[FN_GeneratePNDTShipmentId]   
(
	@PNDTLocationId INT
	
) 
RETURNS VARCHAR(250)        
AS    
BEGIN
	DECLARE
		@PNDTCode  VARCHAR(100)
		,@Month VARCHAR(5)
		,@Year VARCHAR(5)
		,@MonthYear VARCHAR(5)
		,@LastShipmentId VARCHAR(MAX)
		,@LastShipmentId1 VARCHAR(MAX)
		,@ShipmentId VARCHAR(MAX)
		,@ReturnValue VARCHAR(200)
		,@Source CHAR(1) = 'N'
	
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
			
		SELECT @PNDTCode = PNDTCode FROM Tbl_PNDTLocationMaster WHERE ID = @PNDTLocationId
		SET @LastShipmentId =(SELECT TOP 1 GenratedShipmentID 
							FROM Tbl_PNDTShipments WITH(NOLOCK) WHERE PNDTLocationId = @PNDTLocationId  AND GenratedShipmentID LIKE '%'+@Source
							AND GenratedShipmentID LIKE @PNDTCode +'/PNDT/'+@MonthYear+'/%'   
							ORDER BY GenratedShipmentID DESC)

		SET @LastShipmentId1 =(SELECT ISNULL(LEFT(@LastShipmentId,(LEN(@LastShipmentId)-2)),''))
	
		SELECT @ShipmentId = @PNDTCode + '/PNDT/' + @MonthYear + '/' +     
			CAST(STUFF('00000',6-LEN(ISNULL(MAX(RIGHT(@LastShipmentId1,5)),0)+1),        
			LEN(ISNULL(MAX(RIGHT(@LastShipmentId1,5)),0)+1),        
			CONVERT(VARCHAR,ISNULL(MAX(RIGHT(@LastShipmentId1,5)),0)+1)) AS NVARCHAR(15))+ '/'
		FROM Tbl_PNDTShipments 
		WHERE PNDTLocationId = @PNDTLocationId AND GenratedShipmentID LIKE '%'+@Source  
			AND GenratedShipmentID LIKE @PNDTCode +'/PNDT/'+@MonthYear+'/%'  

	SET  @ReturnValue = @ShipmentId + @Source

RETURN @ReturnValue
END