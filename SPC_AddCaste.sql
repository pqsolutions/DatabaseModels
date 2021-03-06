--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddCaste' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddCaste
END
GO
CREATE procedure [dbo].[SPC_AddCaste]
(	
	@Castename VARCHAR(100)
	,@Isactive  BIT
	,@Comments VARCHAR(150)
	,@Createdby INT
	,@Updatedby INT
) As
DECLARE
	@FCount INT
	,@ID INT
	,@tempUserId INT
BEGIN
	BEGIN TRY
		IF @Castename IS NOT NULL
		BEGIN
			SELECT @FCount =  COUNT(ID) FROM Tbl_CasteMaster WHERE Castename = @Castename
			SELECT @ID =  ID FROM Tbl_CasteMaster WHERE Castename = @Castename
			IF(@FCount <= 0)
			BEGIN
				insert INTO Tbl_CasteMaster (
					Castename
					,Isactive
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				) 
				VALUES(
				@Castename
				,@Isactive
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				SELECT 'Caste added successfully' AS Msg
			END
			ELSE
			BEGIN
				UPDATE Tbl_CasteMaster SET 
				Isactive = @Isactive
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				WHERE ID = @ID
				SELECT 'Caste updated successfully' AS Msg
			END
		END
		ELSE
		BEGIN
			SELECT 'Caste is missing' AS Msg
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
