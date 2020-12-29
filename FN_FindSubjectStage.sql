

--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_FindSubjectStage' AND [type] = 'FN')
BEGIN
	DROP FUNCTION FN_FindSubjectStage
END
GO
CREATE FUNCTION [dbo].[FN_FindSubjectStage]   
(
	@SubjectId VARCHAR(250)
) 
RETURNS VARCHAR(MAX)        
AS    
BEGIN
	DECLARE
		@Result  VARCHAR(MAX),@CBCResult VARCHAR(200),@CBC BIT, @SSTResult VARCHAR(200),@SST BIT, @HPLCResult VARCHAR(MAX), @HPLCPathoResult VARCHAR(MAX), @HPLCLabDiagnosis VARCHAR(MAX), @IsDiagnosisComplete BIT,
		@IsSeniorPathoConsult BIT, @PrePNDTCounsellingResult VARCHAR(MAX), @PNDTResult VARCHAR(MAX), @PostPNDTCounsellingResult VARCHAR(MAX), @MTPStatus VARCHAR(MAX), @Status VARCHAR(50)

		IF EXISTS (SELECT 1 FROM Tbl_MTPTest WHERE ANWSubjectId = @SubjectId OR SpouseSubjectId = @SubjectId)
		BEGIN
			SET @Result= 'MTP Service'
		END
		ELSE IF EXISTS (SELECT 1 FROM Tbl_PostPNDTCounselling WHERE ANWSubjectId = @SubjectId OR SpouseSubjectId = @SubjectId)
		BEGIN
			SET @Result= 'Post PNDT Counselling'
		END
		ELSE IF EXISTS (SELECT 1 FROM Tbl_PNDTest WHERE ANWSubjectId = @SubjectId OR SpouseSubjectId = @SubjectId)
		BEGIN
			SET @Result= 'PNDT Test'
		END
		ELSE IF EXISTS (SELECT 1 FROM Tbl_PostPNDTCounselling WHERE ANWSubjectId = @SubjectId OR SpouseSubjectId = @SubjectId)
		BEGIN
			SET @Result= 'Pre PNDT Counselling'
		END
		ELSE IF EXISTS (SELECT 1 FROM Tbl_HPLCDiagnosisResult WHERE UniqueSubjectID = @SubjectId)
		BEGIN
			SELECT @IsDiagnosisComplete = IsDiagnosisComplete, @IsSeniorPathoConsult = IsConsultSeniorPathologist FROM Tbl_HPLCDiagnosisResult WHERE UniqueSubjectID = @SubjectId
			IF @IsDiagnosisComplete = 1
			BEGIN
				SELECT @HPLCLabDiagnosis = LabDiagnosis, @HPLCPathoResult = HPLCResult  FROM Tbl_HPLCTestResult  WHERE UniqueSubjectID = @SubjectId
				SET @Result= 'HPLC Patho Diagnosis Completed. ( ' + @HPLCPathoResult +' )'
			END 
			ELSE IF @IsDiagnosisComplete = 0 AND @IsSeniorPathoConsult = 1
			BEGIN
				SET @Result= 'HPLC Patho Diagnosis - waiting for senior patho consultation'
			END
			ELSE IF @IsDiagnosisComplete = 0 AND @IsSeniorPathoConsult = 0
			BEGIN
				SET @Result= 'HPLC Patho Diagnosis Pending'
			END
		END
		ELSE IF EXISTS (SELECT 1 FROM Tbl_HPLCTestResult WHERE UniqueSubjectID = @SubjectId)
		BEGIN
			SET @Result= 'HPLC System Test Completed'
		END
		ELSE IF EXISTS (SELECT 1 FROM Tbl_CHCShipmentsDetail WHERE UniqueSubjectID = @SubjectId)
		BEGIN
			SET @Result= 'Shipment From CHC to Central Lab'
		END
		ELSE IF EXISTS (SELECT 1 FROM Tbl_CBCTestResult WHERE UniqueSubjectID = @SubjectId)
		BEGIN
			SELECT TOP 1 @CBCResult = CBCResult, @CBC=IsPositive FROM Tbl_CBCTestResult WHERE UniqueSubjectID = @SubjectId ORDER BY ID DESC
			
			IF EXISTS (SELECT 1 FROM Tbl_SSTestResult WHERE UniqueSubjectID = @SubjectId)
			BEGIN
				SELECT TOP 1 @SST = IsPositive FROM Tbl_SSTestResult WHERE UniqueSubjectID = @SubjectId ORDER BY ID DESC
				IF @SST = 1
				BEGIN 
					SET @SSTResult = 'SST Positive'
				END
				ELSE
				BEGIN
					SET @SSTResult = 'SST Negative'
				END
				SET @Status = ''
				IF @SST= 0 AND @CBC = 0
				BEGIN
					SET @Status = '(Status: END)'
				END
				SET @Result= 'CBC and SST Test Completed. ('+ @CBCResult + ' & '+@SSTResult+'). '+@Status
			END
			ELSE
			BEGIN
				SET @Result= 'CBC Test Completed, Waiting for SST. ('+ @CBCResult + ')'
			END
		END
		ELSE IF EXISTS (SELECT 1 FROM Tbl_SSTestResult WHERE UniqueSubjectID = @SubjectId)
		BEGIN
			SELECT TOP 1 @SST = IsPositive FROM Tbl_SSTestResult WHERE UniqueSubjectID = @SubjectId ORDER BY ID DESC
			IF @SST = 1
			BEGIN 
				SET @SSTResult = 'SST Positive'
			END
			ELSE
			BEGIN
				SET @SSTResult = 'SST Negative'
			END
			IF EXISTS (SELECT 1 FROM Tbl_CBCTestResult WHERE UniqueSubjectID = @SubjectId)
			BEGIN
				SELECT TOP 1 @CBCResult = CBCResult, @CBC=IsPositive FROM Tbl_CBCTestResult WHERE UniqueSubjectID = @SubjectId ORDER BY ID DESC
				SET @Status = ''
				IF @SST= 0 AND @CBC = 0
				BEGIN
					SET @Status = '(Status: END)'
				END

				SET @Result= 'CBC and SST Test Completed. ('+ @CBCResult + ' & '+@SSTResult+'). '+@Status
			END
			ELSE
			BEGIN
				SET @Result= 'SST Test Completed, Waiting for CBC. ('+ @SSTResult + ')'
			END
		END
		ELSE IF EXISTS (SELECT 1 FROM Tbl_ANMCHCShipmentsDetail WHERE UniqueSubjectID = @SubjectId)
		BEGIN
			SET @Result= 'Shipment From ANM/CHC to Testing CHC'
		END
		ELSE IF EXISTS (SELECT 1 FROM Tbl_SampleCollection WHERE UniqueSubjectID = @SubjectId)
		BEGIN
			SET @Result= 'Sampling'
		END
		ELSE IF EXISTS (SELECT 1 FROM Tbl_SubjectPrimaryDetail WHERE UniqueSubjectID = @SubjectId AND ID IN(SELECT SubjectID FROM Tbl_SubjectParentDetail))
		BEGIN
			SET @Result= 'Registration'
		END
		ELSE
		BEGIN
			SET @Result= 'Invalid UniqueSubjectId'
		END
	RETURN 	@Result
END