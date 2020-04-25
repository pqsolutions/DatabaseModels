
USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (Select 1 from sys.objects where name='FN_GenerateUniqueSubjectId' and [type] = 'FN')
Begin
	Drop function FN_GenerateUniqueSubjectId
End
GO
Create function [dbo].[FN_GenerateUniqueSubjectId]   
(
	@ANMID int
	,@Source char(1)
) 
Returns varchar(200)        
As    
Begin
	Declare
		@ANMCode  varchar(100)
		,@UniqueSubjectId varchar(MAX)
		,@StateID int
		,@StateShortCode varchar(10)
		,@LastUniqueId varchar(MAX)
		,@LastUniqueId1 varchar(MAX)
		,@ReturnValue varchar(200)
		
		Select @ANMCode = User_gov_code
		   ,@StateID = StateID		
		   from Tbl_UserMaster where ID = @ANMID
		   
		Select @StateShortCode = Shortname from Tbl_StateMaster where ID = @StateID
	
		Set @LastUniqueId = (Select top 1 UniqueSubjectID 
			from Tbl_SubjectPrimaryDetail with(nolock) where AssignANM_ID = @ANMID  and  UniqueSubjectID like '%'+@Source      
			order by UniqueSubjectID desc)
			
		set @LastUniqueId1 =(select ISNULL(LEFT(@LastUniqueId,(len(@LastUniqueId)-2)),''))
	
		select @UniqueSubjectId = @StateShortCode + '/' + @ANMCode + '/' +     
			cast(STUFF('00000',6-LEN(ISNULL(MAX(RIGHT(@LastUniqueId1,5)),0)+1),        
			LEN(ISNULL(MAX(RIGHT(@LastUniqueId1,5)),0)+1),        
			CONVERT(VARCHAR,ISNULL(MAX(RIGHT(@LastUniqueId1,5)),0)+1)) as nvarchar(15))+ '/'
			from Tbl_SubjectPrimaryDetail where AssignANM_ID = @ANMID and  UniqueSubjectID like '%'+@Source 
			
		Set @ReturnValue = (Convert(varchar(100),@UniqueSubjectId)+ CONVERT(varchar(5),@Source)) --as UniqueSubjectId, ISNULL(@LastUniqueId,'') as PreviousUniqueSubjectId
	
		Return @ReturnValue

End        
