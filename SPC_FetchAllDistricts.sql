USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllDistricts]    Script Date: 03/26/2020 00:00:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllDistricts' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllDistricts
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllDistricts]
AS
BEGIN
	SELECT D.[ID]
		,S.[Statename]
		,D.[StateID]
		,D.[Districtname]
		,D.[District_gov_code]
		,D.[Isactive]
		,D.[Comments] 
		,D.[Createdby]
		,D.[Updatedby]      
	FROM [dbo].[Tbl_DistrictMaster] D
	LEFT JOIN [dbo].[Tbl_StateMaster] S WITH (NOLOCK) ON S.ID = D.StateID
	ORDER BY D.[ID]
END
