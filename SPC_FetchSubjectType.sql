USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



Create Procedure [dbo].[SPC_FetchSubjectType](@ID int)
As
Begin
	SELECT [ID]
		 ,[SubjectType]	
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [Eduquaydb].[dbo].[Tbl_SubjectTypeMaster]
	WHERE [ID] = @ID
End
