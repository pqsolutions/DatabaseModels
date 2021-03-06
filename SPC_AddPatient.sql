USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_AddPatient]    Script Date: 03/20/2020 10:23:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (Select 1 from sys.objects where name='SPC_AddPatient' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_AddPatient
End
GO

CREATE procedure [dbo].[SPC_AddPatient]
( 
	@GID int
	,@FIRSTNAME varchar(100)
	,@LASTNAME  varchar(100)
	,@LOCATION  varchar(100)
	,@SCOPE_OUTPUT int output
) As
Declare
	@patientCount int
	,@tempUserId int
Begin
	Begin try
		If @GID is not null or @GID > 0
		Begin
			select @patientCount =  count(GID) from TBL_PATIENT where GID = @GID
			if(@patientCount <= 0)
			Begin
				insert into TBL_PATIENT (
					GID
					,FIRSTNAME
					,LASTNAME
					,CITY
				) 
				values(
				@GID
				,@FIRSTNAME
				,@LASTNAME
				,@LOCATION
				)
				set @tempUserId = IDENT_CURRENT('TBL_PATIENT')
				set @SCOPE_OUTPUT = 1
			End
			else
			Begin
				Update TBL_PATIENT set 
				FIRSTNAME = @FIRSTNAME
				,LASTNAME = @LASTNAME
				,CITY = @LOCATION
				where GID = @GID
			End
		End
		else
		Begin
			set @SCOPE_OUTPUT = -1
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
