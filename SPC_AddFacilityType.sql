USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_AddFacilityType]    Script Date: 03/25/2020 23:48:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (Select 1 from sys.objects where name='SPC_AddFacilityType' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_AddFacilityType
End
GO
CREATE procedure [dbo].[SPC_AddFacilityType]
(	
	@Facility_typename varchar(100)
	,@Isactive  Bit
	,@Comments varchar(150)
	,@Createdby int
	,@Updatedby int
	,@Scope_output int output
) As
Declare
	@FCount int
	,@ID int
	,@tempUserId int
Begin
	Begin try
		If @Facility_typename is not null
		Begin
			select @FCount =  count(ID) from Tbl_FacilityTypeMaster where Facility_typename = @Facility_typename
			select @ID =  ID from Tbl_FacilityTypeMaster where Facility_typename = @Facility_typename
			if(@FCount <= 0)
			Begin
				insert into Tbl_FacilityTypeMaster (
					Facility_typename
					,Isactive
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				) 
				values(
				@Facility_typename
				,@Isactive
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				set @tempUserId = IDENT_CURRENT('Tbl_FacilityTypeMaster')
				set @Scope_output = 1
			End
			else
			Begin
				Update Tbl_FacilityTypeMaster set 
				Facility_typename = @Facility_typename
				,Isactive = @Isactive
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				where ID = @ID
			End
		End
		else
		Begin
			set @Scope_output = -1
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
