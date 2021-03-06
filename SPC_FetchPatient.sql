USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchPatient]    Script Date: 03/20/2020 18:38:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (Select 1 from sys.objects where name='SPC_FetchPatient' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchPatient
End
GO


CREATE Procedure [dbo].[SPC_FetchPatient] (@GID int)
As
Begin
	Select 
		[ID]
		,[GID]
		,[FIRSTNAME] 
		,[LASTNAME] 
		,[CITY]  
	From [dbo].[TBL_PATIENT] where GID = @GID
End

