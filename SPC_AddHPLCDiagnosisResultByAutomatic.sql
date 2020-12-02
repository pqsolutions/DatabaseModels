
USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddHPLCDiagnosisResultByAutomatic' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddHPLCDiagnosisResultByAutomatic 
END
GO
CREATE PROCEDURE [dbo].[SPC_AddHPLCDiagnosisResultByAutomatic] 
(
	@CentralLabId INT
)
AS
DECLARE
	@CurrentHPLCDiagnosisId INT
	,@CurrentHPLCTestResultId INT
	,@Indexvar INT
	,@TotalCount INT
	,@IsPositive BIT
	,@Indexvar1 INT
	,@TotalCount1 INT
	,@GetHPLCResultMasterId VARCHAr(200)
	,@GetHPLCDiagnosisId VARCHAR(200)
	,@CurrentIndex NVARCHAR(200)
	,@Results VARCHAR(500) = ''
	,@ResultName VARCHAR(MAX)
	,@HPLCResults VARCHAR(500)
	,@HPLCStatus CHAR(1)
	,@OthersResult VARCHAR(MAX)
	,@BarcodeNo VARCHAR(200)
	,@IsNormal BIT
	,@LabDiagnosis VARCHAR(MAX)

	,@CurrentIndex2 NVARCHAR(200)
	,@Indexvar2 INT
	,@TotalCount2 INT
	,@Results2 VARCHAR(MAX) = ''
	,@ResultName2 VARCHAR(MAX)
	
BEGIN
	BEGIN TRY
	
		CREATE  TABLE #TempTable(code INT IDENTITY(1,1), id INT,hplctestresultid INT)
				
		INSERT INTO #TempTable(id,hplctestresultid) (SELECT id,hplctestresultid FROM Tbl_HPLCDiagnosisResult
		WHERE (IsDiagnosisComplete IS NULL OR IsDiagnosisComplete = 0) AND CentralLabId = @CentralLabId 
		AND hplctestresultid IN(SELECT ID FROM Tbl_HPLCTestResult WHERE
		DATEADD(DAY,7,HPLCTestCompletedOn) <= GETDATE()) )
		
		SELECT @TotalCount = COUNT(code) FROM #TempTable
		SET @IndexVar = 0  
			
		WHILE @Indexvar < @TotalCount  
		BEGIN
			SELECT @IndexVar = @IndexVar + 1
			SELECT @CurrentHPLCDiagnosisId = id ,@CurrentHPLCTestResultId = hplctestresultid  FROM  #TempTable WHERE code = @Indexvar
			
			SELECT @GetHPLCResultMasterId = HPLCResultMasterId, @OthersResult = OthersResult , 
			@BarcodeNo = BarcodeNo , @IsNormal = IsNormal ,  @GetHPLCDiagnosisId = ClinicalDiagnosisId
			FROM Tbl_HPLCDiagnosisResult WHERE ID = @CurrentHPLCDiagnosisId
			
			
			IF @IsNormal = 0
			BEGIN
				SET @IsPositive = 1
			END 
			ELSE
			BEGIN
				SET @IsPositive = 0 
			END
			
			SET @IndexVar1 = 0  
			SELECT @TotalCount1 = COUNT(value) FROM [dbo].[FN_Split](@GetHPLCResultMasterId,',')  
			WHILE @Indexvar1 < @TotalCount1  
			BEGIN
				
				SELECT @IndexVar1 = @IndexVar1 + 1
				SELECT @CurrentIndex = Value FROM  [dbo].[FN_Split](@GetHPLCResultMasterId,',') WHERE id = @Indexvar1
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


			SET @IndexVar2 = 0  
			SELECT @TotalCount2 = COUNT(value) FROM [dbo].[FN_Split](@GetHPLCDiagnosisId,',')  
			WHILE @Indexvar2 < @TotalCount2  
			BEGIN
				SELECT @IndexVar2 = @IndexVar2 + 1
				SELECT @CurrentIndex2 = Value FROM  [dbo].[FN_Split](@GetHPLCDiagnosisId,',') WHERE id = @Indexvar2
				SELECT @ResultName2 = DiagnosisName FROM Tbl_ClinicalDiagnosisMaster WHERE ID = CAST(@CurrentIndex2 AS INT) AND Isactive = 1
				SET @Results2 = @Results2 + @ResultName2 + ', '
			END	
			SET @LabDiagnosis = (SELECT LEFT(@Results2,LEN(@Results2)-1))

				
			UPDATE Tbl_HPLCDiagnosisResult  SET 
				IsDiagnosisComplete = 1 
				,UpdatedBy = UpdatedBy   
				,UpdatedOn = GETDATE()
				,DiagnosisCompletedThrough = 'Automatically updated Diagnosis Result, because HPLC Test completed more than 7 days'
			WHERE ID = @CurrentHPLCDiagnosisId
				
			UPDATE Tbl_HPLCTestResult SET 
					IsPositive = @IsPositive
					,HPLCResult = @HPLCResults
					,LabDiagnosis = @LabDiagnosis
					,UpdatedOn = GETDATE()
					,UpdatedToANM = NULL
					,HPLCResultUpdatedOn = GETDATE()
					,ResultUpdatedPathologistId = ResultUpdatedPathologistId  
			WHERE ID = @CurrentHPLCTestResultId
				
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
			
			SET @Results =''
			SET @Results2 =''
		END	
			
		DROP TABLE #TempTable
	
	
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