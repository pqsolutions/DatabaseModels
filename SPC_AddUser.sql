USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (Select 1 from sys.objects where name='SPC_AddUser' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_AddUser
End
GO
CREATE Procedure [dbo].[SPC_AddUser] 
(
	@UserType_ID int 
	,@UserRole_ID int 
	,@User_gov_code varchar(150) 
	,@Username varchar(150) 
	,@Password varchar(150)
	,@StateID int
	,@DistrictID int
	,@BlockID int
	,@CHCID int
	,@PHCID int 
	,@SCID int 
	,@RIID int 
	,@FirstName varchar(150) 
	,@MiddleName varchar(150) 
	,@LastName varchar(150) 
	,@ContactNo1 varchar(150) 
	,@ContactNo2 varchar(150)  
	,@Email varchar(150) 
	,@GovIDType_ID int 
	,@GovIDDetails varchar (150) 
	,@Address varchar(MAX)
	,@Pincode varchar(150)	 
	,@Createdby int 	
	,@Updatedby int 
	,@Comments varchar(max) 
	,@Isactive bit
	--,@DigitalSignature image 
	,@Scope_output int output
)
As
Declare
	@userCount int
	,@ID int
	,@tempUserId int
Begin
	Begin try
		If @Username is not null or @Username != ''
		Begin
			select @userCount =  count(*) from [Tbl_UserMaster] where Username = @Username
			select @ID = ID from [Tbl_UserMaster] where Username = @Username
			if(@userCount <= 0)
			Begin
				insert into [Tbl_UserMaster] (
							UserType_ID  
							,UserRole_ID  
							,User_gov_code  
							,Username  
							,Password 
							,StateID
							,DistrictID
							,BlockID
							,CHCID
							,PHCID 
							,SCID  
							,RIID  
							,FirstName  
							,MiddleName  
							,LastName  
							,ContactNo1  
							,ContactNo2   
							,Email  
							,GovIDType_ID  
							,GovIDDetails   
							,Address 
							,Pincode	 
							,Createdby  	
							,Updatedby  
							,Comments  
							,Isactive
							,Createdon
							,Updatedon
							--,DigitalSignature
				) 
				values(
				@UserType_ID  
				,@UserRole_ID  
				,@User_gov_code  
				,@Username  
				,@Password
				,@StateID
				,@DistrictID
				,@BlockID
				,@CHCID
				,@PHCID  
				,@SCID  
				,@RIID  
				,@FirstName  
				,@MiddleName  
				,@LastName  
				,@ContactNo1  
				,@ContactNo2   
				,@Email  
				,@GovIDType_ID  
				,@GovIDDetails   
				,@Address
				,@Pincode 	 
				,@Createdby  	
				,@Updatedby  
				,@Comments  
				,@Isactive
				,GETDATE()
				,GETDATE()
			--	,@DigitalSignature
				)
				set @tempUserId = IDENT_CURRENT('Tbl_UserMaster')
				set @SCOPE_OUTPUT = 1
			End
			else
			Begin
				Update [Tbl_UserMaster] set 
					UserType_ID = @UserType_ID  
					,UserRole_ID = @UserRole_ID  
					,User_gov_code = @User_gov_code					
					--,Password = @Password
					,StateID = @StateID
					,DistrictID = @DistrictID
					,BlockID = @BlockID
					,CHCID = @CHCID
					,PHCID = @PHCID
					,SCID  = @SCID
					,RIID  = @RIID
					,FirstName = @FirstName
					,MiddleName = @MiddleName  
					,LastName  = @LastName
					,ContactNo1 = @ContactNo1  
					,ContactNo2 = ContactNo2  
					,Email = @Email 
					,GovIDType_ID = @GovIDType_ID 
					,GovIDDetails = @GovIDDetails   
					,Address = @Address	
					,Pincode = @Pincode		
					,Updatedby = @Updatedby 
					,Comments  = @Comments
					,Isactive = @Isactive
					--,DigitalSignature = @DigitalSignature
				where ID = @ID
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
