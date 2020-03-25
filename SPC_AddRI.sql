USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_AddRI]    Script Date: 03/25/2020 17:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SPC_AddRI]
(	
	
	@PHCID int
	,@SCID int
	,@RI_gov_code varchar(50)	
	,@RIsite varchar(100)
	,@Pincode Varchar(100)
	,@Isactive  Bit
	,@Latitude varchar(150)
	,@Longitude varchar(150)
	,@Comments varchar(150)
	,@Createdby int
	,@Updatedby int
	,@Scope_output int output
) As
Declare
	@riCount int
	,@ID int
	,@tempUserId int
Begin
	Begin try
		If  @RI_gov_code != '' or @RI_gov_code is not null
		Begin
			select @riCount =  count(ID) from Tbl_RIMaster where RI_gov_code= @RI_gov_code
			select @ID= ID from Tbl_RIMaster where RI_gov_code= @RI_gov_code
			if(@riCount <= 0)
			Begin
				insert into Tbl_RIMaster (
					PHCID
					,SCID
					,RI_gov_code					
					,RIsite	
					,Pincode		
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
				@PHCID
				,@SCID
				,@RI_gov_code				
				,@RIsite
				,@Pincode
				,@Isactive
				,@Latitude
				,@Longitude
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				set @tempUserId = IDENT_CURRENT('Tbl_RIMaster')
				set @Scope_output = 1
			End
			else
			Begin
				Update Tbl_RIMaster set 
				PHCID = @PHCID
				,SCID = @SCID								
				,RI_gov_code = @RI_gov_code				
				,RIsite = @RIsite
				,Pincode = @Pincode
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
