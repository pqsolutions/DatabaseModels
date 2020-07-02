USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMobileSampleDetailList' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMobileSampleDetailList
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMobileSampleDetailList]
(
	@UserId INT
)AS
BEGIN
	SELECT 
		[UniqueSubjectID]
		,[BarcodeNo]
		,CONVERT(VARCHAR,[SampleCollectionDate],103) AS [SampleCollectionDate]
		,CONVERT(VARCHAR(5),[SampleCollectionTime]) AS [SampleCollectionTime]
		,[BarcodeDamaged]
		,[SampleDamaged]
		,[SampleTimeoutExpiry]
		,[IsAccept]
		,[Reason_Id]
		,[CollectionFrom]
		,[CollectedBy]
		,[NotifiedStatus]
		,CASE WHEN ISNULL([NotifiedOn],'') = '' THEN '' 
			  ELSE CONVERT(VARCHAR,[NotifiedOn],103)
		 END  AS  [NotifiedOn]
		,[IsRecollected]
		,[CreatedBy]
		,CONVERT(VARCHAR,[CreatedOn],103) AS [createdOn]
		,[UpdatedBy]
		,CONVERT(VARCHAR,[UpdatedOn] ,103) AS [UpdatedOn]
	FROM [dbo].[Tbl_SampleCollection]
	WHERE CollectedBy = @UserId
END


