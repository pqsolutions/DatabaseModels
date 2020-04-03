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
	@SubjectTypeID  INT
	,@UniqueSubjectID VARCHAR(200)
	,@Mother_FirstName VARCHAR(150)
	,@Mother_MiddleName VARCHAR(150)
	,@Mother_LastName VARCHAR(150)
	,@Mother_UniquetID VARCHAR(200)
	,@Mother_ContactNo VARCHAR(150)
	,@Father_FirstName VARCHAR(150)
	,@Father_MiddleName VARCHAR(150)
	,@Father_LastName VARCHAR(150)
	,@Father_UniquetID VARCHAR(200)
	,@Father_ContactNo VARCHAR(150)
	,@Gaurdian_FirstName VARCHAR(150)
	,@Gaurdian_MiddleName VARCHAR(150)
	,@Gaurdian_LastName VARCHAR(150)
	,@Gaurdian_ContactNo VARCHAR(150)
	,@RBSKId VARCHAR(150)
	,@SchoolName VARCHAR(150)
	,@SchoolAddress1 VARCHAR(250)
	,@SchoolAddress2 VARCHAR(250)
	,@SchoolAddress3 VARCHAR(250)
	,@SchoolPincode VARCHAR(250)
	,@SchoolCity VARCHAR(200)
	,@SchoolState  INT
	,@Standard VARCHAR(10)
	,@Section VARCHAR(5)
	,@RollNo VARCHAR(50)
	,@UpdatedBy  INT
	,@Scope_output INT OUTPUT
) AS
DECLARE
	@SubCount INT
	,@tempUserId INT
BEGIN
	BEGIN TRY
		IF @uniqueSubjectId = '' OR @uniqueSubjectId is NULL
		BEGIN
			SELECT @SubCount =  count(ID) from Tbl_SubjectParentDetail where UniqueSubjectID = @UniqueSubjectID
			IF (@SubCount <= 0) 
			BEGIN
				INSERT INTO [dbo].[Tbl_SubjectParentDetail]
					(SubjectTypeID
					,UniqueSubjectID
					,Mother_FirstName
					,Mother_MiddleName
					,Mother_LastName
					,Mother_UniquetID
					,Mother_ContactNo
					,Father_FirstName
					,Father_MiddleName
					,Father_LastName
					,Father_UniquetID
					,Father_ContactNo
					,Gaurdian_FirstName
					,Gaurdian_MiddleName
					,Gaurdian_LastName
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
					(@SubjectTypeID  
					,@UniqueSubjectID 
					,@Mother_FirstName 
					,@Mother_MiddleName 
					,@Mother_LastName 
					,@Mother_UniquetID 
					,@Mother_ContactNo 
					,@Father_FirstName 
					,@Father_MiddleName 
					,@Father_LastName 
					,@Father_UniquetID 
					,@Father_ContactNo 
					,@Gaurdian_FirstName 
					,@Gaurdian_MiddleName 
					,@Gaurdian_LastName 
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
				   SET SubjectTypeID = @SubjectTypeID
						,Mother_FirstName = @Mother_FirstName
						,Mother_MiddleName = @Mother_MiddleName
						,Mother_LastName = @Mother_LastName
						,Mother_UniquetID = @Mother_UniquetID
						,Mother_ContactNo = @Mother_ContactNo
						,Father_FirstName = @Father_FirstName
						,Father_MiddleName = @Father_MiddleName
						,Father_LastName = @Father_LastName
						,Father_UniquetID = @Father_UniquetID
						,Father_ContactNo = @Father_ContactNo
						,Gaurdian_FirstName = @Gaurdian_FirstName
						,Gaurdian_MiddleName = @Gaurdian_MiddleName
						,Gaurdian_LastName = @Gaurdian_LastName
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

