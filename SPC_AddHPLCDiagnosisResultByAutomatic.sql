
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
	,@CurrentIndex NVARCHAR(200)
	,@Results VARCHAR(500) = ''
	,@ResultName VARCHAR(MAX)
	,@HPLCResults VARCHAR(500)
	,@HPLCStatus CHAR(1)
	,@OthersResult VARCHAR(MAX)
	,@BarcodeNo VARCHAR(200)
	
BEGIN
	BEGIN TRY
	
		CREATE  TABLE #TempTable(code int identity(1,1), id int,hplctestresultid int)
				
		INSERT INTO #TempTable(id,hplctestresultid) (SELECT id,hplctestresultid FROM Tbl_HPLCDiagnosisResult
		WHERE IsDiagnosisComplete IS NULL AND CentralLabId = @CentralLabId  AND hplctestresultid in(SELECT ID FROM Tbl_HPLCTestResult WHERE
		DATEADD(DAY,7,HPLCTestCompletedOn) <= GETDATE()) )
		
		SELECT @TotalCount = COUNT(code) FROM #TempTable
		SET @IndexVar = 0  
			
		WHILE @Indexvar < @TotalCount  
		BEGIN
			SELECT @IndexVar = @IndexVar + 1
			SELECT @CurrentHPLCDiagnosisId = id ,@CurrentHPLCTestResultId = hplctestresultid  FROM  #TempTable WHERE code = @Indexvar
			
			SELECT @GetHPLCResultMasterId = HPLCResultMasterId, @OthersResult = OthersResult , @BarcodeNo = BarcodeNo  
			FROM Tbl_HPLCDiagnosisResult WHERE ID = @CurrentHPLCDiagnosisId
			
			SET @IsPositive = 0 
			SET @IndexVar1 = 0  
			SELECT @TotalCount1 = COUNT(value) FROM [dbo].[FN_Split](@GetHPLCResultMasterId,',')  
			WHILE @Indexvar1 < @TotalCount1  
			BEGIN
				
				SELECT @IndexVar1 = @IndexVar1 + 1
				SELECT @CurrentIndex = Value FROM  [dbo].[FN_Split](@GetHPLCResultMasterId,',') WHERE id = @Indexvar
				SELECT @ResultName = HPLCResultName FROM Tbl_HPLCResultMaster WHERE ID = CAST(@CurrentIndex AS INT)
				IF @ResultName = 'Beta Thalassemia' OR @ResultName = 'Sickle Cell Disease'
				BEGIN
					SET @IsPositive = 1
				END
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
			
			UPDATE Tbl_HPLCDiagnosisResult  SET 
				IsDiagnosisComplete = 1 
				,UpdatedBy = CreatedBy   
				,UpdatedOn = GETDATE()
				,DiagnosisCompletedThrough = 'Automatically updated Diagnosis Result, because HPLC Test completed more than 7 days'
			WHERE ID = @CurrentHPLCDiagnosisId
			
			UPDATE Tbl_HPLCTestResult SET 
					IsPositive = @IsPositive
					,HPLCResult = @HPLCResults
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
			WHERE BarcodeNo = @BarcodeNo
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