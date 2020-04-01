USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (Select 1 from sys.objects where name='SPC_GenerateUniqueSubjectId' and [type] = 'p')
Begin
	Drop Procedure SPC_GenerateUniqueSubjectId
End
GO
Create Procedure [dbo].[SPC_GenerateUniqueSubjectId] 
(
	@ANMID int
	,@Source char(1)
) As
Declare

	@ANMCode  varchar(100)
	,@UniqueSubjectId varchar(MAX)
	,@StateID int
	,@StateShortCode varchar(10)
	,@LastUniqueId varchar(MAX)
	,@LastUniqueId1 varchar(MAX)	
	
Begin
	Begin try
	
		Select @ANMCode = User_gov_code
			   ,@StateID = StateID		
			   from Tbl_UserMaster where ID = @ANMID
			   
		Select @StateShortCode = Shortname from Tbl_StateMaster where ID = @StateID
		
		Set @LastUniqueId = (Select top 1 UniqueSubjectID 
				from Tbl_SubjectPrimaryDetail with(nolock) where AssignANM_ID = @ANMID  and  UniqueSubjectID like '%'+@Source      
				order by UniqueSubjectID desc)
				
		set @LastUniqueId1 =(select ISNULL(LEFT(@LastUniqueId,(len(@LastUniqueId)-1)),''))
		
		select @UniqueSubjectId = @StateShortCode +  @ANMCode +      
				cast(STUFF('00000',6-LEN(ISNULL(MAX(RIGHT(@LastUniqueId1,5)),0)+1),        
				LEN(ISNULL(MAX(RIGHT(@LastUniqueId1,5)),0)+1),        
				CONVERT(VARCHAR,ISNULL(MAX(RIGHT(@LastUniqueId1,5)),0)+1)) as nvarchar(15))
				from Tbl_SubjectPrimaryDetail where AssignANM_ID = @ANMID and  UniqueSubjectID like '%'+@Source 
				
		Select (@UniqueSubjectId+@Source) as UniqueSubjectId, ISNULL(@LastUniqueId,'') as PreviousUniqueSubjectId
	
	End try
	Begin catch
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

			DECLARE @ErrorNumber INT = ERROR_NUMBER();
			DECLARE @ErrorLine INT = ERROR_LINE();
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
			DECLARE @ErrorState INT = ERROR_STATE();

			PRINT 'Actual error number: ' + CAST(@ErrorNumber AS VARCHAR(10));
			PRINT 'Actual line number: ' + CAST(@ErrorLine AS VARCHAR(10));

			RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);		
	End catch
End

