--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (SELECT 1 FROM sys.objects WHERE NAME='SPC_AddANMUser' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddANMUser
END
GO
CREATE PROCEDURE [dbo].[SPC_AddANMUser] 
(
	@User_gov_code VARCHAR(150) 
	,@Password VARCHAR(MAX)
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
	,@GovIDDetails VARCHAR(150) 
	,@Address VARCHAR(MAX)
	,@Pincode VARCHAR(150)	 
	,@UserId INT 	
)
AS
DECLARE
	
	@ID INT
	,@Indexvar INT  
	,@TotalCount INT  
	,@CurrentIndex NVARCHAR(10)
	,@MSG VARCHAR(MAX)
BEGIN
	BEGIN TRY
		IF @User_gov_code IS NOT NULL OR @User_gov_code != ''
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM Tbl_UserMaster WHERE User_gov_code = @User_gov_code)
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
				,Isactive
				,Createdon
				,Updatedon
				)VALUES(
					3  
					,3  
					,@User_gov_code  
					,('ANM'+ @User_gov_code)
					,@Password
					,1
					,0
					,0 
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
					,@UserId  	
					,@UserId  
					,1
					,GETDATE()
					,GETDATE()
					)
				SET @ID = (SELECT SCOPE_IDENTITY())
				SET @IndexVar = 0  
				SELECT @TotalCount = COUNT(value) FROM [dbo].[FN_Split](@RIID,',')  
				WHILE @Indexvar < @TotalCount  
				BEGIN
					SELECT @IndexVar = @IndexVar + 1
					SELECT @CurrentIndex = Value FROM  [dbo].[FN_Split](@RIID,',') WHERE id = @Indexvar
					UPDATE Tbl_RIMaster SET ANMID = @ID WHERE ID = CAST(@CurrentIndex AS INT)
				END
				

				SELECT ('ANM'+ @User_gov_code +' - UserId Created Successfully') AS MSG,  1 AS Success
			END
			ELSE
			BEGIN
				SELECT ('This ANMCode - ' + @User_gov_code + ' Already Exists') AS MSG, 0 AS Success
			END
		END
		ELSE
		BEGIN
			SELECT 'Invalid ANMCode' AS MSG, 0 AS Success
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
