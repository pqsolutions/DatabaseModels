USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (Select 1 from sys.objects where name='SPC_AddSubjectType' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_AddSubjectType
End
GO
CREATE procedure [dbo].[SPC_AddSubjectType]
(	
	@SubjectType varchar(100)
	,@Isactive  Bit
	,@Comments varchar(150)
	,@Createdby int
	,@Updatedby int
) As
Declare
	@stCount int
	,@ID int
	,@tempUserId int
Begin
	Begin try
		If @SubjectType is not null
		Begin
			select @stCount =  count(ID) from Tbl_SubjectTypeMaster where SubjectType = @SubjectType
			select @ID =  ID from Tbl_SubjectTypeMaster where SubjectType = @SubjectType
			if(@stCount <= 0)
			Begin
				insert into Tbl_SubjectTypeMaster (
					SubjectType
					,Isactive
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				) 
				values(
				@SubjectType
				,@Isactive
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				SELECT 'Subject Type added successfully' AS Msg
			End
			else
			Begin
				Update Tbl_SubjectTypeMaster set 
				SubjectType = @SubjectType
				,Isactive = @Isactive
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				where ID = @ID
				SELECT 'Subject Type updated successfully' AS Msg
			End
		End
		else
		Begin
			SELECT 'Subject Type is missing' AS Msg
		End
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
