USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddPrimaryDetail' AND [type] = 'p')
Begin
	DROP PROCEDURE SPC_AddPrimaryDetail
End
GO
CREATE PROCEDURE [dbo].[SPC_AddPrimaryDetail]
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
      ,@DateofRegister DATETIME
      ,@RegisteredFrom INT
      ,@CreatedBy INT     
      ,@UpdatedBy INT     
      ,@IsActive BIT
	  ,@UniqueSubjectId VARCHAR(200)
	  ,@Source CHAR(1) -- N/F/M (N-Online, F-Offline, M-Manual)
	  
)AS
DECLARE 
	@ID INT
	,@Count int
BEGIN
	BEGIN TRY
		
		SELECT @Count =  count(ID) FROM Tbl_SubjectPrimaryDetail WHERE UniqueSubjectID = @UniqueSubjectId
	
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
				   ,@DateofRegister
				   ,@RegisteredFrom
				   ,@CreatedBy
				   ,GETDATE()
				   ,@UpdatedBy
				   ,GETDATE()
				   ,@IsActive)
						
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
