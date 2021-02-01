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
	,@MotherVoided VARCHAR(10)
	,@MotherVitalStable VARCHAR(10)
	,@FoetalHeartRateDocumentScan VARCHAR(10)
	,@UserId INT
	,@PregnancyType INT
	,@SampleRefNo VARCHAR(MAX)	
	,@BabyName VARCHAR(MAX)

)
AS
DECLARE @MV BIT
		,@MVS BIT
		,@FHRDS BIT
		,@GetId INT
		,@Indexvar INT  
		,@TotalCount INT  
		,@CurrentIndexRefNo NVARCHAR(MAX)
		,@CurrentIndexBabyName NVARCHAR(MAX)
		,@BNO VARCHAR(MAX)=''
		,@ANWName VARCHAR(MAX)
		
		
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
				,@MV 
				,@MVS
				,@FHRDS 
				,@PregnancyType
				,@UserId
				,GETDATE()
				,@UserId
				,GETDATE()
				,0
				,0
				,0)

			SET @GetId = (SELECT SCOPE_IDENTITY())
			--SELECT @ANWName = (FirstName + ' ' +LastName) FROM Tbl_SubjectPrimaryDetail WHERE UniqueSubjectID = @ANWSubjectId

			IF EXISTS (SELECT Value FROM [dbo].[FN_Split](@SampleRefNo,',') WHERE Value  in (SELECT SampleRefNo FROM Tbl_PNDTFoetusDetail))
			BEGIN
				SET @IndexVar = 0  
				SELECT @TotalCount = COUNT(value) FROM [dbo].[FN_Split](@SampleRefNo,',')  
				WHILE @Indexvar < @TotalCount  
				BEGIN
					SELECT @IndexVar = @IndexVar + 1
					SELECT @CurrentIndexRefNo = Value FROM  [dbo].[FN_Split](@SampleRefNo,',') WHERE id = @Indexvar
					SELECT @CurrentIndexBabyName = Value FROM  [dbo].[FN_Split](@BabyName,',') WHERE id = @Indexvar
					IF EXISTS(SELECT SampleRefNo FROM Tbl_PNDTFoetusDetail WHERE SampleRefNo = @CurrentIndexRefNo)
					BEGIN
						INSERT INTO Tbl_PNDTFoetusDetail (
							[PNDTestId],
							[ANWSubjectId],
							[SpouseSubjectId],
							[PregnancyType],
							[SampleRefNo],
							[BabyName],
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
							,@CurrentIndexRefNo
							,@CurrentIndexBabyName
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
				,ReasonForClose = 'PND Test Completed'
				,UpdatedBy = @UserId 
				,UpdatedOn = GETDATE()
			WHERE ID = @PrePNDTCounsellingId 
			
			UPDATE Tbl_PrePNDTReferal SET 
				IsPNDTCompleted = 1 
				,ReasonForClose = 'PND Test Completed'
				,UpdatedBy = @UserId 
				,UpdatedOn = GETDATE()
			WHERE ANWSubjectId = @ANWSubjectId 
			
			SELECT 'PNDT detail submitted successfully' AS MSG

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