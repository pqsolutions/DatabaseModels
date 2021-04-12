--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_SA_AddDistrict' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_SA_AddDistrict
END
GO
CREATE PROCEDURE [dbo].[SPC_SA_AddDistrict] 
(	
	@District_gov_code VARCHAR(50)
	,@Districtname VARCHAR(100)
	,@StateID INT
	,@Comments VARCHAR(150)
	,@UserId INT
	
) AS
BEGIN
	BEGIN TRY
		IF @Districtname != '' OR @Districtname IS  NOT NULL 
		BEGIN
			IF NOT EXISTS (SELECT   1 FROM Tbl_DistrictMaster WHERE DistrictName= @Districtname AND StateID = @StateID)
			BEGIN
				INSERT INTO Tbl_DistrictMaster (
					District_gov_code
					,StateID
					,Districtname
					,Isactive
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				) 
				VALUES(
				@District_gov_code
				,@StateID
				,@Districtname
				,1
				,@Comments
				,@UserId
				,@UserId
				,GETDATE()
				,GETDATE()
				)
				SELECT (@Districtname + ' - District added successfully') AS Msg
			END
			ELSE
			BEGIN
				SELECT (@Districtname + ' - District already exists') AS Msg
			END
		END
		ELSE
		BEGIN
			SELECT 'District Name is missing' AS Msg
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
