
CREATE Procedure [dbo].[SPC_FetchAllPatients]
As
Begin
	Select top 1
		[ID]
		,[GID]
		,[FIRSTNAME] 
		,[LASTNAME] 
		,[CITY] 
	From [dbo].[TBL_PATIENT] 
	Order by [GID]
End

GO