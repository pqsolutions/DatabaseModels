--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchPHCDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchPHCDetail
END
GO
CREATE Procedure [dbo].[SPC_FetchPHCDetail] (@Id INT)
AS
BEGIN
	SELECT P.[ID]
		,C.[CHCname]
		,P.[CHCID]
		,P.[PHCname]
		,P.[PHC_gov_code]
		,C.[DistrictID]
		,D.[Districtname]
		,P.[Isactive]
		,P.[Comments] 
		,P.[Createdby] 
		,P.[Updatedby]  
		,P.[HNIN_ID]
		,P.[Pincode]
		,P.[Longitude]
		,P.[Latitude]
	FROM [dbo].[Tbl_PHCMaster] P
	LEFT JOIN [dbo].[Tbl_CHCMaster] C WITH (NOLOCK) ON C.ID = P.CHCID
	LEFT JOIN [dbo].[Tbl_DistrictMaster] D WITH (NOLOCK) ON D.ID = C.DistrictID	
	WHERE P.[ID] = @Id
END

