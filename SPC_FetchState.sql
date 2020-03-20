USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchState]    Script Date: 03/20/2020 10:23:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Procedure [dbo].[SPC_FetchState] (@ID int)
as
Begin
	SELECT [ID]
		 ,[Statename]
		 ,[State_gov_code]	
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [Eduquaydb].[dbo].[Masters_State] where ID = @ID		
End

