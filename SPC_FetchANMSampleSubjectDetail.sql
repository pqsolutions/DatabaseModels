USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---Fetch the subject detail for particular damaged sample or timeout expiry sample


IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchANMSampleSubjectDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchANMSampleSubjectDetail
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchANMSampleSubjectDetail]
(	
	@ID INT,
	@Notification INT 
)
AS
DECLARE 
	@ReasonId INT
	,@Reason VARCHAR(100)
BEGIN
	IF @Notification = 1
	BEGIN
		SET @ReasonId = 1
		SET @Reason = (SELECT CommonName  FROM Tbl_ConstantValues WHERE ID = @ReasonId)
	END
	ELSE IF @Notification = 2
	BEGIN
		SET @ReasonId = 3
		SET @Reason = (SELECT CommonName  FROM Tbl_ConstantValues WHERE ID = @ReasonId)
	END
	SELECT SC.[SubjectID] 
		   ,SC.[UniqueSubjectID] 
		   ,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
		   ,@ReasonId AS ReasonId
		   ,@Reason AS Reason
	FROM [dbo].[Tbl_SampleCollection] SC
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP  WITH (NOLOCK) ON  SP.[ID] = SC.[SubjectID]
	WHERE SC.[ID]  = @ID
END
