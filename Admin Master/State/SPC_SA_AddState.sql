--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_SA_AddState' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_SA_AddState
END
GO
CREATE PROCEDURE [dbo].[SPC_SA_AddState] 
(	
	@State_gov_code VARCHAR(50)
	,@Statename VARCHAR(100)
	,@Shortname VARCHAR(10)
	,@Comments VARCHAR(150)
	,@UserId INT
	
) AS
BEGIN
	BEGIN TRY
		IF @Statename != '' OR @Statename IS  NOT NULL 
		BEGIN
			IF NOT EXISTS (SELECT   1 FROM Tbl_StateMaster WHERE Statename= @Statename)
			BEGIN
				INSERT INTO Tbl_StateMaster (
					State_gov_code
					,Statename
					,Shortname
					,Isactive
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				) 
				VALUES(
				@State_gov_code
				,@Statename
				,@Shortname
				,1
				,@Comments
				,@UserId
				,@UserId
				,GETDATE()
				,GETDATE()
				)
				SELECT (@Statename + ' - State added successfully') AS Msg
			END
			ELSE
			BEGIN
				SELECT (@Statename + ' - State already exists') AS Msg
			END
		END
		ELSE
		BEGIN
			SELECT 'State Name is missing' AS Msg
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
