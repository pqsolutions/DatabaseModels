


USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_FetchCBCTestedIdResults' AND [type] = 'FN')
BEGIN
	DROP FUNCTION [dbo].[FN_FetchCBCTestedIdResults]
END
GO
CREATE FUNCTION [dbo].[FN_FetchCBCTestedIdResults]     
(  
 @Barcode VARCHAR(250)
)   
RETURNS INT          
AS      
BEGIN  
	DECLARE  
		@Result VARCHAR(MAX)
		,@ID INT
		,@ProcessStatus BIT
		,@ConfirmStatus INT


	IF NOT EXISTS (SELECT ID FROM Tbl_CBCTestedDetail WHERE Barcode = @Barcode)
	BEGIN
		SET @Result = 0
	END
	ELSE
	BEGIN

		SELECT Top 1 @ID =ID, @ProcessStatus = ProcessStatus,@ConfirmStatus=ConfirmationStatus 
		FROM Tbl_CBCTestedDetail WHERE Barcode = @Barcode AND  (ConfirmationStatus IS NULL OR ConfirmationStatus = 2)  ORDER BY TestedDateTime DESC

		IF ISNULL(@ProcessStatus,0) = 0 AND ISNULL(@ConfirmStatus,0) = 0
		BEGIN
			SET @Result = @ID
		END
		ELSE
		BEGIN
			SET @Result = 0
		END

	END
  
 RETURN  @Result  
END