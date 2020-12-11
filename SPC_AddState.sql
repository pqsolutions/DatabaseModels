--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddState' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddState
END
GO
CREATE PROCEDURE [dbo].[SPC_AddState] 
(	
	@State_gov_code VARCHAR(50)
	,@Statename VARCHAR(100)
	,@Shortname VARCHAR(10)
	,@Isactive  Bit
	,@Comments VARCHAR(150)
	,@Createdby INT
	,@Updatedby INT
) AS
DECLARE
	@stateCount INT
	
BEGIN
	BEGIN TRY
		IF @State_gov_code != '' OR @State_gov_code IS NOT NULL 
		BEGIN
			SELECT @stateCount =  COUNT(ID) FROM Tbl_StateMaster WHERE State_gov_code= @State_gov_code
			IF(@stateCount <= 0)
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
				,@Isactive
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				SELECT 'State added successfully' AS Msg
			END
			ELSE
			BEGIN
				UPDATE Tbl_StateMaster SET 
				State_gov_code = @State_gov_code
				,Statename = @Statename
				,Shortname=@Shortname
				,Isactive = @Isactive
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				WHERE State_gov_code = @State_gov_code
				SELECT 'State updated successfully' AS Msg
			END
		END
		ELSE
		BEGIN
			SELECT 'State code is missing' AS Msg
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
