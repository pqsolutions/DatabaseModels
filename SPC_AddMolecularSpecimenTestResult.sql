

--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddMolecularSpecimenTestResult' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddMolecularSpecimenTestResult 
END
GO
CREATE PROCEDURE [dbo].[SPC_AddMolecularSpecimenTestResult] 
(
	@UniqueSubjectId VARCHAR(250)
	,@PNDTFoetusId INT
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
	@FoetusCount INT
	,@PregnancyType INT
	,@PNDTestId INT
	,@CVSSampleRefId VARCHAR(250)
	,@MSG VARCHAR(MAX)

BEGIN
	BEGIN TRY
		SELECT @PNDTestId = PNDTestId , @CVSSampleRefId = CVSSampleRefId  FROM Tbl_PNDTFoetusDetail WHERE ID = @PNDTFoetusId
		SELECT @PregnancyType = PregnancyType FROM Tbl_PNDTestNew WHERE ID = @PNDTestId 
		IF NOT EXISTS (SELECT UniqueSubjectId FROM Tbl_MolecularSpecimenTestResult WHERE PNDTFoetusId = @PNDTFoetusId)
		BEGIN
			INSERT INTO Tbl_MolecularSpecimenTestResult(
				[UniqueSubjectID]
				,[PNDTFoetusId]
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
				,[MolecularLabId])
			VALUES(
				@UniqueSubjectId 
				,@PNDTFoetusId 
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
				UPDATE Tbl_PNDTFoetusDetail SET
					[IsTestComplete] = 1
					,[Result] = @TestResult
					,[ResultUpdatedBy]  = @UserId
					,[ResultUpdatedOn] = GETDATE()
					,[UpdatedBy] = @UserId
					,[UpdatedOn] = GETDATE()
					,[ZygosityId] = @ZygosityId 
					,[Mutation1] = @Mutation1Id
					,[Mutation2] = @Mutation2Id
					,[Mutation3] = @Mutation3
					,[MolResult] = @TestResult
				WHERE ID = @PNDTFoetusId

				SELECT @FoetusCount = COUNT (*) 
				FROM Tbl_MolecularSpecimenTestResult  MSTR
				LEFT JOIN Tbl_PNDTFoetusDetail PFD WITH (NOLOCK) ON PFD.[ID] = MSTR.[PNDTFoetusId]
				WHERE PFD.[PNDTestId] = @PNDTestId AND MSTR.[IsComplete] = 1

				IF @FoetusCount = @PregnancyType
				BEGIN
					UPDATE Tbl_PNDTestNew SET 
						[IsMolTestCompleted] = 1
						,[UpdatedBy] = @UserId
						,[UpdatedOn] = GETDATE()
					WHERE ID = @PNDTestId 
				END
			END

			IF @IsComplete = 1
			BEGIN
				SET @MSG = 'CVSSampleRefID - '+@CVSSampleRefId + ' - Moleculr Test Successfully Completed'
			END
			ELSE
			BEGIN
				SET @MSG = 'CVSSampleRefID - '+@CVSSampleRefId + ' - Moleculr Test will update Later'
			END

			SELECT @MSG AS MSG

		END
		ELSE
		BEGIN
			UPDATE Tbl_MolecularSpecimenTestResult SET 
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
			WHERE PNDTFoetusId = @PNDTFoetusId AND UniqueSubjectID = @UniqueSubjectId
			
			IF @IsComplete = 1 
			BEGIN
				UPDATE Tbl_PNDTFoetusDetail SET
				[IsTestComplete] = 1
				,[Result] = @TestResult
				,[ResultUpdatedBy]  = @UserId
				,[ResultUpdatedOn] = GETDATE()
				,[UpdatedBy] = @UserId
				,[UpdatedOn] = GETDATE()
				,[ZygosityId] = @ZygosityId 
				,[Mutation1] = @Mutation1Id
				,[Mutation2] = @Mutation2Id
				,[Mutation3] = @Mutation3
				,[MolResult] = @TestResult
				WHERE ID = @PNDTFoetusId

				SELECT @FoetusCount = COUNT (*) 
				FROM Tbl_MolecularSpecimenTestResult  MSTR
				LEFT JOIN Tbl_PNDTFoetusDetail PFD WITH (NOLOCK) ON PFD.[ID] = MSTR.[PNDTFoetusId]
				WHERE PFD.[PNDTestId] = @PNDTestId AND MSTR.[IsComplete] = 1

				IF @FoetusCount = @PregnancyType
				BEGIN
					UPDATE Tbl_PNDTestNew SET 
						[IsMolTestCompleted] = 1
						,[UpdatedBy] = @UserId
						,[UpdatedOn] = GETDATE()
					WHERE ID = @PNDTestId 
				END
			END
			IF @IsComplete = 1
			BEGIN
				SET @MSG = 'CVSSampleRefID - '+@CVSSampleRefId + ' - Moleculr Test Successfully Updated'
			END
			ELSE
			BEGIN
				SET @MSG = 'CVSSampleRefID - '+@CVSSampleRefId + ' - Moleculr Test will update Later'
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