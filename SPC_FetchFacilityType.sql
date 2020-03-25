USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchFacilityType]    Script Date: 03/25/2020 13:41:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER Procedure [dbo].[SPC_FetchFacilityType] (@ID int)
as
Begin
	SELECT [ID]
		 ,[Facility_typename]	
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [Eduquaydb].[dbo].[Tbl_FacilityTypeMaster] where ID = @ID		
End

