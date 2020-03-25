USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchPatient]    Script Date: 03/20/2020 18:38:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Procedure [dbo].[SPC_FetchPatient] (@GID int)
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

