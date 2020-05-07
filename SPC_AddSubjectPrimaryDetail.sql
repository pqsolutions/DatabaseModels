USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddSubjectPrimaryDetail' AND [type] = 'p')
Begin
	DROP PROCEDURE SPC_AddSubjectPrimaryDetail
End
GO
CREATE PROCEDURE [dbo].[SPC_AddSubjectPrimaryDetail]
(
      @SubjectTypeID INT
      ,@ChildSubjectTypeID INT
      ,@DistrictID INT
      ,@CHCID INT
      ,@PHCID INT
      ,@SCID INT
      ,@RIID INT
      ,@SubjectTitle VARCHAR(50)
      ,@FirstName VARCHAR(150)
      ,@MiddleName VARCHAR(150)
      ,@LastName VARCHAR(150)
      ,@DOB DATETIME
      ,@Age INT
      ,@Gender VARCHAR(20)
      ,@MaritalStatus BIT
      ,@MobileNo VARCHAR(150)
      ,@EmailId VARCHAR(200)
      ,@SpouseSubjectID VARCHAR(200)
      ,@Spouse_FirstName VARCHAR(150)
      ,@Spouse_MiddleName VARCHAR(150)
      ,@Spouse_LastName VARCHAR(150)
      ,@Spouse_ContactNo VARCHAR(150)
      ,@GovIdType_ID INT
      ,@GovIdDetail VARCHAR(150)
      ,@AssignANM_ID INT
      ,@DateofRegister DATETIME
      ,@CreatedBy INT     
      ,@UpdatedBy INT     
      ,@IsActive BIT
	  ,@uniqueSubjectId VARCHAR(200)
	  ,@Source CHAR(1)
	  
)AS
DECLARE 
	@ID INT
	,@Count int
BEGIN
	BEGIN TRY
		IF @uniqueSubjectId = '' OR @uniqueSubjectId IS NULL
		BEGIN
			 SET @uniqueSubjectId = (Select [dbo].[FN_GenerateUniqueSubjectId](@AssignANM_ID,@Source))
			 SELECT @Count =  count(ID) FROM Tbl_SubjectPrimaryDetail WHERE uniqueSubjectId = @uniqueSubjectId
			 IF (@Count <= 0)
			 BEGIN
				 INSERT INTO [dbo].[Tbl_SubjectPrimaryDetail]
						   (SubjectTypeID
						   ,ChildSubjectTypeID
						   ,UniqueSubjectID
						   ,DistrictID
						   ,CHCID
						   ,PHCID
						   ,SCID
						   ,RIID
						   ,SubjectTitle
						   ,FirstName
						   ,MiddleName
						   ,LastName
						   ,DOB
						   ,Age
						   ,Gender
						   ,MaritalStatus
						   ,MobileNo
						   ,EmailId
						   ,SpouseSubjectID
						   ,Spouse_FirstName
						   ,Spouse_MiddleName
						   ,Spouse_LastName
						   ,Spouse_ContactNo
						   ,GovIdType_ID
						   ,GovIdDetail
						   ,AssignANM_ID
						   ,DateofRegister
						   ,CreatedBy
						   ,CreatedOn
						   ,UpdatedBy
						   ,UpdatedOn
						   ,IsActive)
					 VALUES
						   (@SubjectTypeID
						   ,@ChildSubjectTypeID 
						   ,@UniqueSubjectID
						   ,@DistrictID
						   ,@CHCID
						   ,@PHCID
						   ,@SCID
						   ,@RIID
						   ,@SubjectTitle
						   ,@FirstName
						   ,@MiddleName
						   ,@LastName
						   ,@DOB
						   ,@Age
						   ,@Gender
						   ,@MaritalStatus
						   ,@MobileNo
						   ,@EmailId
						   ,@SpouseSubjectID
						   ,@Spouse_FirstName
						   ,@Spouse_MiddleName
						   ,@Spouse_LastName
						   ,@Spouse_ContactNo
						   ,@GovIdType_ID
						   ,@GovIdDetail
						   ,@AssignANM_ID
						   ,@DateofRegister
						   ,@CreatedBy
						   ,GETDATE()
						   ,@UpdatedBy
						   ,GETDATE()
						   ,@IsActive)
					SELECT  @UniqueSubjectID as UniqueSubjectID, SCOPE_IDENTITY() AS ID
				END
		END
		ELSE
		BEGIN
			SET @ID = (SELECT ID FROM Tbl_SubjectPrimaryDetail WHERE UniqueSubjectID = @UniqueSubjectID) 
			UPDATE [dbo].[Tbl_SubjectPrimaryDetail]
				   SET SubjectTypeID = @SubjectTypeID	
					  ,ChildSubjectTypeID = @ChildSubjectTypeID				  
					  ,DistrictID = @DistrictID
					  ,CHCID = @CHCID
					  ,PHCID = @PHCID
					  ,SCID = @SCID
					  ,RIID = @RIID
					  ,SubjectTitle = @SubjectTitle
					  ,FirstName = @FirstName
					  ,MiddleName = @MiddleName
					  ,LastName = @LastName
					  ,DOB = @DOB
					  ,Age = @Age
					  ,Gender = @Gender
					  ,MaritalStatus = @MaritalStatus
					  ,MobileNo = @MobileNo
					  ,EmailId = @EmailId
					  ,SpouseSubjectID = @SpouseSubjectID
					  ,Spouse_FirstName = @Spouse_FirstName
					  ,Spouse_MiddleName = @Spouse_MiddleName
					  ,Spouse_LastName = @Spouse_LastName
					  ,Spouse_ContactNo = @Spouse_ContactNo
					  ,GovIdType_ID = @GovIdType_ID
					  ,GovIdDetail = @GovIdDetail
					  ,AssignANM_ID = @AssignANM_ID
					  ,DateofRegister = @DateofRegister					  				 
					  ,UpdatedBy = @UpdatedBy
					  ,UpdatedOn = GETDATE()
					  ,IsActive = @IsActive
					WHERE ID = @ID
					
				SELECT  @UniqueSubjectID AS UniqueSubjectID, @ID AS ID
							
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

