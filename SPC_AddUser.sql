USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddUser' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddUser
END
GO
CREATE PROCEDURE [dbo].[SPC_AddUser] 
(
	@UserType_ID INT 
	,@UserRole_ID INT 
	,@User_gov_code VARCHAR(150) 
	,@Username VARCHAR(150) 
	,@Password VARCHAR(150)
	,@StateID INT
	,@CentralLabId INT
	,@MolecularLabId INT
	,@DistrictID INT
	,@BlockID INT
	,@CHCID INT
	,@PHCID INT 
	,@SCID INT 
	,@RIID VARCHAR(50) 
	,@FirstName VARCHAR(150) 
	,@MiddleName VARCHAR(150) 
	,@LastName VARCHAR(150) 
	,@ContactNo1 VARCHAR(150) 
	,@ContactNo2 VARCHAR(150)  
	,@Email VARCHAR(150) 
	,@GovIDType_ID INT 
	,@GovIDDetails VARCHAR (150) 
	,@Address VARCHAR(MAX)
	,@Pincode VARCHAR(150)	 
	,@Createdby INT 	
	,@Updatedby INT 
	,@Comments VARCHAR(max) 
	,@Isactive bit
	--,@DigitalSignature image 
	,@Scope_output INT OUTPUT
)
As
Declare
	@userCount INT
	,@ID INT
	,@tempUserId INT
BEGIN
	BEGIN TRY
		If @Username IS NOT NULL OR @Username != ''
		BEGIN
			SELECT @userCount =  count(*) FROM [Tbl_UserMaster] WHERE Username = @Username
			SELECT @ID = ID FROM [Tbl_UserMaster] WHERE Username = @Username
			if(@userCount <= 0)
			BEGIN
				INSERT INTO [Tbl_UserMaster] (
							UserType_ID  
							,UserRole_ID  
							,User_gov_code  
							,Username  
							,Password 
							,StateID
							,CentralLabId
							,MolecularLabId
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
				VALUES(
				@UserType_ID  
				,@UserRole_ID  
				,@User_gov_code  
				,@Username  
				,@Password
				,@StateID
				,@CentralLabId
				,@MolecularLabId 
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
				SET @tempUserId = IDENT_CURRENT('Tbl_UserMaster')
				SET @SCOPE_OUTPUT = 1
			END
			ELSE
			BEGIN
				UPDATE [Tbl_UserMaster] SET 
					UserType_ID = @UserType_ID  
					,UserRole_ID = @UserRole_ID  
					,User_gov_code = @User_gov_code					
					--,Password = @Password
					,StateID = @StateID
					,CentralLabId = @CentralLabId
					,MolecularLabId = @MolecularLabId 
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
				WHERE ID = @ID
			END
		END
		ELSE
		BEGIN
			SET @SCOPE_OUTPUT = -1
		END
	END TRY
	BEGIN CATCH
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
	END CATCH
END
