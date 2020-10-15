


USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_FindResult' AND [type] = 'FN')
BEGIN
	DROP FUNCTION [dbo].[FN_FindResult]
END
GO
CREATE FUNCTION [dbo].[FN_FindResult]     
(  
 @SubjectID VARCHAR(MAX)
 ,@ResultType VARCHAR(50)   
)   
RETURNS VARCHAR(MAX)          
AS      
BEGIN  
	DECLARE  
		@Result VARCHAR(MAX)
		,@Count INT
		,@Check BIT
		,@HPLCResult VARCHAR(MAX)
		  
	IF @ResultType = 'CBC'
	BEGIN
		SELECT @Count = Count(UniqueSubjectID) FROM Tbl_CBCTestResult WHERE UniqueSubjectID = @SubjectID
		IF @Count > 0
		BEGIN
			SELECT TOP 1  @Result = ISNULL(CBCResult,'') FROM Tbl_CBCTestResult WHERE UniqueSubjectID = @SubjectID ORDER BY ID DESC
		END
		ELSE
		BEGIN
			SET @Result = ''
		END
	END
	ELSE IF	  @ResultType = 'SST'
	BEGIN
		SELECT @Count = Count(UniqueSubjectID) FROM Tbl_SSTestResult WHERE UniqueSubjectID = @SubjectID
		IF @Count > 0
		BEGIN
			SELECT TOP 1  @Check = IsPositive FROM Tbl_SSTestResult WHERE UniqueSubjectID = @SubjectID ORDER BY ID DESC
			IF @Check = 1 
			BEGIN
				SET @Result = 'Positive'
			END
			ELSE
			BEGIN
				SET @Result = 'Negative'
			END
		END
		ELSE
		BEGIN
				SET @Result = ''
		END
	END
	ELSE IF @ResultType = 'HPLC'
	BEGIN
		--SELECT @Count = Count(UniqueSubjectID) FROM Tbl_HPLCTestResult WHERE UniqueSubjectID = @SubjectID
		--IF @Count > 0
		--BEGIN
		--	SELECT TOP 1  @Check = IsPositive, @HPLCResult = ISNULL(HPLCResult,'') FROM Tbl_HPLCTestResult WHERE UniqueSubjectID = @SubjectID ORDER BY ID DESC
		--	IF @Check = 1 
		--	BEGIN
		--		SET @Result = @HPLCResult
		--	END
		--	ELSE
		--	BEGIN
		--		SET @Result = @HPLCResult
		--	END
		--END
		--ELSE
		--BEGIN
		--	SET @Result = ''
		--END

		SELECT @Count = Count(UniqueSubjectID) FROM Tbl_HPLCDiagnosisResult WHERE UniqueSubjectID = @SubjectID
		IF @Count > 0
		BEGIN
			SELECT TOP 1  @Check = IsNormal  FROM Tbl_HPLCDiagnosisResult WHERE UniqueSubjectID = @SubjectID ORDER BY ID DESC
			IF @Check = 1 
			BEGIN
				SET @Result = 'Normal'
			END
			ELSE
			BEGIN
				SET @Result = 'Abnormal'
			END
		END
		ELSE
		BEGIN
			SET @Result = ''
		END

	END
  
 RETURN  @Result  
END