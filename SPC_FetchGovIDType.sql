USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchGovIDType]    Script Date: 03/26/2020 00:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (Select 1 from sys.objects where name='SPC_FetchGovIDType' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchGovIDType
End
GO

Create Procedure [dbo].[SPC_FetchGovIDType] (@ID int) 
As
Begin
	SELECT [ID]
		 ,[GovIDType]	
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [Eduquaydb].[dbo].[Tbl_Gov_IDTypeMaster]
	WHERE [ID] = @ID
End
