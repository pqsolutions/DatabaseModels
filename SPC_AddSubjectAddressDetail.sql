USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (Select 1 from sys.objects where name='SPC_AddSubjectAddressDetail' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_AddSubjectAddressDetail
End
GO
CREATE PROCEDURE [dbo].[SPC_AddSubjectAddressDetail]
(
	@SubjectID  INT	
	,@Religion_Id INT
	,@Caste_Id INT
	,@Community_Id INT
	,@Address1 VARCHAR(150)
	,@Address2 VARCHAR(150)
	,@Address3 VARCHAR(150)
	,@Pincode  VARCHAR(150)
	,@UpdatedBy INT
	,@Scope_output INT OUTPUT
) AS
DECLARE
	@SubCount INT
	,@UniqueSubjectID VARCHAR(250)
	,@tempUserId INT
BEGIN
	BEGIN TRY
		IF  @SubjectID IS NOT NULL
		BEGIN
			SELECT @SubCount =  count(ID) FROM Tbl_SubjectAddressDetail WHERE SubjectID = @SubjectID
			SELECT @UniqueSubjectID =   UniqueSubjectID FROM Tbl_SubjectPrimaryDetail WHERE ID = @SubjectID
			IF (@SubCount <= 0) 
			BEGIN
				INSERT INTO [dbo].[Tbl_SubjectAddressDetail]
						   (SubjectID
						   ,UniqueSubjectID
						   ,Religion_Id
						   ,Caste_Id
						   ,Community_Id
						   ,Address1
						   ,Address2
						   ,Address3
						   ,Pincode
						   ,UpdatedBy
						   ,UpdatedOn)
					 VALUES
						   (@SubjectID
						   ,@UniqueSubjectID
						   ,@Religion_Id
						   ,@Caste_Id
						   ,@Community_Id
						   ,@Address1
						   ,@Address2
						   ,@Address3
						   ,@Pincode
						   ,@UpdatedBy
						   ,GETDATE())
				SET @tempUserId = IDENT_CURRENT('Tbl_SubjectAddressDetail')
				SET @Scope_output = 1
			END
			ELSE 
			BEGIN
				UPDATE [dbo].[Tbl_SubjectAddressDetail]
				   SET Religion_Id = @Religion_Id
					  ,Caste_Id = @Caste_Id
					  ,Community_Id = @Community_Id
					  ,Address1 = @Address1
					  ,Address2 = @Address2
					  ,Address3 = @Address3
					  ,Pincode = @Pincode
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

