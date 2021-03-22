--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddSampleCollectionNew' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddSampleCollectionNew 
END
GO
CREATE PROCEDURE [dbo].[SPC_AddSampleCollectionNew]
(	
	@UniqueSubjectID VARCHAR(200)
	,@BarcodeNo VARCHAR(200)
	,@SampleCollectionDate VARCHAR(100)
	,@SampleCollectionTime VARCHAR(100)
	,@Reason VARCHAR(50)
	,@CollectionFrom INT
	,@CollectedBy INT
	
) AS
DECLARE
	@sCount INT
	,@tempId int
	,@Reason_Id INT
	,@SubjectId INT
	,@OldBarcodeNo VARCHAR(200)
	,@NotifiedStatus BIT
	,@BNO VARCHAR(MAX)
	,@GetId INT
	
BEGIN
	BEGIN TRY
		IF @UniqueSubjectID IS NOT NULL
		BEGIN
			SELECT @SubjectId = ID FROM Tbl_SubjectPrimaryDetail WHERE UniqueSubjectID = @UniqueSubjectID
			SELECT @Reason_Id = ID FROM Tbl_ConstantValues WHERE CommonName = @Reason AND comments =  'SampleCollectionType' 
			SELECT @sCount =  COUNT(ID) FROM Tbl_SampleCollection WHERE SubjectID = @SubjectID AND BarcodeNo = @BarcodeNo
			IF(@sCount <= 0)
			BEGIN
				IF @Reason != 'First Time Collection'
				BEGIN
					IF @Reason = 'Damaged Sample'
					BEGIN
						SELECT TOP 1 @OldBarcodeNo = BarcodeNo,@NotifiedStatus = NotifiedStatus FROM Tbl_SampleCollection WHERE SampleDamaged = 1 AND UniqueSubjectID = @UniqueSubjectID ORDER BY ID DESC
					END
					ELSE IF @Reason = 'Sample Timeout'
					BEGIN
						SELECT TOP 1 @OldBarcodeNo = BarcodeNo,@NotifiedStatus = NotifiedStatus FROM Tbl_SampleCollection WHERE SampleTimeoutExpiry  = 1 AND UniqueSubjectID = @UniqueSubjectID ORDER BY ID DESC
					END
					IF @NotifiedStatus = 1
					BEGIN
						UPDATE Tbl_SampleCollection SET
						  UpdatedBy = @CollectedBy 
						  ,UpdatedOn = GETDATE()
						  ,IsRecollected = 'Y'				  
						WHERE BarcodeNo = @OldBarcodeNo
					END
					ELSE
					BEGIN
						UPDATE Tbl_SampleCollection SET
						  NotifiedStatus = 1
						  ,UpdatedBy = @CollectedBy 
						  ,UpdatedOn = GETDATE()
						  ,NotifiedOn = GETDATE()
						  ,IsRecollected = 'Y'				  
						WHERE BarcodeNo = @OldBarcodeNo
					END 
				END


				IF EXISTS(SELECT BarcodeNo FROM Tbl_SampleCollection WHERE BarcodeNo = @BarcodeNo)
				BEGIN
					
					SET  @BNo = @BarcodeNo +'-ERR'

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
					SELECT Top 1 @UniqueSubjectID
						,CONVERT(DATE,@SampleCollectionDate,103)
						,@BarcodeNo
						,@BNO
						,@CollectedBy
						,UniqueSubjectID
						,SampleCollectionDate
						,BarcodeNo
						,CollectedBy
						,'Duplicate Barcodes'
						,@CollectedBy
						,GETDATE()
						,@CollectedBy
						,GETDATE()
						,0
					FROM Tbl_SampleCollection WHERE BarcodeNo = @BarcodeNo ORDER BY ID DESC
					SET @GetId = (SELECT SCOPE_IDENTITY())
				END
				ELSE
				BEGIN
					SET  @BNo = @BarcodeNo 
					SET @GetId = 0
				END
			
				INSERT INTO Tbl_SampleCollection
					  (SubjectID
					  ,UniqueSubjectID
					  ,BarcodeNo
					  ,SampleCollectionDate
					  ,SampleCollectionTime     
					  ,Reason_Id
					  ,CollectionFrom
					  ,CollectedBy
					  ,CreatedBy
					  ,CreatedOn
					  ,BarcodeDamaged 
					  ,SampleDamaged
					  ,SampleTimeoutExpiry
					  ,IsRecollected 
					  ,NotifiedStatus
					  ,FollowUpStatus
					  ,UpdatedBy
					  ,UpdatedOn
					  )
				VALUES
					  (@SubjectID
					  ,@UniqueSubjectID
					  ,@BNo
					  ,CONVERT(DATE,@SampleCollectionDate,103)
					  ,CONVERT(TIME(0),@SampleCollectionTime)     
					  ,@Reason_Id
					  ,@CollectionFrom
					  ,@CollectedBy
					  ,@CollectedBy 
					  ,GETDATE()
					  ,0
					  ,0
					  ,0
					  ,'N'
					  ,0
					  ,0
					  ,@CollectedBy
					  ,GETDATE())

				SELECT @GetId AS GetId
				
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