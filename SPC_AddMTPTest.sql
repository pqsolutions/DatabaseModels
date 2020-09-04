


USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddMTPTest' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddMTPTest 
END
GO
CREATE PROCEDURE [dbo].[SPC_AddMTPTest] 
(
	@PostPNDTCounsellingId INT
	,@ANWSubjectId VARCHAR(250)
	,@SpouseSubjectId VARCHAR(250)
	,@CounsellorId INT
	,@ObstetricianId INT
	,@ClinicalHistory VARCHAR(MAX)
	,@Examination VARCHAR(MAX)
	,@ProcedureOfTesting VARCHAR(MAX)
	,@MTPComplecationsId VARCHAR(100)
	,@DischargeConditionId INT
	,@CreatedBy INT
)
AS

BEGIN
	BEGIN TRY
		IF NOT EXISTS(SELECT 1 FROM Tbl_MTPTest  WHERE PostPNDTCounsellingId = @PostPNDTCounsellingId)
		BEGIN
			INSERT INTO Tbl_MTPTest (
				PostPNDTCounsellingId 
				,ANWSubjectId 
				,SpouseSubjectId
				,CounsellorId
				,ObstetricianId
				,ClinicalHistory
				,Examination
				,ProcedureOfTesting
				,MTPComplecationsId
				,DischargeConditionId 
				,CreatedBy
				,CreatedOn 
				,UpdatedBy 
				,UpdatedOn
			)VALUES(
				@PostPNDTCounsellingId 
				,@ANWSubjectId 
				,@SpouseSubjectId
				,@CounsellorId
				,@ObstetricianId
				,@ClinicalHistory
				,@Examination
				,@ProcedureOfTesting
				,@MTPComplecationsId
				,@DischargeConditionId
				,@CreatedBy
				,GETDATE()
				,@CreatedBy
				,GETDATE())
				
			UPDATE Tbl_PostPNDTCounselling SET 
				IsActive = 0 
				,ReasonForClose = 'MTP Test Completed'
				,UpdatedBy = @CreatedBy 
				,UpdatedOn = GETDATE()
			WHERE ID = @PostPNDTCounsellingId 
			
			SELECT 'MTP Service detail submitted successfully' AS MSG
		END
		ELSE
		BEGIN
			UPDATE Tbl_MTPTest SET 
				ObstetricianId = @ObstetricianId 
				,ClinicalHistory = @ClinicalHistory
				,Examination = @Examination
				,ProcedureOfTesting = @ProcedureOfTesting
				,MTPComplecationsId = @MTPComplecationsId
				,DischargeConditionId  = @DischargeConditionId 
				,UpdatedBy = @CreatedBy
				,UpdatedOn = GETDATE()
			WHERE PostPNDTCounsellingId = @PostPNDTCounsellingId
			
			UPDATE Tbl_PostPNDTCounselling SET 
				IsActive = 0 
				,ReasonForClose = 'MTP Test Completed'
				,UpdatedBy = @CreatedBy 
				,UpdatedOn = GETDATE()
			WHERE ID = @PostPNDTCounsellingId 
			
			SELECT 'MTP service detail updated successfully' AS MSG
			
			
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