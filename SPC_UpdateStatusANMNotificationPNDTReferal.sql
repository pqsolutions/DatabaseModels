USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Update the followup status in ANM notification PNDT Referal

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_UpdateStatusANMNotificationPNDTReferal' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_UpdateStatusANMNotificationPNDTReferal
END
GO
CREATE PROCEDURE [dbo].[SPC_UpdateStatusANMNotificationPNDTReferal]
(	
	@PNDTReferalId VARCHAR(MAX)
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
		SELECT @TotalCount = COUNT(value) FROM [dbo].[FN_Split](@PNDTReferalId,',')  
		WHILE @Indexvar < @TotalCount  
		BEGIN	
			SELECT @IndexVar = @IndexVar + 1
			SELECT @CurrentIndex = Value FROM  [dbo].[FN_Split](@PNDTReferalId,',') WHERE id = @Indexvar
			SELECT @Status = IsNotified From Tbl_PrePNDTReferal WHERE ID = @CurrentIndex
			IF ISNULL(@Status,0) = 0 
			BEGIN
				UPDATE Tbl_PrePNDTReferal SET 
					IsNotified = 1
					,NotifiedByANM = @UserId 
					,NotifiedOn = GETDATE()
				WHERE ID = @CurrentIndex
			END
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
