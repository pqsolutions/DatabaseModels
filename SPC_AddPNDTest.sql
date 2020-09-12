


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
	,@PNDTDateTime VARCHAR(100)
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
	,@MotherVoided VARCHAR(10)
	,@MotherVitalStable VARCHAR(10)
	,@FoetalHeartRateDocumentScan VARCHAR(10)
	,@PlanForPregnencyContinue VARCHAR(10)
	,@IsCompletePNDT BIT
	,@CreatedBy INT
)
AS
DECLARE @MV BIT
		,@MVS BIT
		,@FHRDS BIT
		,@PPC BIT
		
BEGIN
	BEGIN TRY
	
	IF ISNULL(@MotherVoided,'') = ''
	BEGIN 
		SET @MV = NULL
	END
	ELSE IF UPPER(@MotherVoided)= 'TRUE'
	BEGIN
		SET @MV = 1
	END
	ELSE
	BEGIN
		SET @MV = 0
	END
	----------------------------
	IF ISNULL(@MotherVitalStable,'') = ''
	BEGIN 
		SET @MVS  = NULL
	END
	ELSE IF UPPER(@MotherVitalStable)= 'TRUE'
	BEGIN
		SET @MVS = 1
	END
	ELSE
	BEGIN
		SET @MVS = 0
	END
	
	----------------------------
	IF ISNULL(@FoetalHeartRateDocumentScan,'') = ''
	BEGIN 
		SET @FHRDS   = NULL
	END
	ELSE IF UPPER(@FoetalHeartRateDocumentScan)= 'TRUE'
	BEGIN
		SET @FHRDS = 1
	END
	ELSE
	BEGIN
		SET @FHRDS = 0
	END
	-----------------------------------------
	IF ISNULL(@PlanForPregnencyContinue,'') = ''
	BEGIN 
		SET @PPC    = NULL
	END
	ELSE IF UPPER(@PlanForPregnencyContinue)= 'TRUE'
	BEGIN
		SET @PPC = 1
	END
	ELSE
	BEGIN
		SET @PPC = 0
	END
	
		IF NOT EXISTS(SELECT 1 FROM Tbl_PNDTest  WHERE PrePNDTCounsellingId = @PrePNDTCounsellingId )
		BEGIN
			INSERT INTO Tbl_PNDTest (
				PrePNDTCounsellingId 
				,ANWSubjectId 
				,SpouseSubjectId
				,PNDTDateTime
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
				,CONVERT(DATETIME,@PNDTDateTime,103)
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
				,@MV 
				,@MVS
				,@FHRDS 
				,@PPC
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
			
			UPDATE Tbl_PrePNDTReferal SET 
				IsPNDTCompleted = 1 
				,ReasonForClose = 'PND Test Completed'
				,UpdatedBy = @CreatedBy 
				,UpdatedOn = GETDATE()
			WHERE ANWSubjectId = @ANWSubjectId 
			
			SELECT 'PNDT detail submitted successfully' AS MSG
		END
		ELSE
		BEGIN
			UPDATE Tbl_PNDTest SET 
				ObstetricianId = @ObstetricianId 
				,PNDTDateTime = CONVERT(DATETIME,@PNDTDateTime,103)
				,ClinicalHistory = @ClinicalHistory
				,Examination = @Examination
				,ProcedureOfTestingId = @ProcedureOfTestingId
				,OthersProcedureofTesting = @OthersPOT
				,PNDTComplecationsId = @PNDTComplecationsId
				,OthersComplecations = @OthersComplecations
				,PNDTDiagnosisId = @PNDTDiagnosisId
				,PNDTResultId = @PNDTResultId
				,MotherVoided = @MV
				,MotherVitalStable = @MVS
				,FoetalHeartRateDocumentScan = @FHRDS 
				,PlanForPregnencyContinue = @PPC 
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
			
			UPDATE Tbl_PrePNDTReferal SET 
				IsPNDTCompleted = 1 
				,ReasonForClose = 'PND Test Completed'
				,UpdatedBy = @CreatedBy 
				,UpdatedOn = GETDATE()
			WHERE ANWSubjectId = @ANWSubjectId 
			
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