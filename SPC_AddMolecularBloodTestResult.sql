

--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddMolecularBloodTestResult' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddMolecularBloodTestResult 
END
GO
CREATE PROCEDURE [dbo].[SPC_AddMolecularBloodTestResult] 
(
	@UniqueSubjectId VARCHAR(250)
	,@Barcode VARCHAR(250)
	,@ZygosityId INT
	,@Mutation1Id INT
	,@Mutation2Id INT
	,@Mutation3 VARCHAR(MAX)
	,@TestResult VARCHAR(MAX) 
	,@IsDamaged BIT
	,@IsProcessed BIT
	,@IsComplete BIT
	,@ReasonForClose VARCHAR(MAX)
	,@TestDate VARCHAR(250)
	,@UserId INT
	,@MolecularLabId INT 
)
AS
DECLARE 
	@MSG VARCHAR(MAX)
BEGIN
	BEGIN TRY
		
		IF NOT EXISTS (SELECT UniqueSubjectId FROM Tbl_MolecularBloodTestResult WHERE BarcodeNo = @Barcode)
		BEGIN
			INSERT INTO Tbl_MolecularBloodTestResult(
				[UniqueSubjectID]
				,[BarcodeNo]
				,[ZygosityId]
				,[Mutation1Id]
				,[Mutation2Id]
				,[Mutation3]
				,[TestResult]
				,[ReasonForClose]
				,[TestDate]
				,[CreatedBy]
				,[CreatedOn]
				,[UpdatedBy]
				,[UpdatedOn]
				,[IsDamaged]
				,[IsProcessed] 
				,[IsComplete]
				,[MolecularLabId]
			)VALUES(
				@UniqueSubjectId 
				,@Barcode 
				,@ZygosityId 
				,@Mutation1Id
				,@Mutation2Id
				,@Mutation3
				,@TestResult
				,@ReasonForClose
				,CONVERT(DATE,@TestDate,103)
				,@UserId
				,GETDATE()
				,@UserId 
				,GETDATE()
				,@IsDamaged
				,@IsProcessed 
				,@IsComplete
				,@MolecularLabId)
			
		

			IF @IsComplete = 1
			BEGIN
				UPDATE 	Tbl_PositiveResultSubjectsDetail SET 
					MolecularResult = @TestResult 
					,MolecularUpdatedOn  = GETDATE()
				WHERE BarcodeNo = @Barcode 

				SET @MSG = (@Barcode + ' - Molecular Test Result Updated Successfully')
			END
			ELSE
			BEGIN
				SET @MSG = ('Molecular Test Result for '+@Barcode+' to be updated later')  

			END
			SELECT @MSG AS MSG
			 
		END
		ELSE
		BEGIN
			UPDATE Tbl_MolecularBloodTestResult SET 
			   [ZygosityId] = @ZygosityId 
			   ,[Mutation1Id] = @Mutation1Id
			   ,[Mutation2Id] = @Mutation2Id
			   ,[Mutation3] = @Mutation3
			   ,[TestResult] = @TestResult
			   ,[UpdatedBy] = @UserId 
			   ,[UpdatedOn] = GETDATE()
			   ,[ReasonForClose] = @ReasonForClose
			   ,[IsDamaged] = @IsDamaged
			   ,[IsProcessed] = @IsProcessed
			   ,[IsComplete] = @IsComplete
			WHERE BarcodeNo = @Barcode AND UniqueSubjectID = @UniqueSubjectId
			
			UPDATE 	Tbl_PositiveResultSubjectsDetail SET 
				MolecularResult = @TestResult 
				,MolecularUpdatedOn  = GETDATE()
			WHERE BarcodeNo = @Barcode 

			IF @IsComplete = 1
			BEGIN
				SET @MSG = (@Barcode + ' - Molecular Test Result Updated Successfully')
			END
			ELSE
			BEGIN
				SET @MSG = ('Molecular Test Result for '+@Barcode+' to be updated later')  
			END
			SELECT @MSG AS MSG
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