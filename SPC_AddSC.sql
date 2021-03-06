USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_AddSC]    Script Date: 03/25/2020 23:55:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (Select 1 from sys.objects where name='SPC_AddSC' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_AddSC
End
GO
CREATE procedure [dbo].[SPC_AddSC]
(	
	@CHCID int
	,@PHCID int
	,@HNIN_ID varchar(200)
	,@SC_gov_code varchar(50)	
	,@SCname varchar(100)
	,@SCAddress varchar(500)
	,@Pincode Varchar(100)
	,@Isactive  Bit
	,@Latitude varchar(150)
	,@Longitude varchar(150)
	,@Comments varchar(150)
	,@Createdby int
	,@Updatedby int
) As
Declare
	@scCount int
	,@ID int
	,@tempUserId int
Begin
	Begin try
		If @SC_gov_code != '' or  @SC_gov_code is not null
		Begin
			select @scCount =  count(ID) from Tbl_SCMaster where SC_gov_code= @SC_gov_code
			select @ID= ID from Tbl_SCMaster where SC_gov_code= @SC_gov_code
			if(@scCount <= 0)
			Begin
				insert into Tbl_SCMaster (
					CHCID
					,PHCID
					,SC_gov_code					
					,SCname	
					,SCAddress 
					,Pincode				
					,HNIN_ID
					,Isactive
					,Latitude
					,Longitude
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				) 
				values(
				@CHCID
				,@PHCID
				,@SC_gov_code				
				,@SCname
				,@SCAddress 
				,@Pincode
				,@HNIN_ID
				,@Isactive
				,@Latitude
				,@Longitude
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				SELECT 'SC added successfully' AS Msg
			End
			else
			Begin
				Update Tbl_SCMaster set 
				CHCID = @CHCID
				,PHCID = @PHCID								
				,SC_gov_code = @SC_gov_code				
				,SCname = @SCname
				,SCAddress = @SCAddress 
				,Pincode = @Pincode
				,HNIN_ID = @HNIN_ID
				,Isactive = @Isactive
				,Latitude = @Latitude
				,Longitude = @Longitude
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				where ID = @ID
				SELECT 'SC updated successfully' AS Msg
			End
		End
		else
		Begin
			SELECT 'SC Gov code is missing' AS Msg
		End
	End try
	Begin catch
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
	End catch
End
