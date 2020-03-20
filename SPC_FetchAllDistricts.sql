USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllDistricts]    Script Date: 03/20/2020 18:37:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Procedure [dbo].[SPC_FetchAllDistricts]
As
Begin
	SELECT D.[ID]
		,S.[Statename]
		,D.[StateID]
		,D.[Districtname]
		,D.[District_gov_code]
		,D.[Isactive]
		,D.[Comments] 
		,D.[Createdby]
		,D.[Updatedby]      
	FROM [Eduquaydb].[dbo].[Masters_District] D
	LEFT JOIN [Eduquaydb].[dbo].[Masters_State] S WITH (NOLOCK) ON S.ID = D.StateID
	Order by D.[ID]
End
