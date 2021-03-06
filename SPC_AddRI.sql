USE [Eduquaydb]
GO
/****** Object:  StoredPROCEDURE [dbo].[SPC_AddRI]    Script Date: 03/25/2020 23:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddRI' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddRI
END
GO
CREATE PROCEDURE [dbo].[SPC_AddRI]
(	
	@TestingCHCID INT
	,@CHCID INT
	,@PHCID INT
	,@SCID INT
	,@RI_gov_code VARCHAR(50)	
	,@RIsite VARCHAR(100)
	,@Pincode VARCHAR(100)
	,@ILRID INT
	,@Isactive  bit
	,@Latitude VARCHAR(150)
	,@Longitude VARCHAR(150)
	,@Comments VARCHAR(150)
	,@Createdby INT
	,@Updatedby INT
) As
DECLARE
	@riCount INT
	,@ID INT
	,@tempUserId INT
BEGIN
	BEGIN TRY
		IF  @RI_gov_code != '' OR @RI_gov_code IS NOT NULL
		BEGIN
			SELECT @riCount =  count(ID) FROM Tbl_RIMaster WHERE RI_gov_code = @RI_gov_code
			SELECT @ID= ID FROM Tbl_RIMaster WHERE RI_gov_code= @RI_gov_code
			if(@riCount <= 0)
			BEGIN
				INSERT INTO Tbl_RIMaster (
				    TestingCHCID
				    ,CHCID
					,PHCID
					,SCID
					,RI_gov_code					
					,RIsite	
					,Pincode
					,ILRID		
					,Isactive
					,Latitude
					,Longitude
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				)
				VALUES(
				@TestingCHCID
				,@CHCID
				,@PHCID
				,@SCID
				,@RI_gov_code				
				,@RIsite
				,@Pincode
				,@ILRID
				,@Isactive
				,@Latitude
				,@Longitude
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				SELECT 'RI added successfully' AS Msg
			END
			ELSE
			BEGIN
				UPDATE Tbl_RIMaster SET 
				TestingCHCID = @TestingCHCID
				,CHCID = @CHCID 
				,PHCID = @PHCID
				,SCID = @SCID								
				,RI_gov_code = @RI_gov_code				
				,RIsite = @RIsite
				,Pincode = @Pincode
				,ILRID = @ILRID
				,Isactive = @Isactive
				,Latitude = @Latitude
				,Longitude = @Longitude
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				WHERE ID = @ID
				SELECT 'RI updated successfully' AS Msg
			END
		END
		ELSE
		BEGIN
			SELECT 'RI Gov code is missing' AS Msg
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
