USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_AddHNIN]    Script Date: 03/25/2020 23:51:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (Select 1 from sys.objects where name='SPC_AddHNIN' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_AddHNIN
End
GO
CREATE procedure [dbo].[SPC_AddHNIN]
(	
	@Facilitytype_ID int
	,@Facility_name varchar(100)
	,@NIN2HFI varchar(100)
	,@StateID int
	,@DistrictID int
	,@Taluka varchar(100)
	,@BlockID int
	,@Address varchar(500)	
	,@Pincode varchar(100)
	,@Landline  varchar(100)
	,@Incharge_name varchar(100)
	,@Incharge_contactno varchar(100)
	,@Incharge_EmailId varchar(150)
	,@Isactive  Bit
	,@Latitude varchar(150)
	,@Longitude varchar(150)
	,@Comments varchar(150)
	,@Createdby int
	,@Updatedby int
	,@Scope_output int output
) As
Declare
	@HNINCount int
	,@id int
	,@tempUserId int
Begin
	Begin try
		If @NIN2HFI != '' or @NIN2HFI is not null
		Begin
			select @HNINCount =  count(ID) from Tbl_HNINMaster where NIN2HFI = @NIN2HFI
			Select @id = ID from Tbl_HNINMaster where NIN2HFI = @NIN2HFI
			if(@HNINCount <= 0)
			Begin
				insert into Tbl_HNINMaster (
					Facilitytype_ID
					,Facility_name
					,NIN2HFI
					,StateID 
					,DistrictID 
					,Taluka
					,BlockID
					,Address	
					,Pincode 
					,Landline
					,Incharge_name
					,Incharge_contactno
					,Incharge_EmailId
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
				@Facilitytype_ID
				,@Facility_name
				,@NIN2HFI
				,@StateID 
				,@DistrictID 
				,@Taluka
				,@BlockID
				,@Address	
				,@Pincode 
				,@Landline
				,@Incharge_name
				,@Incharge_contactno
				,@Incharge_EmailId
				,@Isactive
				,@Latitude
				,@Longitude
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				set @tempUserId = IDENT_CURRENT('Tbl_HNINMaster')
				set @Scope_output = 1
			End
			else
			Begin
				Update Tbl_HNINMaster set 
				Facilitytype_ID = @Facilitytype_ID
				,Facility_name = @Facility_name				
				,StateID = @StateID
				,DistrictID = @DistrictID
				,Taluka = @Taluka
				,BlockID = @BlockID
				,Address = @Address	
				,Pincode = @Pincode
				,Landline = @Landline
				,Incharge_name = @Incharge_name
				,Incharge_contactno = @Incharge_contactno
				,Incharge_EmailId = @Incharge_EmailId
				,Isactive = @Isactive
				,Latitude = @Latitude
				,Longitude = @Longitude
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				where  ID= @id
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
