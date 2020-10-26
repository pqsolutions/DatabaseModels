


USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_FetchRBCResults' AND [type] = 'FN')
BEGIN
	DROP FUNCTION [dbo].[FN_FetchRBCResults]
END
GO
CREATE FUNCTION [dbo].[FN_FetchRBCResults]     
(  
 @Barcode VARCHAR(250)
)   
RETURNS VARCHAR(100)          
AS      
BEGIN  
	DECLARE  
		@Result VARCHAR(MAX)
		,@RBC DECIMAL(10,1)
		,@ProcessStatus BIT
		,@ConfirmStatus INT


	IF NOT EXISTS (SELECT RBC FROM Tbl_CBCTestedDetail WHERE Barcode = @Barcode)
	BEGIN
		SET @Result = '--'
	END
	ELSE
	BEGIN

		SELECT Top 1 @RBC =RBC, @ProcessStatus = ProcessStatus,@ConfirmStatus=ConfirmationStatus 
		FROM Tbl_CBCTestedDetail WHERE Barcode = @Barcode AND  (ConfirmationStatus IS NULL OR ConfirmationStatus = 2)  ORDER BY TestedDateTime DESC

		IF ISNULL(@ProcessStatus,0) = 0 AND ISNULL(@ConfirmStatus,0) = 0
		BEGIN
			SET @Result = ISNULL(CONVERT(VARCHAR(10),@RBC),'0.0')
		END
		ELSE
		BEGIN
			SET @Result = '--'
		END

	END
  
 RETURN  @Result  
END