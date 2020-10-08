USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllStates]    Script Date: 03/26/2020 00:05:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (Select 1 from sys.objects where name='SPC_FetchAllStates' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchAllStates
End
GO
CREATE Procedure [dbo].[SPC_FetchAllStates]
As
Begin
	SELECT [ID]
		,[Statename]
		,[Shortname]
		,[State_gov_code]
		,[Isactive]
		,[Comments] 
		,[Createdby] 
		,[Updatedby]      
	FROM [dbo].[Tbl_StateMaster] WHERE ID = 1
	Order by [ID]
End
