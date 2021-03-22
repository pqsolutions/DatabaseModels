


--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_FetchRDWResults' AND [type] = 'FN')
BEGIN
	DROP FUNCTION [dbo].[FN_FetchRDWResults]
END
GO
CREATE FUNCTION [dbo].[FN_FetchRDWResults]     
(  
 @Barcode VARCHAR(250)
)   
RETURNS VARCHAR(100)          
AS      
BEGIN  
	DECLARE  
		@Result VARCHAR(MAX)
		,@RDW DECIMAL(10,1)
		,@ProcessStatus BIT
		,@ConfirmStatus INT


	IF NOT EXISTS (SELECT RDW FROM Tbl_CBCTestedDetail WHERE Barcode = @Barcode)
	BEGIN
		SET @Result = '--'
	END
	ELSE
	BEGIN

		SELECT Top 1 @RDW =ISNULL(RDW,0.0), @ProcessStatus = ProcessStatus,@ConfirmStatus=ConfirmationStatus 
		FROM Tbl_CBCTestedDetail WHERE Barcode = @Barcode AND  (ConfirmationStatus IS NULL OR ConfirmationStatus = 2)  ORDER BY TestedDateTime DESC

		IF ISNULL(@ProcessStatus,0) = 0 AND ISNULL(@ConfirmStatus,0) = 0
		BEGIN
			IF EXISTS (SELECT Barcode FROM Tbl_ErrorBarcodeDetail WHERE Barcode = @Barcode AND ProblemSolvedStatus = 0)
			BEGIN
				SET @Result = '--'
			END
			ELSE
			BEGIN
				SET @Result = CONVERT(VARCHAR(10),@RDW)
			END
		END
		ELSE
		BEGIN
			SET @Result = '--'
		END

	END
  
 RETURN  @Result  
END