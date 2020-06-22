USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddSampleCollection' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddSampleCollection
END
GO
CREATE PROCEDURE [dbo].[SPC_AddSampleCollection]
(	
	@UniqueSubjectID VARCHAR(200)
	,@BarcodeNo VARCHAR(200)
	,@SampleCollectionDate VARCHAR(100)
	,@SampleCollectionTime VARCHAR(100)
	,@Reason VARCHAR(50)
	,@CollectionFrom INT
	,@CollectedBy INT
	,@Scope_output INT OUTPUT
) AS
DECLARE
	@sCount INT
	,@tempId int
	,@Reason_Id INT
	,@SubjectId INT
BEGIN
	BEGIN TRY
		IF @UniqueSubjectID IS NOT NULL
		BEGIN
			SELECT @SubjectId = ID FROM Tbl_SubjectPrimaryDetail WHERE UniqueSubjectID = @UniqueSubjectID
			SELECT @Reason_Id = ID FROM Tbl_ConstantValues WHERE CommonName = @Reason AND comments =  'SampleCollectionType' 
			SELECT @sCount =  COUNT(ID) FROM Tbl_SampleCollection WHERE SubjectID = @SubjectID OR BarcodeNo = @BarcodeNo
			IF(@sCount <= 0)
			BEGIN
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
					  )
					  VALUES
					  (@SubjectID
					  ,@UniqueSubjectID
					  ,@BarcodeNo
					  ,CONVERT(DATE,@SampleCollectionDate,103)
					  ,CONVERT(TIME(0),@SampleCollectionTime)     
					  ,@Reason_Id
					  ,@CollectionFrom
					  ,@CollectedBy
					  ,@CollectedBy 
					  ,GETDATE()
					  ,0
					  ,0
					  ,0)
				SET @tempId = IDENT_CURRENT('Tbl_SampleCollection')
				SET @Scope_output = 1
			END
		END
		ELSE
		BEGIN 
			SET @Scope_output = -1
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