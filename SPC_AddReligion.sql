--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddReligion' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddReligion
END
GO
CREATE PROCEDURE [dbo].[SPC_AddReligion]
(	
	@Religionname VARCHAR(100)
	,@Isactive  BIT
	,@Comments VARCHAR(150)
	,@Createdby INT
	,@Updatedby INT
) AS
DECLARE
	@FCount INT
	,@ID INT
	,@tempUserId INT
BEGIN
	BEGIN TRY
		IF @Religionname IS NOT NULL
		BEGIN
			SELECT @FCount =  COUNT(ID) FROM Tbl_ReligionMaster WHERE Religionname = @Religionname
			SELECT @ID =  ID FROM Tbl_ReligionMaster WHERE Religionname = @Religionname
			IF(@FCount <= 0)
			BEGIN
				INSERT INTO Tbl_ReligionMaster (
					Religionname
					,Isactive
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				) 
				VALUES(
				@Religionname
				,@Isactive
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				SELECT 'Religion added successfully' AS Msg
			END
			ELSE
			BEGIN
				UPDATE Tbl_ReligionMaster SET 
				Religionname = @Religionname
				,Isactive = @Isactive
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				WHERE ID = @ID
				SELECT 'Religion updated successfully' AS Msg
			END
		END
		ELSE
		BEGIN
			SELECT 'Religion is missing' AS Msg
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
End
