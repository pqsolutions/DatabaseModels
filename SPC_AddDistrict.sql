--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddDistrict' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddDistrict
END
GO
CREATE PROCEDURE [dbo].[SPC_AddDistrict]
(	
	@District_gov_code VARCHAR(50)
	,@StateID INT
	,@Districtname VARCHAR(100)
	,@Isactive  BIT
	,@Comments VARCHAR(150)
	,@Createdby INT
	,@Updatedby INT
) AS
DECLARE
	@districtCount INT
	,@ID INT
	,@tempUserId INT
BEGIN
	BEGIN TRY
		IF @District_gov_code != '' OR @District_gov_code IS NOT NULL 		
		BEGIN
			SELECT @districtCount =  COUNT(ID) FROM Tbl_DistrictMaster WHERE District_gov_code= @District_gov_code
			SELECT @ID = ID FROM Tbl_DistrictMaster WHERE District_gov_code= @District_gov_code
			IF(@districtCount <= 0)
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
				,@Isactive
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				
				SELECT 'District added successfully' AS Msg
			END
			ELSE
			BEGIN
				UPDATE Tbl_DistrictMaster SET 
				District_gov_code = @District_gov_code
				,StateID=@StateID
				,Districtname = @Districtname
				,Isactive = @Isactive
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				WHERE ID = @ID
			END
			SELECT 'District updated successfully' AS Msg
		END
		ELSE
		BEGIN
			SELECT 'District Gov code is missing' AS Msg
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
