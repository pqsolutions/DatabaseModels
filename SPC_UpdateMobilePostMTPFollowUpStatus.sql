USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Update the status in ANM Mobile notification Post MTP followup

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_UpdateMobilePostMTPFollowUpStatus' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_UpdateMobilePostMTPFollowUpStatus
END
GO
CREATE PROCEDURE [dbo].[SPC_UpdateMobilePostMTPFollowUpStatus]
(	
	@UniqueSubjectId VARCHAR(250)
	,@FollowUpNo INT
	,@FollowUpStatusId INT
	,@FollowUpStatusDetail VARCHAR(500)
	,@UserId INT
)
AS
DECLARE 
	@StatusName VARCHAR(250)
	,@IsActive BIT
	,@Reason VARCHAR(MAX)
	
BEGIN
	BEGIN TRY
		SELECT @StatusName = StatusName FROM Tbl_MTPFollowUpMaster WHERE ID = @FollowUpStatusId 
		IF UPPER(@StatusName) = 'EXPIRED' 
		BEGIN
			SET @IsActive = 0
			SET @Reason  = 'This Subject Expired'
		END
		ELSE
		BEGIN
			SET @IsActive = 1
			SET @Reason  = NULL
		END
		
		IF @FollowUpNo = 1 
		BEGIN
			UPDATE Tbl_MTPTest SET
					FirstFollowupStatusId = @FollowUpStatusId 
					,IsFirstFollowupCompleted = 1
					,FirstStatusUpdatedOn = GETDATE()
					,FirstFollowupStatusDetail = @FollowUpStatusDetail 
					,IsActive = @IsActive 
					,ReasonForClose = @Reason 
					,UpdatedBy = @UserId 
					,UpdatedOn = GETDATE()
					,FollowUpStatus = 0
				WHERE ANWSubjectId  = @UniqueSubjectId  
		END
		IF @FollowUpNo = 2 
		BEGIN
			UPDATE Tbl_MTPTest SET
					SecondFollowupStatusId = @FollowUpStatusId 
					,IsSecondFollowupCompleted = 1
					,SecondStatusUpdatedOn = GETDATE()
					,SecondFollowupStatusDetail = @FollowUpStatusDetail 
					,IsActive = @IsActive 
					,ReasonForClose = @Reason
					,UpdatedBy = @UserId 
					,UpdatedOn = GETDATE() 
					,FollowUpStatus = 0
			WHERE ANWSubjectId  = @UniqueSubjectId  
		END
		IF @FollowUpNo = 3 
		BEGIN
			IF UPPER(@StatusName) = 'EXPIRED' 
			BEGIN
				UPDATE Tbl_MTPTest SET
					ThirdFollowupStatusId = @FollowUpStatusId 
					,IsThirdFollowupCompleted = 1
					,ThirdStatusUpdatedOn = GETDATE()
					,ThirdFollowupStatusDetail = @FollowUpStatusDetail 
					,IsActive = 0
					,ReasonForClose = 'This Subject Expired'
					,UpdatedBy = @UserId 
					,UpdatedOn = GETDATE()
				WHERE ANWSubjectId  = @UniqueSubjectId  
			END
			ELSE
			BEGIN
				UPDATE Tbl_MTPTest SET
					ThirdFollowupStatusId = @FollowUpStatusId 
					,IsThirdFollowupCompleted = 1
					,ThirdStatusUpdatedOn = GETDATE()
					,ThirdFollowupStatusDetail = @FollowUpStatusDetail 
					,IsActive = 0
					,ReasonForClose = 'This Subject Follow up Completed'
					,UpdatedBy = @UserId 
					,UpdatedOn = GETDATE()
				WHERE ANWSubjectId  = @UniqueSubjectId  
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
