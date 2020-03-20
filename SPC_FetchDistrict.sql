USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchDistrict]    Script Date: 03/20/2020 18:38:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Procedure [dbo].[SPC_FetchDistrict] (@ID int)
as
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
	where D.ID = @ID		
End

