
alter Procedure [dbo].[SPC_FetchAllPatients] (@GID int)
As
Begin
	if @GID = 0
	Begin
	Select 
		[ID]
		,[GID]
		,[FIRSTNAME] 
		,[LASTNAME] 
		,[CITY] 
	From [dbo].[TBL_PATIENT] 
	Order by [GID]
	End
	else
	if @GID > 0
	Begin
	Select 
		[ID]
		,[GID]
		,[FIRSTNAME] 
		,[LASTNAME] 
		,[CITY] 
	From [dbo].[TBL_PATIENT] where GID = @GID
	End
End

GO