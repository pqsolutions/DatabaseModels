--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_SA_UpdateState' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_SA_UpdateState
END
GO
CREATE PROCEDURE [dbo].[SPC_SA_UpdateState] 
(	
	@Id INT
	,@State_gov_code VARCHAR(50)
	,@Statename VARCHAR(100)
	,@Shortname VARCHAR(10)
	,@Isactive BIT
	,@Comments VARCHAR(150)
	,@UserId INT
	
) AS
BEGIN
	BEGIN TRY
		IF @Statename != '' OR @Statename IS NOT NULL 
		BEGIN
			IF  EXISTS (SELECT   1 FROM Tbl_StateMaster WHERE Id= @Id)
			BEGIN
				UPDATE Tbl_StateMaster SET 
				State_gov_code = @State_gov_code
				,Statename = @Statename
				,Shortname=@Shortname
				,Isactive = @Isactive
				,Comments = @Comments
				,Updatedby = @UserId
				,Updatedon = GETDATE()
				WHERE ID = @Id
				SELECT ('State details updated successfully') AS Msg
			END
			ELSE
			BEGIN
				SELECT ('Please select valid state') AS Msg
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
