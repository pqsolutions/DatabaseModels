


--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_FindTimeoutCBCResults' AND [type] = 'FN')
BEGIN
	DROP FUNCTION [dbo].[FN_FindTimeoutCBCResults]
END
GO
CREATE FUNCTION [dbo].[FN_FindTimeoutCBCResults]     
(  
 @Barcode VARCHAR(250)
 ,@SampleDateTime DATETIME
)   
RETURNS BIT          
AS      
BEGIN  
	DECLARE  
		@Result BIT
		,@ProcessStatus BIT
		,@ConfirmStatus INT
		,@TestedDateTime DATETIME
		,@CheckDate DATETIME


	IF NOT EXISTS (SELECT Barcode FROM Tbl_CBCTestedDetail WHERE Barcode = @Barcode)
	BEGIN
		SET @Result = 0
	END
	ELSE
	BEGIN

		SELECT Top 1 @TestedDateTime = TestedDateTime, @ProcessStatus = ProcessStatus,@ConfirmStatus=ConfirmationStatus 
		,@CheckDate = DATEADD(DAY,1,@SampleDateTime)
		FROM Tbl_CBCTestedDetail CD 
		WHERE Barcode = @Barcode AND  (ConfirmationStatus IS NULL OR ConfirmationStatus = 2) ORDER BY TestedDateTime DESC

		IF ISNULL(@ProcessStatus,0) = 0 AND ISNULL(@ConfirmStatus,0) = 0
		BEGIN
			IF EXISTS (SELECT Barcode FROM Tbl_ErrorBarcodeDetail WHERE Barcode = @Barcode AND ProblemSolvedStatus = 0)
			BEGIN
				SET @Result = 0
			END
			ELSE
			BEGIN
				IF @CheckDate < @TestedDateTime
				BEGIN
					SET  @Result = 1
				END
				ELSE
				BEGIN
					SET  @Result = 0
				END
			END
		END
		ELSE
		BEGIN
			SET @Result = 0
		END

	END
  
 RETURN  @Result  
END