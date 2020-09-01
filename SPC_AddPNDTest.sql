


USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddPNDTest' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddPNDTest 
END
GO
CREATE PROCEDURE [dbo].[SPC_AddPNDTest] 
(
	@PrePNDTCounsellingId INT
	,@ANWSubjectId VARCHAR(250)
	,@SpouseSubjectId VARCHAR(250)
	,@CounsellorId INT
	,@ObstetricianId INT
	,@ClinicalHistory VARCHAR(MAX)
	,@Examination VARCHAR(MAX)
	,@ProcedureOfTestingId INT
	,@OthersPOT VARCHAR(MAX)
	,@PNDTComplecationsId VARCHAR(100)
	,@OthersComplecations VARCHAR(MAX)
	,@PNDTDiagnosisId INT
	,@PNDTResultId INT
	,@MotherVoided BIT
	,@MotherVitalStable BIT
	,@FoetalHeartRateDocumentScan BIT
	,@PlanForPregnencyContinue BIT
	,@IsCompletePNDT BIT
	,@CreatedBy INT
)
AS

BEGIN
	BEGIN TRY
		IF NOT EXISTS(SELECT 1 FROM Tbl_PNDTest  WHERE PrePNDTCounsellingId = @ProcedureOfTestingId)
		BEGIN
			INSERT INTO Tbl_PNDTest (
				PrePNDTCounsellingId 
				,ANWSubjectId 
				,SpouseSubjectId
				,CounsellorId
				,ObstetricianId
				,ClinicalHistory
				,Examination
				,ProcedureOfTestingId
				,OthersProcedureofTesting
				,PNDTComplecationsId
				,OthersComplecations
				,PNDTDiagnosisId
				,PNDTResultId
				,MotherVoided 
				,MotherVitalStable
				,FoetalHeartRateDocumentScan
				,PlanForPregnencyContinue
				,IsCompletePNDT
				,CreatedBy
				,CreatedOn 
				,UpdatedBy 
				,UpdatedOn
			)VALUES(
				@PrePNDTCounsellingId 
				,@ANWSubjectId 
				,@SpouseSubjectId
				,@CounsellorId
				,@ObstetricianId
				,@ClinicalHistory
				,@Examination
				,@ProcedureOfTestingId
				,@OthersPOT
				,@PNDTComplecationsId
				,@OthersComplecations
				,@PNDTDiagnosisId
				,@PNDTResultId
				,@MotherVoided 
				,@MotherVitalStable
				,@FoetalHeartRateDocumentScan
				,@PlanForPregnencyContinue
				,@IsCompletePNDT
				,@CreatedBy
				,GETDATE()
				,@CreatedBy
				,GETDATE())
				
			UPDATE Tbl_PrePNDTCounselling SET 
				IsActive = 0 
				,ReasonForClose = 'PND Test Completed'
				,UpdatedBy = @CreatedBy 
				,UpdatedOn = GETDATE()
			WHERE ID = @PrePNDTCounsellingId 
			
			SELECT 'PNDT detail submitted successfully' AS MSG
		END
		ELSE
		BEGIN
			UPDATE Tbl_PNDTest SET 
				ObstetricianId = @ObstetricianId 
				,ClinicalHistory = @ClinicalHistory
				,Examination = @Examination
				,ProcedureOfTestingId = @ProcedureOfTestingId
				,OthersProcedureofTesting = @OthersPOT
				,PNDTComplecationsId = @PNDTComplecationsId
				,OthersComplecations = @OthersComplecations
				,PNDTDiagnosisId = @PNDTDiagnosisId
				,PNDTResultId = @PNDTResultId
				,MotherVoided = @MotherVoided
				,MotherVitalStable = @MotherVitalStable
				,FoetalHeartRateDocumentScan = @FoetalHeartRateDocumentScan
				,PlanForPregnencyContinue = @PlanForPregnencyContinue
				,IsCompletePNDT = @IsCompletePNDT
				,UpdatedBy = @CreatedBy
				,UpdatedOn = GETDATE()
			WHERE PrePNDTCounsellingId = @PrePNDTCounsellingId
			
			UPDATE Tbl_PrePNDTCounselling SET 
				IsActive = 0 
				,ReasonForClose = 'PND Test Completed'
				,UpdatedBy = @CreatedBy 
				,UpdatedOn = GETDATE()
			WHERE ID = @PrePNDTCounsellingId 
			
			SELECT 'PNDT detail updated successfully' AS MSG
			
			
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