USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_AddCHC]    Script Date: 03/20/2020 18:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SPC_AddCHC]
(	
	@BlockID int
	,@DistrictID int
	,@HNIN_ID int
	,@CHC_gov_code varchar(50)	
	,@CHCname varchar(100)
	,@Istestingfacility  Bit
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
	,@tempUserId int
Begin
	Begin try
		If @CHC_gov_code is not null or @CHC_gov_code > 0
		Begin
			select @chcCount =  count(ID) from Masters_CHC where CHC_gov_code= @CHC_gov_code
			if(@CHC_gov_code <= 0)
			Begin
				insert into Masters_CHC (
					BlockID
					,DistrictID
					,CHC_gov_code					
					,CHCname
					,Istestingfacility
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
				@BlockID
				,@DistrictID
				,@CHC_gov_code				
				,@CHCname
				,@Istestingfacility
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
				set @tempUserId = IDENT_CURRENT('Masters_CHC')
				set @Scope_output = 1
			End
			else
			Begin
				Update Masters_CHC set 
				BlockID = @BlockID	
				,DistrictID = @DistrictID			
				,CHC_gov_code = @CHC_gov_code				
				,CHCname = @CHCname
				,Istestingfacility = @Istestingfacility
				,HNIN_ID = @HNIN_ID
				,Isactive = @Isactive
				,Latitude = @Latitude
				,Longitude = @Longitude
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				where CHC_gov_code = @CHC_gov_code
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
