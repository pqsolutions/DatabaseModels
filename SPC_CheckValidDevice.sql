USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_CheckValidDevice' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_CheckValidDevice 
END
GO
CREATE PROCEDURE [dbo].[SPC_CheckValidDevice]
(	
	@ANMId INT
	,@DeviceId VARCHAR(MAX)
)
AS
	DECLARE @Valid BIT
			,@Msg VARCHAR(MAX)
BEGIN
	SET @Valid = 0
	SET @Msg ='Invalid device id'
	IF EXISTS (SELECT 1 FROM Tbl_ANMLogin WHERE ANMId = @ANMId AND DeviceId = @DeviceId)
	BEGIN
		SET @Valid = 1
		SET @Msg ='Valid device id'
	END
	SELECT @Valid AS Valid, @Msg as Msg
END