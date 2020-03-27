USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



Create Procedure [dbo].[SPC_FetchAllGovIDType]
As
Begin
	SELECT [ID]
		 ,[GovIDType]	
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [Eduquaydb].[dbo].[Tbl_Gov_IDTypeMaster]
	Order by [ID]
End
