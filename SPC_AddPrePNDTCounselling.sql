

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddPrePNDTCounselling' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddPrePNDTCounselling 
END
GO
CREATE PROCEDURE [dbo].[SPC_AddPrePNDTCounselling] 
(
	@PrePNDTSchedulingId INT
	,@ANWSubjectId VARCHAR(250)
	,@SpouseSubjectId VARCHAR(250)
	,@CounsellorId INT
	,@CounsellingRemarks VARCHAR(100)
	,@AssignedObstetricianId INT
	,@IsPNDTAgreeYes BIT
	,@IsPNDTAgreeNo BIT
	,@IsPNDTAgreePending BIT
	,@SchedulePNDTDate VARCHAR(250)
	,@SchedulePNDTTime VARCHAR(100)
	--,@FileName VARCHAR(MAX)
	--,@FileData VARBINARY(MAX)
	,@CreatedBy INT
)
AS
DECLARE 
	@GetId INT
	,@ScheduleDate DATE
	,@ScheduleTime TIME(2)
	,@Active BIT
	
BEGIN
	BEGIN TRY
		
		IF ISNULL(@SchedulePNDTDate,'') = ''
		BEGIN
			SET @ScheduleDate = NULL
		END
		ELSE
		BEGIN
			SET @ScheduleDate = CONVERT(DATE,@SchedulePNDTDate,103)
		END
		IF ISNULL(@SchedulePNDTTime,'') = ''
		BEGIN
			SET @ScheduleTime = NULL
		END
		ELSE
		BEGIN
			SET @ScheduleTime = CONVERT(TIME(2),@SchedulePNDTTime,103)
		END
		
		IF NOT EXISTS(SELECT 1 FROM Tbl_PrePNDTCounselling  WHERE PrePNDTSchedulingId  = @PrePNDTSchedulingId)
		BEGIN
		
			UPDATE Tbl_PrePNDTScheduling SET 
				IsCounselled = 1
			WHERE ID = @PrePNDTSchedulingId
		
			INSERT INTO Tbl_PrePNDTCounselling (
				AssignedObstetricianId
				,PrePNDTSchedulingId
				,ANWSubjectId 
				,SpouseSubjectId 
				,CounsellorId 
				,CounsellingRemarks
				,SchedulePNDTDate
				,SchedulePNDTTime
				--,FileName
				--,FileData
				,IsPNDTAgreeYes
				,IsPNDTAgreeNo
				,IsPNDTAgreePending
				,CreatedBy 
				,CreatedOn
				,UpdatedBy
				,UpdatedOn
				,IsActive
				,UpdatedToANM
			)VALUES(
				@AssignedObstetricianId
				,@PrePNDTSchedulingId
				,@ANWSubjectId 
				,@SpouseSubjectId 
				,@CounsellorId 
				,@CounsellingRemarks
				,@ScheduleDate
				,@ScheduleTime
				--,@FileName
				--,@FileData
				,@IsPNDTAgreeYes
				,@IsPNDTAgreeNo
				,@IsPNDTAgreePending 
				,@CreatedBy 
				,GETDATE()
				,@CreatedBy 
				,GETDATE()
				,1
				,0)
				SET @GetId = (SELECT SCOPE_IDENTITY())
				
			IF @IsPNDTAgreeYes = 1
			BEGIN
				UPDATE Tbl_PrePNDTReferal SET 
					PNDTScheduleDateTime = CONVERT(DATETIME,(@SchedulePNDTDate+ ' ' +@SchedulePNDTTime),103)
					,IsNotified = 0
					,UpdatedBy = @CreatedBy
					,UpdatedOn = GETDATE()
					,IsPNDTAccept = 1
				WHERE ANWSubjectId = @ANWSubjectId
				
				SELECT CONVERT(VARCHAR,SchedulePNDTDate,103) AS SchedulePNDTDate 
					,CONVERT(VARCHAR(5),SchedulePNDTTime) AS SchedulePNDTTime
				FROM Tbl_PrePNDTCounselling 
				WHERE ID = @GetId
			END
			ELSE
			BEGIN
				UPDATE Tbl_PrePNDTReferal SET 
					UpdatedBy = @CreatedBy
					,UpdatedOn = GETDATE()
					,IsPNDTAccept = 0
					,ReasonForClose = 'Decision Pending / PNDT Not Agreed'
				WHERE ANWSubjectId = @ANWSubjectId
			
				SELECT '' AS SchedulePNDTDate, '' AS SchedulePNDTTime
			END 
		END
		ELSE
		BEGIN
			
			UPDATE  Tbl_PrePNDTCounselling SET
				AssignedObstetricianId = @AssignedObstetricianId
				,CounsellorId = @CounsellorId
				,CounsellingRemarks = @CounsellingRemarks
				,SchedulePNDTDate = @ScheduleDate
				,SchedulePNDTTime = @ScheduleTime
				--,FileName = @FileName
				--,FileData = @FileData
				,IsPNDTAgreeYes = @IsPNDTAgreeYes
				,IsPNDTAgreeNo = @IsPNDTAgreeNo
				,IsPNDTAgreePending =@IsPNDTAgreePending
				,UpdatedBy = @CreatedBy 
				,UpdatedOn = GETDATE()
				,IsActive = 1
				,UpdatedToANM = 0
			WHERE PrePNDTSchedulingId = @PrePNDTSchedulingId
			
			IF @IsPNDTAgreeYes = 1
			BEGIN
			
				UPDATE Tbl_PrePNDTReferal SET 
					PNDTScheduleDateTime = CONVERT(DATETIME,(@SchedulePNDTDate+ ' ' +@SchedulePNDTTime),103)
					,IsNotified = 0
					,UpdatedBy = @CreatedBy
					,UpdatedOn = GETDATE()
					,IsPNDTAccept = 1
				WHERE ANWSubjectId = @ANWSubjectId
			
				SELECT CONVERT(VARCHAR,SchedulePNDTDate,103) AS SchedulePNDTDate 
					,CONVERT(VARCHAR(5),SchedulePNDTTime) AS SchedulePNDTTime
				FROM Tbl_PrePNDTCounselling
				WHERE PrePNDTSchedulingId = @PrePNDTSchedulingId
			END
			ELSE
			BEGIN
				UPDATE Tbl_PrePNDTReferal SET 
					UpdatedBy = @CreatedBy
					,UpdatedOn = GETDATE()
					,IsPNDTAccept = 0
					,ReasonForClose = 'Decision Pending / PNDT Not Agreed'
				WHERE ANWSubjectId = @ANWSubjectId	
			
				SELECT '' AS SchedulePNDTDate, '' AS SchedulePNDTTime
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