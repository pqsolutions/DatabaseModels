

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddMolecularTestResult' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddMolecularTestResult 
END
GO
CREATE PROCEDURE [dbo].[SPC_AddMolecularTestResult] 
(
	@UniqueSubjectId VARCHAR(250)
	,@Barcode VARCHAR(250)
	,@DiagnosisId INT
	,@ResultId INT
	,@UpdatedBy INT
	,@IsProcessed BIT
	,@Remarks VARCHAR(MAX)
)
AS
DECLARE
	@SubjectId INT
	,@MolResult VARCHAR(100)
	,@CheckDamaged BIT
	,@DId INT
	,@RId INT
BEGIN
	BEGIN TRY
		SELECT @SubjectId = ID FROM Tbl_SubjectPrimaryDetail WHERE UniqueSubjectID = @UniqueSubjectId 
		SELECT @CheckDamaged = ISNULL(IsDamagedMolecular,0) FROM Tbl_SampleCollection WHERE BarcodeNo = @Barcode 
		
		IF @IsProcessed = 0
		BEGIN
			SET @DId = 0
			SET @RId = 0
			SET @MolResult = @Remarks
		END
		ELSE
		BEGIN
			SET @DId = @DiagnosisId 
			SET @RId = @ResultId 
			SET @MolResult = (SELECT ResultName FROM Tbl_MolecularResultMaster WHERE ID = @ResultId) 
		END
		
		IF NOT EXISTS (SELECT UniqueSubjectId FROM Tbl_MolecularTestResult WHERE BarcodeNo = @Barcode)
		BEGIN
			INSERT INTO Tbl_MolecularTestResult(
				[SubjectID]
			   ,[UniqueSubjectID]
			   ,[BarcodeNo]
			   ,[ClinicalDiagnosisId]
			   ,[Result]
			   ,[UpdatedBy]
			   ,[UpdatedOn]
			   ,[IsDamaged]
			   ,[IsProcessed] 
			   ,[ReasonForClose] 
				)VALUES(
				@SubjectId 
				,@UniqueSubjectId 
				,@Barcode 
				,@DiagnosisId 
				,@ResultId  
				,@UpdatedBy 
				,GETDATE()
				,@CheckDamaged
				,@IsProcessed 
				,@Remarks)
			
			UPDATE 	Tbl_PositiveResultSubjectsDetail SET 
				MolecularResult = @MolResult 
				,MolecularUpdatedOn  = GETDATE()
			WHERE BarcodeNo = @Barcode 
			 
		END
		ELSE
		BEGIN
			UPDATE Tbl_MolecularTestResult SET 
			   [ClinicalDiagnosisId] = @DId 
			   ,[Result] = @RId 
			   ,[UpdatedBy] = @UpdatedBy 
			   ,[UpdatedOn] = GETDATE()
			   ,[IsProcessed]  = @IsProcessed 
			   ,[ReasonForClose] = @Remarks
			WHERE BarcodeNo = @Barcode 
			
			UPDATE 	Tbl_PositiveResultSubjectsDetail SET 
				MolecularResult = @MolResult 
				,MolecularUpdatedOn  = GETDATE()
			WHERE BarcodeNo = @Barcode 
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