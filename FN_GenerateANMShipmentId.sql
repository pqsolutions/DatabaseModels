



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
		SELECT @SenderCode = RI_gov_code FROM Tbl_RIMaster WHERE ID = @SenderId
		SET @LastShipmentId = (SELECT TOP 1 GenratedShipmentID 
							FROM Tbl_ANMCHCShipments WITH(NOLOCK) WHERE RIID = @SenderId  AND GenratedShipmentID LIKE '%'+@Source   
							AND GenratedShipmentID LIKE @SenderCode +'/'+@MonthYear+'/%'   
							ORDER BY GenratedShipmentID DESC)
		
	END
	ELSE IF @Shipment = 'CHC - CHC'
	BEGIN
		SELECT @SenderCode = CHC_gov_code FROM Tbl_CHCMaster WHERE ID = @SenderId
		SET @LastShipmentId = (SELECT TOP 1 GenratedShipmentID 
							FROM Tbl_ANMCHCShipments WITH(NOLOCK) WHERE CollectionCHCID = @SenderId  AND GenratedShipmentID LIKE '%'+@Source   
							AND GenratedShipmentID LIKE @SenderCode +'/'+@MonthYear+'/%'   
							ORDER BY GenratedShipmentID DESC)
	END
	
	 
							
	SET @LastShipmentId1 =(SELECT ISNULL(LEFT(@LastShipmentId,(LEN(@LastShipmentId)-2)),''))
	
	IF @LastShipmentId1 != ''
	BEGIN
		SET @LastValue =  (SELECT RIGHT(@LastShipmentId1,1))
		
		IF ISNUMERIC(@LastValue) = 1
		BEGIN
			SET @NumValue = CAST(@LastValue AS INT)
			IF @NumValue > 0 AND @NumValue < 9
			BEGIN
				SET @SerialValue = CONVERT(CHAR,(@NumValue+1))
			END
			ELSE IF @NumValue = 9
			BEGIN
				SET @SerialValue = 'A'
				
			END	
		END
		ELSE
		BEGIN
			IF @LastValue != 'Z'
			BEGIN
				SET @SerialValue = (SELECT CHAR(ASCII(@LastValue)+1))
			END
		END
	END
	ELSE
	BEGIN
		SET @SerialValue = '1'
	END

	SET  @ShipmentId = @SenderCode + '/' + @MonthYear + '/' + @SerialValue + '/' + @Source

RETURN @ShipmentId
END