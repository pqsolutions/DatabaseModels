--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_UpdateErrorBarcodeDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_UpdateErrorBarcodeDetail
END
GO
CREATE PROCEDURE [dbo].[SPC_UpdateErrorBarcodeDetail] 
(
	@OldBarcode VARCHAR(250)
	,@NewBarcode  VARCHAR(250)
	,@UserId INT
)
AS 
DECLARE @SubjectId VARCHAR(MAX), @ExistSubjectId VARCHAR(MAX),  @ANMID INT, @ExistANMID INT, @SampleCollectionDate DATETIME, @ExistSampleCollectionDate DATETIME,
	@BNo VARCHAr(250),@ExistCollectedBy INT, @CollectedBy INT,
	@Indexvar INT, @TotalCount INT, @CurrOldBc VARCHAR(250), @CurrNewBc VARCHAR(250),@OldBCSubString VARCHAR(50)
	,@RevisedExistCheck INT = 0, @BarcodeUpdateCode VARCHAR(50) = '', @GetId INT, @GetId1 INT

BEGIN

	SET @IndexVar = 0  
	SELECT @TotalCount = COUNT(VALUE) FROM [dbo].[FN_Split](@OldBarcode,',')  
	WHILE @Indexvar < @TotalCount  
	BEGIN
		SELECT @IndexVar = @IndexVar + 1
		SELECT @CurrOldBc = VALUE FROM  [dbo].[FN_Split](@OldBarcode,',') WHERE id = @Indexvar
		SELECT TOP 1 @SubjectId = UniqueSubjectId FROM Tbl_SampleCollection WHERE BarcodeNo = @CurrOldBc ORDER BY ID DESC
		SELECT TOP 1 @CollectedBy = CollectedBy FROM Tbl_SampleCollection WHERE BarcodeNo = @CurrOldBc ORDER BY ID DESC
		SELECT @SampleCollectionDate = SampleCollectionDate FROM Tbl_SampleCollection WHERE UniqueSubjectID = @SubjectId

		SET @OldBCSubString = (SELECT RIGHT(@CurrOldBc, 3))
		IF @OldBCSubString = 'ERR'
		BEGIN
			UPDATE Tbl_ErrorBarcodeDetail SET  ProblemSolvedOn = GETDATE() , ProblemSolvedStatus = 1 WHERE AlternateBarcode = @CurrOldBc AND UniqueSubjectId = @SubjectId
		END


		SELECT @ANMId = AssignANM_Id FROM Tbl_SubjectPrimaryDetail WHERE UniqueSubjectID = @SubjectId
		SELECT @CurrNewBc = VALUE FROM  [dbo].[FN_Split](@NewBarcode,',') WHERE id = @Indexvar

		IF EXISTS(SELECT ID FROM Tbl_SampleCollection WHERE BarcodeNo = @CurrNewBc)
		BEGIN
			SET @RevisedExistCheck = 1
			SELECT TOP 1 @ExistSubjectId = UniqueSubjectId FROM Tbl_SampleCollection WHERE BarcodeNo = @CurrNewBc ORDER BY ID DESC
			SELECT @ExistANMID = AssignANM_Id FROM Tbl_SubjectPrimaryDetail WHERE UniqueSubjectID = @ExistSubjectId

			UPDATE Tbl_SampleCollection SET BarcodeNo = (BarcodeNo+'-ERR'), UpdatedOn = GETDATE(), SampleTimeoutExpiry=0 WHERE BarcodeNo = @CurrNewBc AND UniqueSubjectId = @ExistSubjectId 

			SELECT TOP 1 @BNo = BarcodeNo FROM Tbl_SampleCollection WHERE UniqueSubjectId = @ExistSubjectId ORDER BY ID DESC

			INSERT INTO [Tbl_BarcodeUpdationDetails](
				[UniqueSubjectId],
				[ExistBarcodeNo],
				[NewBarcodeNo],
				[CreatedBy],
				[CreatedOn])
				VALUES( 
				@ExistSubjectId
				,@CurrNewBc
				,@BNo
				,@UserId
				,GETDATE())
			SET @GetId = (SELECT SCOPE_IDENTITY())
			SET @BarcodeUpdateCode = @BarcodeUpdateCode + CONVERT(VARCHAR(10),@GetId) +','
			
			SELECT @ExistSampleCollectionDate = SampleCollectionDate FROM Tbl_SampleCollection WHERE UniqueSubjectID = @ExistSubjectId
			SELECT @ExistCollectedBy = CollectedBy FROM Tbl_SampleCollection WHERE UniqueSubjectID = @ExistSubjectId

			INSERT INTO Tbl_ErrorBarcodeDetail (
						[UniqueSubjectId],
						[SampleCollectionDate],
						[Barcode],
						[AlternateBarcode],
						[ANMId],
						[ExistUniqueSubjectId],
						[ExistSampleCollectionDate],
						[ExistBarcode],
						[ExistANMId],
						[Remarks],
						[CreatedBy],
						[CreatedOn],
						[UpdatedBy],
						[UpdatedOn],
						[ProblemSolvedStatus])
					VALUES(
						@ExistSubjectId
						,@ExistSampleCollectionDate
						,@CurrNewBc
						,@BNO
						,@ExistCollectedBy
						,@SubjectId
						,@SampleCollectionDate
						,@CurrNewBc
						,@CollectedBy
						,'Duplicate Barcodes'
						,@UserId
						,GETDATE()
						,@UserId
						,GETDATE()
						,0)

			IF EXISTS(SELECT ID FROM Tbl_ANMCHCShipmentsDetail WHERE BarcodeNo = @CurrNewBc AND UniqueSubjectId = @ExistSubjectId)
			BEGIN
				UPDATE Tbl_ANMCHCShipmentsDetail SET BarcodeNo = ('ERR-' +@CurrNewBc) WHERE BarcodeNo = @CurrNewBc AND UniqueSubjectId = @ExistSubjectId 
			END
		
			IF EXISTS(SELECT ID FROM Tbl_CBCTestResult WHERE BarcodeNo = @CurrNewBc)
			BEGIN
				UPDATE Tbl_CBCTestResult SET UniqueSubjectId = @SubjectId  WHERE BarcodeNo = @CurrNewBc 
			END

			IF EXISTS(SELECT ID FROM Tbl_SSTestResult WHERE BarcodeNo = @CurrNewBc)
			BEGIN
				UPDATE Tbl_SSTestResult SET UniqueSubjectId = @SubjectId WHERE BarcodeNo = @CurrNewBc 
			END

			IF EXISTS(SELECT ID FROM Tbl_PositiveResultSubjectsDetail WHERE BarcodeNo = @CurrNewBc AND UniqueSubjectId = @ExistSubjectId)
			BEGIN
				UPDATE Tbl_PositiveResultSubjectsDetail SET UniqueSubjectId = @SubjectId  WHERE BarcodeNo = @CurrNewBc AND UniqueSubjectId = @ExistSubjectId
			END

			IF EXISTS(SELECT ID FROM Tbl_CHCShipmentsDetail WHERE BarcodeNo = @CurrNewBc)
			BEGIN
				UPDATE Tbl_CHCShipmentsDetail SET UniqueSubjectId = @SubjectId WHERE BarcodeNo = @CurrNewBc
			END

			IF EXISTS(SELECT ID FROM Tbl_HPLCTestResult WHERE BarcodeNo = @CurrNewBc)
			BEGIN
				UPDATE Tbl_HPLCTestResult SET UniqueSubjectId = @SubjectId,  UpdatedOn = GETDATE()  WHERE BarcodeNo = @CurrNewBc 
			END

			IF EXISTS(SELECT ID FROM Tbl_HPLCDiagnosisResult WHERE BarcodeNo = @CurrNewBc)
			BEGIN
				UPDATE Tbl_HPLCDiagnosisResult SET UniqueSubjectId = @SubjectId,  UpdatedOn = GETDATE()  WHERE BarcodeNo = @CurrNewBc 
			END
		END
	
		UPDATE Tbl_SampleCollection SET BarcodeNo = (@CurrNewBc),  UpdatedOn = GETDATE(), SampleTimeoutExpiry=0 WHERE BarcodeNo = @CurrOldBc AND UniqueSubjectId = @SubjectId 

		INSERT INTO [Tbl_BarcodeUpdationDetails](
				[UniqueSubjectId],
				[ExistBarcodeNo],
				[NewBarcodeNo],
				[CreatedBy],
				[CreatedOn])
			VALUES( 
				@SubjectId
				,@CurrOldBc
				,@CurrNewBc
				,@UserId
				,GETDATE())

			SET @GetId1 = (SELECT SCOPE_IDENTITY())
			SET @BarcodeUpdateCode = @BarcodeUpdateCode + CONVERT(VARCHAR(10),@GetId1) +','
			SET @BarcodeUpdateCode =  LEFT(@BarcodeUpdateCode, LEN(@BarcodeUpdateCode) - 1)

		UPDATE Tbl_ANMCHCShipmentsDetail SET BarcodeNo = (@CurrNewBc) WHERE BarcodeNo = @CurrOldBc AND UniqueSubjectId = @SubjectId 

	END

	SELECT 'Barcode details updated successfully' AS MSG, @RevisedExistCheck AS RevisedExistCheck, @BarcodeUpdateCode AS BarcodeUpdateCode
END

