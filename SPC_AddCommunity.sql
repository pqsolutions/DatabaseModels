--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddCommunity' AND [type] = 'p')
 BEGIN
	DROP PROCEDURE SPC_AddCommunity
 END
GO
CREATE PROCEDURE [dbo].[SPC_AddCommunity]
(	
	@CasteID INT
	,@Communityname VARCHAR(100)
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
	 BEGIN  TRY
		IF @Communityname IS NOT NULL
		 BEGIN
			SELECT @FCount =  COUNT(ID) FROM Tbl_CommunityMaster WHERE CommunityName = @CommunityName
			SELECT @ID =  ID FROM Tbl_CommunityMaster WHERE CommunityName = @Communityname
			IF(@FCount <= 0)
			 BEGIN
				INSERT INTO Tbl_CommunityMaster (
					CasteID
					,Communityname
					,Isactive
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				) 
				VALUES(
				@CasteID
				,@Communityname
				,@Isactive
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				SELECT 'Community added successfully' AS Msg
			 END
			ELSE
			 BEGIN
				UPDATE Tbl_CommunityMaster SET 
				CasteID = @CasteID
				,Isactive = @Isactive
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				WHERE ID = @ID
				SELECT 'Community updated successfully' AS Msg
			 END
		 END
		ELSE
		 BEGIN
			SELECT 'Community is missing' AS Msg
		 END
	 END  TRY
	 BEGIN  CATCH
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
	 END  CATCH
 END
