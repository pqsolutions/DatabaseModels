--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_UpdateSSTDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_UpdateSSTDetail
END
GO
CREATE PROCEDURE [dbo].[SPC_UpdateSSTDetail] 
(
	@SSTID INT
	,@SubjectId  VARCHAR(250)
	,@Barcode VARCHAR(250)
	,@OldSST VARCHAR(250)
	,@NewSST BIT
	,@Remarks VARCHAR(MAX)
	,@UserId INT
)
AS 
	DECLARE @NewResult VARCHAR(250) = 'Positive'
		,@SSTStatus CHAR = 'P'
BEGIN
	
	IF @NewSST = 0 
	BEGIN
		SET @NewResult = 'Negative'
		SET @SSTStatus = 'N'
	END

	UPDATE Tbl_SSTestResult SET IsPositive = @NewSST, UpdatedOn = GETDATE(), UpdatedBy = @UserId WHERE UniqueSubjectID = @SubjectId AND BarcodeNo = @Barcode

	UPDATE Tbl_PositiveResultSubjectsDetail SET SSTStatus = @SSTStatus  WHERE UniqueSubjectID = @SubjectId AND BarcodeNo = @Barcode


	INSERT INTO [dbo].[Tbl_SSTUpdationDetails](
		[SSTID],
		[UniqueSubjectId],
		[Barcode],
		[OldResult],
		[NewResult],
		[Remarks],
		[CreatedBy],
		[CreatedOn])
	VALUES( 
		@SSTID
		,@SubjectId
		,@Barcode
		,@OldSST
		,@NewResult
		,@Remarks
		,@UserId
		,GETDATE())

	SELECT 'SST results updated successfully' AS MSG
END