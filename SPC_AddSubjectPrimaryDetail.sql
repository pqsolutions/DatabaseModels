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
      ,@DOB VARCHAR(150)
      ,@Age INT
      ,@Gender VARCHAR(20)
      ,@MaritalStatus BIT
      ,@MobileNo VARCHAR(150)
      ,@EmailId VARCHAR(200)
      ,@GovIdType_ID INT
      ,@GovIdDetail VARCHAR(150)
      ,@SpouseSubjectID VARCHAR(200)
      ,@Spouse_FirstName VARCHAR(150)
      ,@Spouse_MiddleName VARCHAR(150)
      ,@Spouse_LastName VARCHAR(150)
      ,@Spouse_ContactNo VARCHAR(150)
      ,@Spouse_GovIdType_ID INT
      ,@Spouse_GovIdDetail VARCHAR(150)
      ,@AssignANM_ID INT
      ,@DateofRegister VARCHAR(150)
      ,@RegisteredFrom INT
      ,@CreatedBy INT     
	  ,@UniqueSubjectId VARCHAR(200) 
	  ,@Source CHAR(1) -- N/F/M (N-Online, F-Offline, M-Manual)
	  
)AS
DECLARE 
	@ID INT
	,@Count INT
	,@DateOfBirth DATE
	,@DateofReg DATE
	,@NewUniqueSubjectID VARCHAR(200)
BEGIN
	BEGIN TRY
			 SELECT @Count =  COUNT(ID) FROM Tbl_SubjectPrimaryDetail WHERE UniqueSubjectID = ISNULL(@UniqueSubjectId,'')
			 SET @DateOfBirth = CONVERT(DATE,@DOB,103)
			 SET @DateofReg  = CONVERT(DATE,@DateofRegister,103)
			 IF ISNULL(@DOB,'') = ''
			 BEGIN
				SET @DateOfBirth = NULL
			 END
			IF ISNULL(@DateofRegister,'') = ''
			 BEGIN
				SET @DateofReg = (SELECT GETDATE())
			 END
			 IF (@Count <= 0)
			 BEGIN
				 SET @NewUniqueSubjectId = (SELECT [dbo].[FN_GenerateUniqueSubjectId](@AssignANM_ID,@Source))
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
						   ,GovIdType_ID
						   ,GovIdDetail
						   ,SpouseSubjectID
						   ,Spouse_FirstName
						   ,Spouse_MiddleName
						   ,Spouse_LastName
						   ,Spouse_ContactNo
						   ,Spouse_GovIdType_ID
						   ,Spouse_GovIdDetail
						   ,AssignANM_ID
						   ,DateofRegister
						   ,RegisteredFrom
						   ,CreatedBy
						   ,CreatedOn
						   ,UpdatedBy
						   ,UpdatedOn
						   ,IsActive)
					 VALUES
						   (@SubjectTypeID
						   ,@ChildSubjectTypeID 
						   ,@NewUniqueSubjectId
						   ,@DistrictID
						   ,@CHCID
						   ,@PHCID
						   ,@SCID
						   ,@RIID
						   ,@SubjectTitle
						   ,@FirstName
						   ,@MiddleName
						   ,@LastName
						   ,@DateOfBirth
						   ,@Age
						   ,@Gender
						   ,@MaritalStatus
						   ,@MobileNo
						   ,@EmailId
						   ,@GovIdType_ID
						   ,@GovIdDetail
						   ,@SpouseSubjectID
						   ,@Spouse_FirstName
						   ,@Spouse_MiddleName
						   ,@Spouse_LastName
						   ,@Spouse_ContactNo
						   ,@Spouse_GovIdType_ID
						   ,@Spouse_GovIdDetail
						   ,@AssignANM_ID
						   ,@DateofReg
						   ,@RegisteredFrom
						   ,@CreatedBy
						   ,GETDATE()
						   ,@CreatedBy
						   ,GETDATE()
						   ,1)
					SELECT  @NewUniqueSubjectID  as UniqueSubjectID, SCOPE_IDENTITY() AS ID
					IF @SubjectTypeID = 2 OR @ChildSubjectTypeID = 2 
					BEGIN
						UPDATE Tbl_SubjectPrimaryDetail  SET 
							SpouseSubjectID = @NewUniqueSubjectID
							,Spouse_ContactNo = @MobileNo
							,Spouse_FirstName = @FirstName
							,Spouse_MiddleName = @MiddleName
							,Spouse_LastName = @LastName 
							,Spouse_GovIdType_ID = @GovIdType_ID 
							,Spouse_GovIdDetail = @GovIdDetail 
						WHERE  UniqueSubjectID  = @SpouseSubjectID
						
						UPDATE Tbl_PositiveResultSubjectsDetail SET 
							HPLCNotifiedStatus = 1
							,HPLCNotifiedBy = @CreatedBy
							,HPLCNotifiedOn = GETDATE()
						WHERE  UniqueSubjectID  = @SpouseSubjectID 
						
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
					  ,DOB = @DateOfBirth
					  ,Age = @Age
					  ,Gender = @Gender
					  ,MaritalStatus = @MaritalStatus
					  ,MobileNo = @MobileNo
					  ,EmailId = @EmailId
					  ,GovIdType_ID = @GovIdType_ID
					  ,GovIdDetail = @GovIdDetail
					  ,SpouseSubjectID = @SpouseSubjectID
					  ,Spouse_FirstName = @Spouse_FirstName
					  ,Spouse_MiddleName = @Spouse_MiddleName
					  ,Spouse_LastName = @Spouse_LastName
					  ,Spouse_ContactNo = @Spouse_ContactNo
					  ,Spouse_GovIdType_ID = @Spouse_GovIdType_ID
					  ,Spouse_GovIdDetail = @Spouse_GovIdDetail
					  ,AssignANM_ID = @AssignANM_ID
					  ,DateofRegister = @DateofReg		
					  ,UpdatedBy = @CreatedBy 
					  ,UpdatedOn = GETDATE()
					  ,IsActive = 1
					WHERE ID = @ID
					IF @SubjectTypeID = 2 OR @ChildSubjectTypeID = 2 OR @SubjectTypeID = 1 OR @ChildSubjectTypeID = 1
					BEGIN
						UPDATE Tbl_SubjectPrimaryDetail  SET 
							SpouseSubjectID = @UniqueSubjectId
							,Spouse_ContactNo = @MobileNo
							,Spouse_FirstName = @FirstName
							,Spouse_MiddleName = @MiddleName
							,Spouse_LastName = @LastName 
							,Spouse_GovIdType_ID = @GovIdType_ID 
							,Spouse_GovIdDetail = @GovIdDetail 
						WHERE  UniqueSubjectID  = @SpouseSubjectID 
					END
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

