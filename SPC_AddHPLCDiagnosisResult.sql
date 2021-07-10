
--USE [Eduquaydb]
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
	,@ClinicalDiagnosisId VARCHAR(200)
	,@HPLCResultMasterId VARCHAR(200)
	,@IsNormal BIT
	,@DiagnosisSummary VARCHAR(MAX)
	,@IsConsultSeniorPathologist BIT
	,@SeniorPathologistName VARCHAR(220)
	,@SeniorPathologistRemarks VARCHAR(MAX)
	,@CreatedBy INT
	,@IsDiagnosisComplete BIT
	,@OthersResult VARCHAR(MAX)
	,@OthersDiagnosis VARCHAR(MAX)
)
AS
DECLARE 
	@SubjectId INT
	,@IsPositive BIT
	,@ResultName VARCHAR(MAX)
	,@GetId INT
	,@GetHPLCResultMasterId VARCHAR(200)
	,@GetHPLCDiagnosisId VARCHAR(200)
	,@CurrentIndex NVARCHAR(200)
	,@Indexvar INT
	,@TotalCount INT
	,@Results VARCHAR(MAX) = ''
	,@CurrentIndex1 NVARCHAR(200)
	,@Indexvar1 INT
	,@TotalCount1 INT
	,@Results1 VARCHAR(MAX) = ''
	,@ResultName1 VARCHAR(MAX)
	,@HPLCResults VARCHAR(MAX)
	,@LabDiagnosis VARCHAR(MAX)
	,@HPLCStatus CHAR(1)
	,@DiagnosisCompletedThrough VARCHAR(MAX) = NULL
	
BEGIN
	BEGIN TRY
		IF @IsDiagnosisComplete = 1
		BEGIN
			SET @DiagnosisCompletedThrough = 'Diagnosis Completed by Pathologist'
		END 
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
				,IsDiagnosisComplete
				,OthersResult
				,DiagnosisCompletedThrough
				,DiagnosisSummary
				,UpdatedBy
				,UpdatedOn
				,OthersDiagnosis
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
				,GETDATE()
				,@IsDiagnosisComplete
				,@OthersResult
				,@DiagnosisCompletedThrough
				,@DiagnosisSummary
				,@CreatedBy 
				,GETDATE()
				,@OthersDiagnosis)
			SELECT @GetId = SCOPE_IDENTITY()
				
			IF @IsDiagnosisComplete = 1
			BEGIN
				
				SET @IsPositive = 0
				IF @IsNormal = 0
				BEGIN
					SET @IsPositive = 1
				END

				SELECT @GetHPLCResultMasterId = HPLCResultMasterId FROM Tbl_HPLCDiagnosisResult WHERE ID = @GetId
				 
				SET @IndexVar = 0  
				SELECT @TotalCount = COUNT(value) FROM [dbo].[FN_Split](@GetHPLCResultMasterId,',')  
				WHILE @Indexvar < @TotalCount  
				BEGIN
					SELECT @IndexVar = @IndexVar + 1
					SELECT @CurrentIndex = Value FROM  [dbo].[FN_Split](@GetHPLCResultMasterId,',') WHERE id = @Indexvar
					SELECT @ResultName = HPLCResultName FROM Tbl_HPLCResultMaster WHERE ID = CAST(@CurrentIndex AS INT)
					IF @ResultName = 'Others'
					BEGIN
						SET @Results = @Results + @ResultName + ' ('+ @OthersResult + '))'
					END
					ELSE
					BEGIN
						SET @Results = @Results + @ResultName + ', '
					END
				END	
				SET @HPLCResults = (SELECT LEFT(@Results,LEN(@Results)-1))

				
				SELECT @GetHPLCDiagnosisId = ClinicalDiagnosisId FROM Tbl_HPLCDiagnosisResult WHERE ID = @GetId
				SET @IndexVar1 = 0  
				SELECT @TotalCount1 = COUNT(value) FROM [dbo].[FN_Split](@GetHPLCDiagnosisId,',')  
				WHILE @Indexvar1 < @TotalCount1  
				BEGIN
					SELECT @IndexVar1 = @IndexVar1 + 1
					SELECT @CurrentIndex1 = Value FROM  [dbo].[FN_Split](@GetHPLCDiagnosisId,',') WHERE id = @Indexvar1
					SELECT @ResultName1 = DiagnosisName FROM Tbl_ClinicalDiagnosisMaster WHERE ID = CAST(@CurrentIndex1 AS INT) AND Isactive = 1
					IF @ResultName1 = 'Others'
					BEGIN
						SET @Results1 = @Results1+ @ResultName1 + ' ('+ @OthersDiagnosis + '))'
					END
					ELSE
					BEGIN
						SET @Results1 = @Results1 + @ResultName1 + ', '
					END
				END	
				SET @LabDiagnosis = (SELECT LEFT(@Results1,LEN(@Results1)-1))

				
				UPDATE Tbl_HPLCTestResult SET 
					IsPositive = @IsPositive
					,HPLCResult = @HPLCResults
					,LabDiagnosis = @LabDiagnosis
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
						,UpdatedToANM = 0
				WHERE BarcodeNo = @BarcodeNo
			END
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
				,OthersResult = @OthersResult
				,IsDiagnosisComplete = @IsDiagnosisComplete
				,DiagnosisCompletedThrough = @DiagnosisCompletedThrough
				,DiagnosisSummary = @DiagnosisSummary
				,OthersDiagnosis = @OthersDiagnosis
			WHERE BarcodeNo = @BarcodeNo 
			
			SELECT @GetId = ID FROM Tbl_HPLCDiagnosisResult WHERE BarcodeNo = @BarcodeNo 
				
			IF @IsDiagnosisComplete = 1
			BEGIN
				
				SET @IsPositive = 0
				IF @IsNormal = 0
				BEGIN
					SET @IsPositive = 1
				END

				SELECT @GetHPLCResultMasterId = HPLCResultMasterId FROM Tbl_HPLCDiagnosisResult WHERE ID = @GetId
				SET @IndexVar = 0  
				SELECT @TotalCount = COUNT(value) FROM [dbo].[FN_Split](@GetHPLCResultMasterId,',')  
				WHILE @Indexvar < @TotalCount  
				BEGIN
					SELECT @IndexVar = @IndexVar + 1
					SELECT @CurrentIndex = Value FROM  [dbo].[FN_Split](@GetHPLCResultMasterId,',') WHERE id = @Indexvar
					SELECT @ResultName = HPLCResultName FROM Tbl_HPLCResultMaster WHERE ID = CAST(@CurrentIndex AS INT)
					IF @ResultName = 'Others'
					BEGIN
						SET @Results = @Results + @ResultName + ' ('+ @OthersResult + '))'
					END
					ELSE
					BEGIN
						SET @Results = @Results + @ResultName + ', '
					END
				END	
				SET @HPLCResults = (SELECT LEFT(@Results,LEN(@Results)-1))

				SELECT @GetHPLCDiagnosisId = ClinicalDiagnosisId FROM Tbl_HPLCDiagnosisResult WHERE ID = @GetId
				SET @IndexVar1 = 0  
				SELECT @TotalCount1 = COUNT(value) FROM [dbo].[FN_Split](@GetHPLCDiagnosisId,',')  
				WHILE @Indexvar1 < @TotalCount1  
				BEGIN
					SELECT @IndexVar1 = @IndexVar1 + 1
					SELECT @CurrentIndex1 = Value FROM  [dbo].[FN_Split](@GetHPLCDiagnosisId,',') WHERE id = @Indexvar1
					SELECT @ResultName1 = DiagnosisName FROM Tbl_ClinicalDiagnosisMaster WHERE ID = CAST(@CurrentIndex1 AS INT) AND Isactive = 1
					IF @ResultName1 = 'Others'
					BEGIN
						SET @Results1 = @Results1 + @ResultName1 + ' ('+ @OthersDiagnosis + '))'
					END
					ELSE
					BEGIN
						SET @Results1 = @Results1 + @ResultName1 + ', '
					END
				END	
				SET @LabDiagnosis = (SELECT LEFT(@Results1,LEN(@Results1)-1))
				
				UPDATE Tbl_HPLCTestResult SET 
					IsPositive = @IsPositive
					,HPLCResult = @HPLCResults
					,LabDiagnosis = @LabDiagnosis
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
						,UpdatedToANM = 0
				WHERE BarcodeNo = @BarcodeNo
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