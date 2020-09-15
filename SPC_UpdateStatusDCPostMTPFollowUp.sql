USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Update the followup status in DC notification Post MTP 

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_UpdateStatusDCPostMTPFollowUp' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_UpdateStatusDCPostMTPFollowUp
END
GO
CREATE PROCEDURE [dbo].[SPC_UpdateStatusDCPostMTPFollowUp]
(	
	@MTPID VARCHAR(MAX)
	,@UserId INT
)
AS
DECLARE @Indexvar INT  
DECLARE @TotalCount INT  
DECLARE @CurrentIndex NVARCHAR(200)
DECLARE @Status BIT
BEGIN
	BEGIN TRY
		SET @IndexVar = 0  
		SELECT @TotalCount = COUNT(value) FROM [dbo].[FN_Split](@MTPID,',')  
		WHILE @Indexvar < @TotalCount  
		BEGIN	
			SELECT @IndexVar = @IndexVar + 1
			SELECT @CurrentIndex = Value FROM  [dbo].[FN_Split](@MTPID,',') WHERE id = @Indexvar
			
			UPDATE Tbl_MTPTest SET 
				FollowUpStatus = 1
				,FollowUpByDC = @UserId 
				,FollowUpOn = GETDATE()
			WHERE ID = @CurrentIndex
		END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
			DECLARE @ErrorNumber INT = ERROR_NUMBER();
			DECLARE @ErrorLine INT = ERROR_LINE();
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
			DECLARE @ErrorState INT = ERROR_STATE();
			PRINT 'Actual error number: ' + CAST(@ErrorNumber AS VARCHAR(10));
			PRINT 'Actual line number: ' + CAST(@ErrorLine AS VARCHAR(10));
			RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);		
	END CATCH
	

END
