USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Sample collection which are not generated the Shipment Id of particular ANM user /CHC

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSampleCollection' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSampleCollection
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSampleCollection] 
(
	@UserID INT
	,@RegisteredFrom VARCHAR(10)
)
AS
BEGIN
	DECLARE @RegisterFrom INT,@CHCID INT
	SET @RegisterFrom = (SELECT ID FROM Tbl_ConstantValues WHERE CommonName = @RegisteredFrom AND comments='RegisterFrom')
	SET @CHCID = (SELECT CHCID FROM Tbl_UserMaster WHERE ID = @UserID)
	IF @RegisteredFrom = 'ANM'
	BEGIN 
		SELECT SC.[SubjectID]
		  ,SC.[UniqueSubjectID]
		  ,SC.[ID] AS SampleCollectionID
		  ,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
		  ,SPR.[RCHID] 
		  ,SC.[BarcodeNo]
		  ,(CONVERT(VARCHAR,SC.[SampleCollectionDate],105) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime])) AS SampleDateTime
		   FROM Tbl_SampleCollection SC
		   LEFT JOIN Tbl_SubjectPrimaryDetail SP WITH (NOLOCK) ON SP.ID = SC.SubjectID
		   LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPR.SubjectID = SP.ID
		   WHERE SC.CollectedBy = @UserID AND SP.RegisteredFrom = @RegisterFrom AND SC.ID NOT IN (SELECT SampleCollectionID from Tbl_ANMCHCShipment)
    END
    ELSE IF @RegisteredFrom = 'CHC'
    BEGIN
		SELECT SC.[SubjectID]
		  ,SC.[UniqueSubjectID]
		  ,SC.[ID] AS SampleCollectionID
		  ,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
		  ,SPR.[RCHID] 
		  ,SC.[BarcodeNo]
		  ,(CONVERT(VARCHAR,SC.[SampleCollectionDate],105) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime])) AS SampleDateTime
		   FROM Tbl_SampleCollection SC
		   LEFT JOIN Tbl_SubjectPrimaryDetail SP WITH (NOLOCK) ON SP.ID = SC.SubjectID
		   LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPR.SubjectID = SP.ID
		   WHERE SP.CHCID = @CHCID AND SP.RegisteredFrom = @RegisterFrom AND SC.ID NOT IN (SELECT SampleCollectionID from Tbl_ANMCHCShipment)
    END
END
