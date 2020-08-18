
USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddHPLCDiagnosisResult' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddHPLCDiagnosisResult 
END
GO
CREATE PROCEDURE [dbo].[SPC_AddHPLCDiagnosisResult] 
(
	@UniqueSubjectId VARCHAR(250)
	,@CentralLabId INT
	,@BarcodeNo VARCHAR(200)
	,@HPLCTestResultId INT
	,@ClinicalDiagnosisId INT
	,@HPLCResultMasterId VARCHAR(200)
	,@IsNormal BIT
	,@DiagnosisSummary VARCHAR(MAX)
	,@IsConsultSeniorPathologist BIT
	,@SeniorPathologistName VARCHAR(220)
	,@SeniorPathologistRemarks VARCHAR(MAX)
	,@CreatedBy INT
)
AS
DECLARE 
	@SubjectId INT
	,@IsPositive BIT
	,@ResultName VARCHAR(MAX)
	,@GetId INT
	,@GetHPLCResultMasterId VARCHAr(200)
	,@CurrentIndex NVARCHAR(200)
	,@Indexvar INT
	,@TotalCount INT
	,@Results VARCHAR(500) = ''
	,@HPLCResults VARCHAR(500)
	,@HPLCStatus CHAR(1)
	
BEGIN
	BEGIN TRY
		SELECT @SubjectId = ID FROM Tbl_SubjectPrimaryDetail WHERE UniqueSubjectID = @UniqueSubjectId 
		IF NOT EXISTS (SELECT 1 FROM Tbl_HPLCDiagnosisResult WHERE BarcodeNo = @BarcodeNo) 
		BEGIN
			INSERT INTO Tbl_HPLCDiagnosisResult( 
				SubjectID 
				,UniqueSubjectID
				,BarcodeNo
				,HPLCTestResultId 
				,ClinicalDiagnosisId 
				,IsNormal
				,IsConsultSeniorPathologist
				,SeniorPathologistName
				,SeniorPathologistRemarks
				,CentralLabId 
				,HPLCResultMasterId 
				,CreatedBy 
				,CreatedOn
				)VALUES(
				@SubjectID 
				,@UniqueSubjectID
				,@BarcodeNo
				,@HPLCTestResultId 
				,@ClinicalDiagnosisId 
				,@IsNormal
				,@IsConsultSeniorPathologist
				,@SeniorPathologistName
				,@SeniorPathologistRemarks
				,@CentralLabId 
				,@HPLCResultMasterId 
				,@CreatedBy 
				,GETDATE())
			SELECT @GetId = SCOPE_IDENTITY()
			
			INSERT INTO Tbl_HPLCDiagnosisResultCaseSheet(
				UniqueSubjectID
				,BarcodeNo
				,HPLCDiagnosisResultId
				,DiagnosisSummary
				,CreatedBy
				,CreatedOn
				)VALUES(
				@UniqueSubjectId 
				,@BarcodeNo 
				,@GetId 
				,@DiagnosisSummary 
				,@CreatedBy
				,GETDATE())
			
			SELECT @GetHPLCResultMasterId = HPLCResultMasterId FROM Tbl_HPLCDiagnosisResult WHERE ID = @GetId
			SET @IsPositive = 0 
			SET @IndexVar = 0  
			SELECT @TotalCount = COUNT(value) FROM [dbo].[FN_Split](@GetHPLCResultMasterId,',')  
			WHILE @Indexvar < @TotalCount  
			BEGIN
				SELECT @IndexVar = @IndexVar + 1
				SELECT @CurrentIndex = Value FROM  [dbo].[FN_Split](@GetHPLCResultMasterId,',') WHERE id = @Indexvar
				SELECT @ResultName = HPLCResultName FROM Tbl_HPLCResultMaster WHERE ID = CAST(@CurrentIndex AS INT)
				IF @ResultName = 'Beta Thalassemia' OR @ResultName = 'Sickle Cell Disease'
				BEGIN
					SET @IsPositive = 1
				END
				SET @Results = @Results + @ResultName + ', '
			END	
			SET @HPLCResults = (SELECT LEFT(@Results,LEN(@Results)-1))
			
			UPDATE Tbl_HPLCTestResult SET 
				IsPositive = @IsPositive
				,IsNormal = @IsNormal
				,HPLCResult = @HPLCResults
				,UpdatedBy = @CreatedBy 
				,UpdatedOn = GETDATE()
				,UpdatedToANM = NULL
				,HPLCResultUpdatedOn = GETDATE()
				,ResultUpdatedPathologistId = @CreatedBy 
			WHERE BarcodeNo = @BarcodeNo AND ID = @HPLCTestResultId
			
			IF @IsPositive = 0
			BEGIN
				SET @HPLCStatus = 'N'
			END
			ELSE
			BEGIN
				SET @HPLCStatus = 'P'
			END
			UPDATE Tbl_PositiveResultSubjectsDetail SET 
					HPLCStatus = @HPLCStatus
					,HPLCTestResult = @HPLCResults 
					,HPLCUpdatedOn = GETDATE()
					,IsActive = 1
			WHERE BarcodeNo = @BarcodeNo
		END
		ELSE
		BEGIN
			UPDATE Tbl_HPLCDiagnosisResult SET
				ClinicalDiagnosisId = @ClinicalDiagnosisId 
				,IsNormal = @IsNormal 
				,IsConsultSeniorPathologist = @IsConsultSeniorPathologist 
				,SeniorPathologistName = @SeniorPathologistName 
				,SeniorPathologistRemarks = @SeniorPathologistRemarks 
				,HPLCResultMasterId = @HPLCResultMasterId
				,UpdatedBy = @CreatedBy 
				,UpdatedOn = GETDATE()
			WHERE BarcodeNo = @BarcodeNo 
			
			SELECT @GetId = ID FROM Tbl_HPLCDiagnosisResult WHERE BarcodeNo = @BarcodeNo 
			
			INSERT INTO Tbl_HPLCDiagnosisResultCaseSheet(
				UniqueSubjectID
				,BarcodeNo
				,HPLCDiagnosisResultId
				,DiagnosisSummary
				,CreatedBy
				,CreatedOn
				)VALUES(
				@UniqueSubjectId 
				,@BarcodeNo 
				,@GetId 
				,@DiagnosisSummary 
				,@CreatedBy
				,GETDATE())
				
			SELECT @GetHPLCResultMasterId = HPLCResultMasterId FROM Tbl_HPLCDiagnosisResult WHERE ID = @GetId
			SET @IsPositive = 0 
			SET @IndexVar = 0  
			SELECT @TotalCount = COUNT(value) FROM [dbo].[FN_Split](@GetHPLCResultMasterId,',')  
			WHILE @Indexvar < @TotalCount  
			BEGIN
				SELECT @IndexVar = @IndexVar + 1
				SELECT @CurrentIndex = Value FROM  [dbo].[FN_Split](@GetHPLCResultMasterId,',') WHERE id = @Indexvar
				SELECT @ResultName = HPLCResultName FROM Tbl_HPLCResultMaster WHERE ID = CAST(@CurrentIndex AS INT)
				IF @ResultName = 'Beta Thalassemia' OR @ResultName = 'Sickle Cell Disease'
				BEGIN
					SET @IsPositive = 1
				END
				SET @Results = @Results + @ResultName + ', '
			END	
			SET @HPLCResults = (SELECT LEFT(@Results,LEN(@Results)-1))
			
			UPDATE Tbl_HPLCTestResult SET 
				IsPositive = @IsPositive
				,IsNormal = @IsNormal
				,HPLCResult = @HPLCResults
				,UpdatedBy = @CreatedBy 
				,UpdatedOn = GETDATE()
				,UpdatedToANM = NULL
				,HPLCResultUpdatedOn = GETDATE()
				,ResultUpdatedPathologistId = @CreatedBy 
			WHERE BarcodeNo = @BarcodeNo AND ID = @HPLCTestResultId
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