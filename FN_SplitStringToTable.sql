USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_SplitStringToTable' AND [type] = 'FN')
BEGIN
	DROP FUNCTION FN_SplitStringToTable
END
GO

CREATE FUNCTION [dbo].[FN_SplitStringToTable]
(
	@csv NVARCHAR (4000)
	,@Delimiter NVARCHAR (10)
 )
RETURNS @returnValue TABLE ([Item] NVARCHAR(4000))
BEGIN
	DECLARE @NextValue NVARCHAR(4000)
			,@Position INT
			,@NextPosition INT
			,@comma NVARCHAR(1) 
	SET @NextValue = ''
	SET @comma = right(@csv,1)  
	SET @csv = @csv + @Delimiter 
	SET @Position = charindex(@Delimiter,@csv)
	SET @NextPosition = 1 
	WHILE (@Position <>  0)  
	BEGIN
		SET @NextValue = substring(@csv,1,@Position - 1) 
		INSERT INTO @returnValue ( [Item]) VALUES (@NextValue) 
		SET @csv = substring(@csv,@Position +1,len(@csv))  
		SET @NextPosition = @Position
		SET @Position  = charindex(@Delimiter,@csv)
	END 
	RETURN
END
