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
	UNION
	SELECT 
		SC.[UniqueSubjectID]
		,SC.[BarcodeNo]
		,CONVERT(VARCHAR,SC.[SampleCollectionDate],103) AS [SampleCollectionDate]
		,CONVERT(VARCHAR(5),SC.[SampleCollectionTime]) AS [SampleCollectionTime]
		,SC.[BarcodeDamaged]
		,SC.[SampleDamaged]
		,SC.[SampleTimeoutExpiry]
		,SC.[IsAccept]
		,SC.[Reason_Id]
		,SC.[CollectionFrom]
		,SC.[CollectedBy]
		,SC.[NotifiedStatus]
		,CASE WHEN ISNULL(SC.[NotifiedOn],'') = '' THEN '' 
			  ELSE CONVERT(VARCHAR,SC.[NotifiedOn],103)
		 END  AS  [NotifiedOn]
		,SC.[IsRecollected]
		,SC.[CreatedBy]
		,CONVERT(VARCHAR,SC.[CreatedOn],103) AS [createdOn]
		,SC.[UpdatedBy]
		,CONVERT(VARCHAR,SC.[UpdatedOn] ,103) AS [UpdatedOn]
	FROM [dbo].[Tbl_SampleCollection] SC
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[UniqueSubjectID]  = SC.[UniqueSubjectID] 
	WHERE CollectionFrom = (SELECT ID From Tbl_ConstantValues WHERE CommonName = 'CHC' AND comments = 'SampleCollectionFrom')
	AND SP.[AssignANM_ID]  = @UserId AND SC.[UpdatedToANM] = 1
END


