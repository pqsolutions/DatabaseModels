USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (Select 1 from sys.objects where name='SPC_AddSubjectParentDetail' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_AddSubjectParentDetail
End
GO
CREATE PROCEDURE [dbo].[SPC_AddSubjectParentDetail] 
(
	@UniqueSubjectID  VARCHAR(250)	
	,@Mother_FirstName VARCHAR(150)
	,@Mother_MiddleName VARCHAR(150)
	,@Mother_LastName VARCHAR(150)
	,@Mother_GovIdType_ID INT
	,@Mother_GovIdDetail VARCHAR(200)
	,@Mother_ContactNo VARCHAR(150)
	,@Father_FirstName VARCHAR(150)
	,@Father_MiddleName VARCHAR(150)
	,@Father_LastName VARCHAR(150)
	,@Father_GovIdType_ID INT
	,@Father_GovIdDetail VARCHAR(200)
	,@Father_ContactNo VARCHAR(150)
	,@Gaurdian_FirstName VARCHAR(150)
	,@Gaurdian_MiddleName VARCHAR(150)
	,@Gaurdian_LastName VARCHAR(150)
	,@Guardian_GovIdType_ID INT
	,@Guardian_GovIdDetail VARCHAR(200)
	,@Gaurdian_ContactNo VARCHAR(150)
	,@RBSKId VARCHAR(150)
	,@SchoolName VARCHAR(150)
	,@SchoolAddress1 VARCHAR(250)
	,@SchoolAddress2 VARCHAR(250)
	,@SchoolAddress3 VARCHAR(250)
	,@SchoolPincode VARCHAR(250)
	,@SchoolCity VARCHAR(200)
	,@SchoolState  VARCHAR(200)
	,@Standard VARCHAR(10)
	,@Section VARCHAR(5)
	,@RollNo VARCHAR(50)
	,@UpdatedBy  INT
	,@Scope_output INT OUTPUT
) AS
DECLARE
	@SubCount INT
	,@SubjectID INT
	,@tempUserId INT
BEGIN
	BEGIN TRY
		IF @UniqueSubjectID IS NOT NULL
		BEGIN
			SELECT @SubCount =  count(ID) from Tbl_SubjectParentDetail where UniqueSubjectID = @UniqueSubjectID
			SELECT @SubjectID =   ID FROM Tbl_SubjectPrimaryDetail WHERE UniqueSubjectID = @UniqueSubjectID
			IF (@SubCount <= 0) 
			BEGIN
				INSERT INTO [dbo].[Tbl_SubjectParentDetail]
					(SubjectID
					,UniqueSubjectID
					,Mother_FirstName
					,Mother_MiddleName
					,Mother_LastName
					,Mother_GovIdType_ID
					,Mother_GovIdDetail
					,Mother_ContactNo
					,Father_FirstName
					,Father_MiddleName
					,Father_LastName
					,Father_GovIdType_ID
					,Father_GovIdDetail
					,Father_ContactNo
					,Gaurdian_FirstName
					,Gaurdian_MiddleName
					,Gaurdian_LastName
					,Guardian_GovIdType_ID
					,Guardian_GovIdDetail
					,Gaurdian_ContactNo
					,RBSKId
					,SchoolName
					,SchoolAddress1
					,SchoolAddress2
					,SchoolAddress3
					,SchoolPincode
					,SchoolCity
					,SchoolState
					,Standard
					,Section
					,RollNo
					,UpdatedBy
					,UpdatedOn)
				VALUES
					(@SubjectID  
					,@UniqueSubjectID 
					,@Mother_FirstName 
					,@Mother_MiddleName 
					,@Mother_LastName 
					,@Mother_GovIdType_ID
					,@Mother_GovIdDetail 
					,@Mother_ContactNo 
					,@Father_FirstName 
					,@Father_MiddleName 
					,@Father_LastName 
					,@Father_GovIdType_ID
					,@Father_GovIdDetail 
					,@Father_ContactNo 
					,@Gaurdian_FirstName 
					,@Gaurdian_MiddleName 
					,@Gaurdian_LastName
					,@Guardian_GovIdType_ID
					,@Guardian_GovIdDetail 
					,@Gaurdian_ContactNo 
					,@RBSKId 
					,@SchoolName 
					,@SchoolAddress1 
					,@SchoolAddress2 
					,@SchoolAddress3 
					,@SchoolPincode 
					,@SchoolCity 
					,@SchoolState  
					,@Standard 
					,@Section 
					,@RollNo 
					,@UpdatedBy  
					,GETDATE())
				SET @tempUserId = IDENT_CURRENT('Tbl_SubjectParentDetail')
				SET @Scope_output = 1
			END
			ELSE 
			BEGIN
				UPDATE [dbo].[Tbl_SubjectParentDetail]
				   SET Mother_FirstName = @Mother_FirstName
						,Mother_MiddleName = @Mother_MiddleName
						,Mother_LastName = @Mother_LastName
						,Mother_GovIdType_ID = @Mother_GovIdType_ID
						,Mother_GovIdDetail = @Mother_GovIdDetail
						,Mother_ContactNo = @Mother_ContactNo
						,Father_FirstName = @Father_FirstName
						,Father_MiddleName = @Father_MiddleName
						,Father_LastName = @Father_LastName
						,Father_GovIdType_ID = @Father_GovIdType_ID
						,Father_GovIdDetail = @Father_GovIdDetail
						,Father_ContactNo = @Father_ContactNo
						,Gaurdian_FirstName = @Gaurdian_FirstName
						,Gaurdian_MiddleName = @Gaurdian_MiddleName
						,Gaurdian_LastName = @Gaurdian_LastName
						,Guardian_GovIdType_ID = @Guardian_GovIdType_ID
						,Guardian_GovIdDetail = @Guardian_GovIdDetail
						,Gaurdian_ContactNo = @Gaurdian_ContactNo
						,RBSKId = @RBSKId
						,SchoolName = @SchoolName
						,SchoolAddress1 = @SchoolAddress1
						,SchoolAddress2 = @SchoolAddress2
						,SchoolAddress3 = @SchoolAddress3
						,SchoolPincode = @SchoolPincode
						,SchoolCity = @SchoolCity
						,SchoolState = @SchoolState
						,Standard = @Standard
						,Section = @Section
						,RollNo = @RollNo
						,UpdatedBy = @UpdatedBy
						,UpdatedOn = GETDATE()
				WHERE UniqueSubjectID = @UniqueSubjectID
				SET @Scope_output = 1
			END
		END
		ELSE
		BEGIN		
			SET @Scope_output = -1
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

