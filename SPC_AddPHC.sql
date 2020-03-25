USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_AddPHC]    Script Date: 03/25/2020 15:46:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SPC_AddPHC]
(	
	@CHCID int
	,@HNIN_ID int
	,@PHC_gov_code varchar(50)	
	,@PHCname varchar(100)
	,@Isactive  Bit
	,@Latitude varchar(150)
	,@Longitude varchar(150)
	,@Comments varchar(150)
	,@Createdby int
	,@Updatedby int
	,@Scope_output int output
) As
Declare
	@phcCount int
	,@ID int
	,@tempUserId int
Begin
	Begin try
		If  @PHC_gov_code != '' or @PHC_gov_code is not null
		Begin
			select @phcCount =  count(ID) from Tbl_PHCMaster where PHC_gov_code= @PHC_gov_code
			select @ID= ID from Tbl_PHCMaster where PHC_gov_code= @PHC_gov_code
			if(@phcCount <= 0)
			Begin
				insert into Tbl_PHCMaster (
					CHCID
					,PHC_gov_code					
					,PHCname					
					,HNIN_ID
					,Isactive
					,Latitude
					,Longitude
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				) 
				values(
				@CHCID
				,@PHC_gov_code				
				,@PHCname
				,@HNIN_ID
				,@Isactive
				,@Latitude
				,@Longitude
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				set @tempUserId = IDENT_CURRENT('Tbl_PHCMaster')
				set @Scope_output = 1
			End
			else
			Begin
				Update Tbl_PHCMaster set 
				CHCID = @CHCID								
				,PHC_gov_code = @PHC_gov_code				
				,PHCname = @PHCname
				,HNIN_ID = @HNIN_ID
				,Isactive = @Isactive
				,Latitude = @Latitude
				,Longitude = @Longitude
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
