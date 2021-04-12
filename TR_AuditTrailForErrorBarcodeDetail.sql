
GO
/****** Object:  Trigger [dbo].[TR_AuditTrailForErrorBarcodeDetail]    Script Date: 23-03-2021 09:10:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[TR_AuditTrailForErrorBarcodeDetail] ON [dbo].[Tbl_ErrorBarcodeDetail] FOR UPDATE,INSERT
AS
    
    DECLARE @bit INT ,
           @field INT ,
           @maxfield INT ,
           @char INT ,
           @fieldname VARCHAR(MAX) ,
           @TableName VARCHAR(MAX) ,
           @PKCols VARCHAR(1000) ,
		   @PKFieldName VARCHAR(MAX),
		   @PKValue VARCHAR(MAX),
           @sql VARCHAR(MAX), 
           @UpdateDate VARCHAR(1000),
           @Type CHAR(1) ,
           @PKSelect VARCHAR(MAX),
		   @UpdatedBy VARCHAR(100)

	--You will need to change @TableName to match the table to be audited. 
    SELECT @TableName = 'Tbl_ErrorBarcodeDetail'
   
   -- date 
    SELECT  @UpdateDate = CONVERT (NVARCHAR(30),GETDATE(),126)      
    
	
	IF EXISTS (SELECT * FROM inserted)
	BEGIN
		IF EXISTS (SELECT * FROM deleted)
		BEGIN
			SELECT @Type = 'U'
			SELECT @UpdatedBy = updatedby from Inserted
		END
		ELSE
		BEGIN
			SELECT @Type = 'I'
			SELECT @UpdatedBy = updatedby from Inserted
		END
	END
	ELSE
	BEGIN
		SELECT @Type = 'D'
	END

	-- get list of columns
    SELECT * INTO #ins FROM inserted
    SELECT * INTO #del FROM deleted

	 -- Get primary key columns, Primary Key Selected Field Values, Primary Key ColumnName, Primary key values  for full outer join
	SELECT @PKCols = COALESCE(@PKCols + ' and', ' on') + ' i.' + c.COLUMN_NAME + ' = d.' + c.COLUMN_NAME,
		   @PKSelect = COALESCE(@PKSelect+'+','') + '''<' + COLUMN_NAME + '=''+convert(varchar(100),coalesce(i.' + COLUMN_NAME + ',d.' + COLUMN_NAME + '))+''>''' ,
		   @PKFieldName = COLUMN_NAME,
		   @PKValue = '''+convert(varchar(100), coalesce(i.' + COLUMN_NAME +',d.' + COLUMN_NAME + '))+'''
	FROM    INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk, INFORMATION_SCHEMA.KEY_COLUMN_USAGE c
	WHERE   pk.TABLE_NAME = @TableName
	AND     CONSTRAINT_TYPE = 'PRIMARY KEY'
	AND     c.TABLE_NAME = pk.TABLE_NAME
	AND     c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME
    
	PRINT @PKValue
	PRINT @PKFieldName
	PRINT @UpdatedBy

	IF @PKCols IS NULL
    BEGIN
		RAISERROR('no PK on table %s', 16, -1, @TableName)
        RETURN
    END

	SELECT @field = 0, @maxfield = MAX(ORDINAL_POSITION) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName
	
	WHILE @field < @maxfield
    BEGIN
		SELECT @field = MIN(ORDINAL_POSITION) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName AND ORDINAL_POSITION > @field
		
		SELECT @bit = (@field - 1 )% 8 + 1
        
		SELECT @bit = POWER(2,@bit - 1)
        
		SELECT @char = ((@field - 1) / 8) + 1

		IF SUBSTRING(COLUMNS_UPDATED(),@char, 1) & @bit > 0 OR @Type IN ('I','D')
		BEGIN

			SELECT @fieldname = COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName AND ORDINAL_POSITION = @field

			SELECT @sql = '
					INSERT Tbl_AuditTrail (Type, 
					TableName, 
					PK, 
					PKFieldName,
					PKValue,
					FieldName, 
					OldValue, 
					NewValue, 
					UpdatedOn, 
					UpdatedBy)
			SELECT ''' + @Type + ''',''' 
			+ @TableName + ''',' + @PKSelect +','''  + @PKFieldName
			+ ''',''' + @PKValue
			+ ''',''' + @fieldname + ''''
			+ ',CONVERT(VARCHAR(1000),d.' + @fieldname + ')'
			+ ',CONVERT(VARCHAR(1000),i.' + @fieldname + ')'
			+ ',''' + @UpdateDate + ''''
			+ ',''' + @UpdatedBy + ''''
			+ ' FROM #ins i FULL OUTER JOIN #del d'
			+ @PKCols
			+ ' WHERE i.' + @fieldname + ' <> d.' + @fieldname 
			+ ' OR (i.' + @fieldname + ' IS NULL AND  d.'+ @fieldname+ ' IS NOT NULL)' 
			+ ' OR (i.' + @fieldname + ' IS NOT NULL AND  d.'+ @fieldname+ ' IS NULL)' 


			EXEC (@sql)
		END
	END