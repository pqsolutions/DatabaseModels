USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_PostPNDTCounsellingStatusMobileTracking' AND [type] = 'FN')
BEGIN
	DROP FUNCTION FN_PostPNDTCounsellingStatusMobileTracking
END
GO
CREATE FUNCTION [dbo].[FN_PostPNDTCounsellingStatusMobileTracking]   
(
	@SubjectID VARCHAR(250)
	
) 
RETURNS VARCHAR(MAX)        
AS    
BEGIN
	DECLARE
		@Decision  VARCHAR(MAX)
		,@CounsellingDate DATETIME
		,@AgreeYes BIT
		,@AgreeNo BIT
		,@AgreePending BIT
		SELECT @CounsellingDate = PS.[CounsellingDateTime] , @AgreeYes = PC.[IsMTPTestdAgreedYes] ,  @AgreeNo = PC.[IsMTPTestdAgreedNo] , @AgreePending = PC.[IsMTPTestdAgreedPending]
		FROM Tbl_PostPNDTCounselling PC 
		LEFT JOIN Tbl_PostPNDTScheduling PS WITH (NOLOCK) ON PS.[ANWSubjectId] = PC.[ANWSubjectId]
		WHERE PC.[ANWSubjectId] = @SubjectID

		IF @AgreeYes = 1
		BEGIN
			SET @Decision = (CONVERT(VARCHAR,@CounsellingDate,103) + ' ' +CONVERT(VARCHAR(5),@CounsellingDate,108)) + ' , MTP Decision (Agreed): Yes' 
		END
		ELSE IF @AgreeNo = 1
		BEGIN
			SET @Decision = (CONVERT(VARCHAR,@CounsellingDate,103) + ' ' +CONVERT(VARCHAR(5),@CounsellingDate,108)) + ' , MTP Decision (Agreed): No' 
		END
		ELSE IF @AgreePending = 1
		BEGIN
			SET @Decision = (CONVERT(VARCHAR,@CounsellingDate,103) + ' ' +CONVERT(VARCHAR(5),@CounsellingDate,108)) + ' , MTP Decision (Agreed): Pending' 
		END
	RETURN 	@Decision
END