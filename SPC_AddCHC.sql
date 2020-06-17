USE [Eduquaydb]
GO

/****** Object:  StoredProcedure [dbo].[SPC_AddCHC]    Script Date: 03/25/2020 22:42:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (Select 1 from sys.objects where name='SPC_AddCHC' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_AddCHC
End
GO

CREATE procedure [dbo].[SPC_AddCHC]
(	
	
	@DistrictID int
	,@BlockID int
	,@HNIN_ID varchar(200)
	,@CHC_gov_code varchar(50)	
	,@CHCname varchar(100)
	,@Istestingfacility  Bit
	,@AssociatedCHCID int
	,@Pincode varchar(150)
	,@Isactive  Bit
	,@Latitude varchar(150)
	,@Longitude varchar(150)
	,@Comments varchar(150)
	,@Createdby int
	,@Updatedby int
	,@Scope_output int output
) As
Declare
	@chcCount int
	,@id int
	,@tempUserId int
Begin
	Begin try
		If @CHC_gov_code !='' or  @CHC_gov_code is not null
		Begin
			select @chcCount =  count(ID) from Tbl_CHCMaster where CHC_gov_code = @CHC_gov_code
			select @id= ID from Tbl_CHCMaster where CHC_gov_code= @CHC_gov_code
			if(@chcCount <= 0)
			Begin
				insert into Tbl_CHCMaster (
					BlockID
					,DistrictID
					,CHC_gov_code					
					,CHCname
					,Istestingfacility
					,AssociatedCHCID
					,HNIN_ID
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
				@BlockID
				,@DistrictID
				,@CHC_gov_code				
				,@CHCname
				,@Istestingfacility
				,@AssociatedCHCID
				,@HNIN_ID
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
				set @tempUserId = IDENT_CURRENT('Tbl_CHCMaster')
				set @Scope_output = 1
			End
			else
			Begin
				Update Tbl_CHCMaster set 
				BlockID = @BlockID	
				,DistrictID = @DistrictID			
				,CHC_gov_code = @CHC_gov_code				
				,CHCname = @CHCname
				,Istestingfacility = @Istestingfacility
				,AssociatedCHCID = @AssociatedCHCID
				,HNIN_ID = @HNIN_ID
				,Pincode = @Pincode
				,Isactive = @Isactive
				,Latitude = @Latitude
				,Longitude = @Longitude
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				where ID = @id
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

GO


