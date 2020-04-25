USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_AddDistrict]    Script Date: 03/25/2020 23:46:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (Select 1 from sys.objects where name='SPC_AddDistrict' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_AddDistrict
End
GO
CREATE procedure [dbo].[SPC_AddDistrict]
(	
	@District_gov_code varchar(50)
	,@StateID int
	,@Districtname varchar(100)
	,@Isactive  Bit
	,@Comments varchar(150)
	,@Createdby int
	,@Updatedby int
	,@Scope_output int output
) As
Declare
	@districtCount int
	,@ID int
	,@tempUserId int
Begin
	Begin try
		If @District_gov_code != '' or @District_gov_code is not null
		Begin
			select @districtCount =  count(ID) from Tbl_DistrictMaster where District_gov_code= @District_gov_code
			select @ID = ID from Tbl_DistrictMaster where District_gov_code= @District_gov_code
			if(@districtCount <= 0)
			Begin
				insert into Tbl_DistrictMaster (
					District_gov_code
					,StateID
					,Districtname
					,Isactive
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				) 
				values(
				@District_gov_code
				,@StateID
				,@Districtname
				,@Isactive
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				set @tempUserId = IDENT_CURRENT('Tbl_DistrictMaster')
				set @Scope_output = 1
			End
			else
			Begin
				Update Tbl_DistrictMaster set 
				District_gov_code = @District_gov_code
				,StateID=@StateID
				,Districtname = @Districtname
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
