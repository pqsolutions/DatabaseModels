USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchDistrict]    Script Date: 03/25/2020 13:06:07 ******/
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
	FROM [Eduquaydb].[dbo].[Tbl_DistrictMaster] D
	LEFT JOIN [Eduquaydb].[dbo].[Tbl_StateMaster] S WITH (NOLOCK) ON S.ID = D.StateID	
	where D.ID = @ID		
End

