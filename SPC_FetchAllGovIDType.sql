USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (Select 1 from sys.objects where name='SPC_FetchAllGovIDType' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchAllGovIDType
End
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
	FROM [dbo].[Tbl_Gov_IDTypeMaster]
	Order by [ID]
End
