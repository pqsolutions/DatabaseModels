

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddPostPNDTCounselling' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddPostPNDTCounselling 
END
GO
CREATE PROCEDURE [dbo].[SPC_AddPostPNDTCounselling] 
(
	@PostPNDTSchedulingId INT
	,@ANWSubjectId VARCHAR(250)
	,@SpouseSubjectId VARCHAR(250)
	,@CounsellorId INT
	,@CounsellingRemarks VARCHAR(100)
	,@AssignedObstetricianId INT
	,@IsMTPAgreeYes BIT
	,@IsMTPAgreeNo BIT
	,@IsMTPAgreePending BIT
	,@ScheduleMTPDate VARCHAR(250)
	,@ScheduleMTPTime VARCHAR(100)
	--,@FileName VARCHAR(MAX)
	--,@FileData VARBINARY(MAX
	,@IsFoetalDisease BIT
	,@CreatedBy INT
)
AS
DECLARE 
	@GetId INT
	,@ScheduleDate DATE
	,@ScheduleTime TIME(2)
	,@Active BIT
	,@ReasonForClose VARCHAR(MAX)
	
	
BEGIN
	BEGIN TRY
		
		IF ISNULL(@ScheduleMTPDate,'') = ''
		BEGIN
			SET @ScheduleDate = NULL
		END
		ELSE
		BEGIN
			SET @ScheduleDate = CONVERT(DATE,@ScheduleMTPDate,103)
		END
		IF ISNULL(@ScheduleMTPTime,'') = ''
		BEGIN
			SET @ScheduleTime = NULL
		END
		ELSE
		BEGIN
			SET @ScheduleTime = CONVERT(TIME(2),@ScheduleMTPTime,103)
		END
		IF @IsFoetalDisease = 1 
		BEGIN
			SET @Active = 1
			SET @ReasonForClose = ''
		END
		ELSE IF @IsFoetalDisease = 0
		BEGIN 
			SET @Active = 0
			SET @ReasonForClose = 'It is foetal disease not positive, So no need send MTP'
		END 
		
		IF NOT EXISTS(SELECT 1 FROM Tbl_PostPNDTCounselling  WHERE PostPNDTSchedulingId  = @PostPNDTSchedulingId)
		BEGIN
						
			UPDATE Tbl_PostPNDTScheduling SET 
				IsCounselled = 1
			WHERE ID = @PostPNDTSchedulingId
		
			INSERT INTO Tbl_PostPNDTCounselling (
				AssignedObstetricianId
				,PostPNDTSchedulingId
				,ANWSubjectId 
				,SpouseSubjectId 
				,CounsellorId 
				,CounsellingRemarks
				,ScheduleMTPDate
				,ScheduleMTPTime
				--,FileName
				--,FileData
				,IsMTPTestdAgreedYes
				,IsMTPTestdAgreedNo
				,IsMTPTestdAgreedPending
				,CreatedBy 
				,CreatedOn
				,UpdatedBy
				,UpdatedOn
				,IsActive
				,ReasonForClose
				,IsFoetalDisease
				,UpdatedToANM
			)VALUES(
				@AssignedObstetricianId
				,@PostPNDTSchedulingId
				,@ANWSubjectId 
				,@SpouseSubjectId 
				,@CounsellorId 
				,@CounsellingRemarks
				,@ScheduleDate
				,@ScheduleTime
				--,@FileName
				--,@FileData
				,@IsMTPAgreeYes
				,@IsMTPAgreeNo
				,@IsMTPAgreePending 
				,@CreatedBy 
				,GETDATE()
				,@CreatedBy 
				,GETDATE()
				,@Active
				,@ReasonForClose 
				,@IsFoetalDisease
				,0)
				
			SET @GetId = (SELECT SCOPE_IDENTITY())
				
			IF @IsMTPAgreeYes = 1
			BEGIN
				UPDATE Tbl_MTPReferal SET 
					MTPScheduleDateTime = CONVERT(DATETIME,(@ScheduleMTPDate+ ' ' +@ScheduleMTPTime),103)
					,IsNotified = 0
					,UpdatedBy = @CreatedBy
					,UpdatedOn = GETDATE()
					,IsMTPAccept = 1
				WHERE ANWSubjectId = @ANWSubjectId	
			
				SELECT CONVERT(VARCHAR,ScheduleMTPDate,103) AS ScheduleMTPDate 
					,CONVERT(VARCHAR(5),ScheduleMTPTime) AS ScheduleMTPTime
				FROM Tbl_PostPNDTCounselling 
				WHERE ID = @GetId
			END
			ELSE
			BEGIN
				UPDATE Tbl_MTPReferal SET 
					UpdatedBy = @CreatedBy
					,UpdatedOn = GETDATE()
					,IsMTPAccept = 0
					,ReasonForClose = 'Decision Pending / MTP service not agreed'
				WHERE ANWSubjectId = @ANWSubjectId
				SELECT '' AS ScheduleMTPDate, '' AS ScheduleMTPTime
			END 
		END
		ELSE
		BEGIN
		
			UPDATE  Tbl_PostPNDTCounselling SET
				AssignedObstetricianId = @AssignedObstetricianId
				,CounsellorId = @CounsellorId
				,CounsellingRemarks = @CounsellingRemarks
				,ScheduleMTPDate = @ScheduleDate
				,ScheduleMTPTime = @ScheduleTime
				--,FileName = @FileName
				--,FileData = @FileData
				,IsMTPTestdAgreedYes = @IsMTPAgreeYes
				,IsMTPTestdAgreedNo = @IsMTPAgreeNo
				,IsMTPTestdAgreedPending =@IsMTPAgreePending
				,UpdatedBy = @CreatedBy 
				,UpdatedOn = GETDATE()
				,IsActive = @Active
				,ReasonForClose = @ReasonForClose
				,UpdatedToANM = 0 
			WHERE PostPNDTSchedulingId = @PostPNDTSchedulingId
			
			IF @IsMTPAgreeYes = 1
			BEGIN
				UPDATE Tbl_MTPReferal SET 
					MTPScheduleDateTime = CONVERT(DATETIME,(@ScheduleMTPDate+ ' ' +@ScheduleMTPTime),103)
					,IsNotified = 0
					,UpdatedBy = @CreatedBy
					,UpdatedOn = GETDATE()
					,IsMTPAccept = 1
				WHERE ANWSubjectId = @ANWSubjectId
			
				SELECT CONVERT(VARCHAR,ScheduleMTPDate,103) AS ScheduleMTPDate 
					,CONVERT(VARCHAR(5),ScheduleMTPTime) AS ScheduleMTPTime
				FROM Tbl_PostPNDTCounselling
				WHERE PostPNDTSchedulingId = @PostPNDTSchedulingId
			END
			ELSE
			BEGIN
				UPDATE Tbl_MTPReferal SET 
					UpdatedBy = @CreatedBy
					,UpdatedOn = GETDATE()
					,IsMTPAccept = 0
					,ReasonForClose = 'Decision Pending / MTP service not agreed'
				WHERE ANWSubjectId = @ANWSubjectId
				
				SELECT '' AS ScheduleMTPDate, '' AS ScheduleMTPTime
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