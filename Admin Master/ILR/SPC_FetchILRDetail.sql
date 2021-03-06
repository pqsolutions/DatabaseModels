--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchILRDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchILRDetail
END
GO
CREATE Procedure [dbo].[SPC_FetchILRDetail] (@Id INT)
AS
BEGIN
	SELECT I.[ID]
		,C.[CHCname]
		,I.[CHCID]
		,C.[DistrictID]
		,D.[Districtname]
		,I.[ILRCode]
		,I.[ILRPoint]
		,I.[Isactive]
		,I.[Comments] 
		,I.[Createdby] 
		,I.[Updatedby]  
	FROM [dbo].[Tbl_ILRMaster] I
	LEFT JOIN [dbo].[Tbl_CHCMaster] C WITH (NOLOCK) ON C.ID = I.CHCID
	LEFT JOIN [dbo].[Tbl_DistrictMaster] D WITH (NOLOCK) ON D.ID = C.DistrictID	
	WHERE I.ID = @Id
END

