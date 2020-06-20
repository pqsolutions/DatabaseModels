USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----Fetch Details of particular subject for sample collection

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchANMCHCSampleSubjectDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchANMCHCSampleSubjectDetail
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchANMCHCSampleSubjectDetail]
(	
	@UniqueSubjectId VARCHAR(200)
	,@SampleType VARCHAR(5)
)
AS
DECLARE 
	@Reason VARCHAR(100)
	,@Damaged BIT
	,@Timeout BIT
BEGIN
	IF @SampleType = 'F'
	BEGIN
		SET @Reason = 'First Time Collection'
	END 
	ELSE IF @SampleType = 'R'
	BEGIN
		SET @Damaged = (SELECT TOP 1 SampleDamaged  FROM Tbl_SampleCollection ORDER BY ID DESC)
		SET @Timeout = (SELECT TOP 1 SampleTimeoutExpiry   FROM Tbl_SampleCollection ORDER BY ID DESC)
		IF @Damaged = 1 AND @Timeout = 1
		BEGIN
			SET @Reason = 'Damaged Sample'
		END
		ELSE IF @Damaged = 1 AND @Timeout = 0
		BEGIN
			SET @Reason = 'Damaged Sample'
		END
		ELSE IF @Damaged = 0 AND @Timeout = 1
		BEGIN
			SET @Reason = 'Sample Timeout'
		END
	END
	SELECT SP.[UniqueSubjectID] 
		   ,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
		   ,SPR.[RCHID]
		   ,@Reason AS Reason
	FROM  Tbl_SubjectPrimaryDetail SP
	LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPR.UniqueSubjectID  = SP.UniqueSubjectID 	
	WHERE SP.[UniqueSubjectID]   = @UniqueSubjectId 
END
