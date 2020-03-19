alter Procedure [dbo].[SPC_FetchAllPatients]
As
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