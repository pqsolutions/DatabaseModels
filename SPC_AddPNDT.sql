--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddPNDT' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddPNDT  
END
GO
CREATE PROCEDURE [dbo].[SPC_AddPNDT] 
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
	,@MotherVoided BIT
	,@MotherVitalStable BIT
	,@FoetalHeartRateDocumentScan BIT
	,@UserId INT
	,@PregnancyType INT
	,@SampleRefId VARCHAR(MAX)	   --- eg: Coma seperated values Like 408010-C1,408010-C2,408010-C3
	,@FoetusName VARCHAR(MAX)      --- eg: Coma seperated values Like Baby1 of ANWName,Baby2 Of ANWName, Baby3 of ANWName
	,@CVSSampleRefId VARCHAR(MAX)  --- eg: Coma seperated values Like 124343,232323,121313
	,@PNDTLocationId INT
	,@AssistedBy VARCHAR(250)
 ---  @SampleRefId  == @FoetusName  == @CVSSampleRefId
)
AS
DECLARE @GetId INT
		,@Indexvar INT  
		,@TotalCount INT  
		,@CurrentIndexRefId NVARCHAR(MAX)
		,@CurrentIndexFoetusName NVARCHAR(MAX)
		,@CurrentIndexCVSSampleRefId NVARCHAR(MAX)
		,@BNO VARCHAR(MAX)=''
		,@ANWName VARCHAR(MAX)
		
		
BEGIN
	BEGIN TRY
		

		IF NOT EXISTS(SELECT 1 FROM Tbl_PNDTestNew  WHERE PrePNDTCounsellingId = @PrePNDTCounsellingId)
		BEGIN
			INSERT INTO Tbl_PNDTestNew (
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
				,MotherVoided 
				,MotherVitalStable
				,FoetalHeartRateDocumentScan
				,PregnancyType
				,CreatedBy
				,CreatedOn 
				,UpdatedBy 
				,UpdatedOn
				,UpdatedToANM
				,IsCompletePNDT
				,IsMolTestCompleted
				,PNDTLocationId
				,AssistedBy
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
				,@MotherVoided 
				,@MotherVitalStable
				,@FoetalHeartRateDocumentScan 
				,@PregnancyType
				,@UserId
				,GETDATE()
				,@UserId
				,GETDATE()
				,0
				,0
				,0
				,@PNDTLocationId
				,@AssistedBy)

			SET @GetId = (SELECT SCOPE_IDENTITY())
			

			IF NOT EXISTS (SELECT Value FROM [dbo].[FN_Split](@SampleRefId,',') WHERE Value  IN (SELECT SampleRefId FROM Tbl_PNDTFoetusDetail))
			BEGIN
				SET @IndexVar = 0  
				SELECT @TotalCount = COUNT(value) FROM [dbo].[FN_Split](@SampleRefID,',')  
				WHILE @Indexvar < @TotalCount  
				BEGIN
					SELECT @IndexVar = @IndexVar + 1
					SELECT @CurrentIndexRefId = Value FROM  [dbo].[FN_Split](@SampleRefId,',') WHERE id = @Indexvar
					SELECT @CurrentIndexFoetusName = Value FROM  [dbo].[FN_Split](@FoetusName,',') WHERE id = @Indexvar
					SELECT @CurrentIndexCVSSampleRefId = Value FROM  [dbo].[FN_Split](@CVSSampleRefId,',') WHERE id = @Indexvar
					IF NOT EXISTS(SELECT SampleRefId FROM Tbl_PNDTFoetusDetail WHERE SampleRefId = @CurrentIndexRefId)
					BEGIN
						INSERT INTO Tbl_PNDTFoetusDetail (
							[PNDTestId],
							[ANWSubjectId],
							[SpouseSubjectId],
							[PregnancyType],
							[SampleRefId],
							[FoetusName],
							[CVSSampleRefId],
							[CreatedBy],
							[CreatedOn], 
							[UpdatedBy], 
							[UpdatedOn],
							[IsTestComplete]
						)VALUES(
							@GetId
							,@ANWSubjectId
							,@SpouseSubjectId
							,@PregnancyType
							,@CurrentIndexRefId
							,@CurrentIndexFoetusName
							,@CurrentIndexCVSSampleRefId
							,@UserId
							,GETDATE()
							,@UserId
							,GETDATE()
							,0)
					END
				END
			END

			UPDATE Tbl_PrePNDTCounselling SET 
				IsActive = 0 
				,ReasonForClose = 'PNDT Completed'
				,UpdatedBy = @UserId 
				,UpdatedOn = GETDATE()
			WHERE ID = @PrePNDTCounsellingId 
			
			UPDATE Tbl_PrePNDTReferal SET 
				IsPNDTCompleted = 1 
				,ReasonForClose = 'PNDT Completed'
				,UpdatedBy = @UserId 
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