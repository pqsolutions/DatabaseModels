


USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_FetchMCVResults' AND [type] = 'FN')
BEGIN
	DROP FUNCTION [dbo].[FN_FetchMCVResults]
END
GO
CREATE FUNCTION [dbo].[FN_FetchMCVResults]     
(  
 @Barcode VARCHAR(250)
)   
RETURNS VARCHAR(100)          
AS      
BEGIN  
	DECLARE  
		@Result VARCHAR(MAX)
		,@MCV DECIMAL(10,1)
		,@ProcessStatus BIT
		,@ConfirmStatus INT


	IF NOT EXISTS (SELECT MCV FROM Tbl_CBCTestedDetail WHERE Barcode = @Barcode)
	BEGIN
		SET @Result = '--'
	END
	ELSE
	BEGIN

		SELECT Top 1 @MCV = MCV, @ProcessStatus = ProcessStatus,@ConfirmStatus=ConfirmationStatus 
		FROM Tbl_CBCTestedDetail WHERE Barcode = @Barcode AND ConfirmationStatus != 4 ORDER BY ID DESC

		IF ISNULL(@ProcessStatus,0) = 0 AND ISNULL(@ConfirmStatus,0) = 0
		BEGIN
			SET @Result = CONVERT(VARCHAR(10),@MCV)
		END
		ELSE
		BEGIN
			SET @Result = '--'
		END

	END
  
 RETURN  @Result  
END