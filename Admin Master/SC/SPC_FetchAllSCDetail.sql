--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllSCDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllSCDetail
END
GO
CREATE Procedure [dbo].[SPC_FetchAllSCDetail] 
AS
BEGIN
	SELECT S.[ID]
		,S.[CHCID]
		,C.[CHCname]
		,S.[PHCID]
		,P.[PHCname]
		,C.[DistrictID]
		,D.[Districtname]
		,S.[SC_gov_code]
		,S.[SCname]
		,S.[Isactive]
		,S.[Comments] 
		,S.[Createdby] 
		,S.[Updatedby]  
		,S.[HNIN_ID]
		,S.[Pincode]
		,S.[SCAddress]
		,S.[Longitude]
		,S.[Latitude]
	FROM [dbo].[Tbl_SCMaster] S
	LEFT JOIN [dbo].[Tbl_PHCMaster] P WITH (NOLOCK) ON P.ID = S.PHCID
	LEFT JOIN [dbo].[Tbl_CHCMaster] C WITH (NOLOCK) ON C.ID = S.CHCID
	LEFT JOIN [dbo].[Tbl_DistrictMaster] D WITH (NOLOCK) ON D.ID = C.DistrictID	
END

