BEGIN TRY
	DROP PROCEDURE datawarehouse.AdatisASDWMetadata
END TRY
BEGIN CATCH
	PRINT 'No Need'
END CATCH;
GO

CREATE PROCEDURE datawarehouse.AdatisASDWMetadata 
as
BEGIN 

BEGIN TRY
       DROP TABLE #ColumnMetadata
END TRY
BEGIN CATCH
       PRINT 'No Need'
END CATCH;


CREATE TABLE #ColumnMetadata
(
       [TableName] VARCHAR(500),
       [TableNameShort] VARCHAR(500),
       [LooselyTyped] VARCHAR(8000), 
       [StronglyTyped] VARCHAR(8000), 
       [SelectColumns] VARCHAR(8000), 
       [StronglyTypedCast] VARCHAR(8000),
       [BlobName] VARCHAR(500),
	   [PrimaryKey] VARCHAR(500),
	   [Quoted] VARCHAR(8000)
)


DECLARE @TableName VARCHAR(50);
DECLARE @SchemaNameShort VARCHAR(50);
DECLARE @TableNameShort VARCHAR(50);
DECLARE db_cursor_outer CURSOR
FOR 
with this as (
SELECT CONCAT('[',s.name,'].[', t.name, ']') 'TableAttribute', s.name AS 'SchemaNameShort', t.name AS 'TableNameShort' FROM sys.tables AS T INNER JOIN sys.schemas AS S ON S.schema_id = T.schema_id
--union all 
--SELECT CONCAT('[',s.name,'].[', t.name, ']')  FROM sys.views AS T INNER JOIN sys.schemas AS S ON S.schema_id = T.schema_id
) 
SELECT * FROM this



OPEN db_cursor_outer;   
FETCH NEXT FROM db_cursor_outer INTO @TableName, @SchemaNameShort, @TableNameShort; 

WHILE @@FETCH_STATUS = 0
      BEGIN   

DECLARE @OverWriteColumn VARCHAR(50) = 'Nvarchar(500)';
DECLARE @ColumnName VARCHAR(50);
DECLARE @TypeName VARCHAR(50);
DECLARE @TypeLength VARCHAR(50);
DECLARE @SQL VARCHAR(8000);
DECLARE @SQL2 VARCHAR(8000);
DECLARE @SQL3 VARCHAR(8000);
DECLARE @SQL4 VARCHAR(8000);
DECLARE @SQL5 VARCHAR(8000);
DECLARE @DatabaseName VARCHAR(150) =  DB_NAME()

DECLARE @listStr VARCHAR(MAX)
SELECT @listStr = COALESCE(@listStr+',' ,'') + 
    COL_NAME(ic.object_id,ic.column_id) 
FROM
    sys.indexes AS i
INNER JOIN sys.index_columns AS ic ON i.object_id = ic.object_id
                                      AND i.index_id = ic.index_id
WHERE
    i.is_primary_key = 1
	AND OBJECT_NAME(ic.object_id) = REPLACE(REPLACE(SUBSTRING(@TableName, CHARINDEX('.', @TableName)+1,100),'[',''),']','')



DECLARE db_cursor CURSOR
FOR 
SELECT
       C.name
       , T2.Name
       , case when C.max_length >= 4000 then 4000 else C.max_length end as max_length
FROM
    sys.tables AS T
INNER JOIN sys.columns AS C ON C.object_id = T.object_id
INNER JOIN sys.types AS T2 ON T2.user_type_id = C.user_type_id
INNER JOIN sys.schemas AS S ON S.schema_id = T.schema_id
WHERE
    '[' +  S.name + '].[' + T.name + ']' = @TableName AND t2.Name <> 'sysname'
union all 
SELECT
       C.name
       , T2.Name
       , case when C.max_length >= 4000 then 4000 else C.max_length end as max_length
FROM
    sys.views AS T
INNER JOIN sys.columns AS C ON C.object_id = T.object_id
INNER JOIN sys.types AS T2 ON T2.system_type_id = C.system_type_id
INNER JOIN sys.schemas AS S ON S.schema_id = T.schema_id
WHERE
    '[' +  S.name + '].[' + T.name + ']' = @TableName AND t2.Name <> 'sysname'
OPEN db_cursor;   
FETCH NEXT FROM db_cursor INTO @ColumnName, @TypeName, @TypeLength;   

SET @SQL = ''
SET @SQL2 = ''
SET @SQL3 = ''
SET @SQL4 = ''
SET @SQL5 = ''

WHILE @@FETCH_STATUS = 0
      BEGIN   

                           SET @SQL = @SQL + ' [' +  @ColumnName + '] ' + 
                                  CASE 
                                         WHEN @TypeLength > 500 and @TypeLength <= 4000 THEN 'NVARCHAR(' + @TypeLength +')' 
										 WHEN @TypeLength >4000 THEN 'NVARCHAR(4000)' 
                                         WHEN @TypeName = 'CHAR' THEN 'NVARCHAR(500)' 
                                         WHEN @TypeName = 'BOOLEAN' THEN 'NVARCHAR(5)' 
                                         WHEN @TypeName = 'BIGINT' THEN 'NVARCHAR(250)'
                                         WHEN @TypeName = 'INT' THEN 'NVARCHAR(50)' 
                                         WHEN @TypeName = 'DECIMAL' THEN 'NVARCHAR(50)'
                                         WHEN @TypeName = 'NUMERIC' THEN 'NVARCHAR(50)'
                                         WHEN @TypeName = 'FLOAT' THEN 'NVARCHAR(50)'
                                         WHEN @TypeName = 'REAL' THEN 'NVARCHAR(50)'
                                         WHEN @TypeName = 'DOUBLE' THEN 'NVARCHAR(50)'
                                         WHEN @TypeName = 'DATE' THEN 'NVARCHAR(50)'
                                         WHEN @TypeName = 'DATETIME' THEN 'NVARCHAR(50)'
                                         WHEN @TypeName = 'TIME' THEN 'NVARCHAR(50)'
                                         WHEN @TypeName = 'TIMESTAMP' THEN 'NVARCHAR(50)'
                                         ELSE 'NVARCHAR(500)' END + ' ,'  + CHAR(13) + CHAR(10)
                                  --CASE WHEN @TypeName IN ('int', 'money', 'datetime', 'bit','smallint','varbinary','date','tinyint') THEN '' ELSE  '(' + @TypeLength + ')' END + ' NULL , '  + CHAR(13)
                           
                           
                           
                           SET @SQL2 = @SQL2 + ' [' +  @ColumnName + '] , '+ CHAR(13) + CHAR(10)
						   SET @SQL5 = @SQL5 + ' QUOTENAME(' +  @ColumnName + ', CHAR(34)) , '+ CHAR(13) + CHAR(10)
                           SET @SQL3 = @SQL3 + ' [' +  @ColumnName + '] ' + @TypeName + CASE WHEN @TypeName = 'Decimal' THEN '(12,5) ' WHEN @TypeName IN ('int', 'money', 'datetime', 'bit','smallint','varbinary','date','tinyint','uniqueidentifier') THEN '' ELSE  '(' + @TypeLength + ')' END + ' , '  + CHAR(13) + CHAR(10)
                           SET @SQL4 = @SQL4 + CASE WHEN @TypeName = 'datetime' THEN ' CONVERT(datetime, LEFT(' + @ColumnName + ',22), 101' ELSE ' CAST(' + @ColumnName + ' AS ' + @TypeName + CASE WHEN @TypeName = 'Decimal' THEN '(12,5)' WHEN @TypeName IN ('int', 'money', 'datetime', 'bit','smallint','varbinary','date','tinyint','uniqueidentifier') THEN '' ELSE  '(' + @TypeLength + ')' END  END + ') AS '+@ColumnName+', '+ CHAR(13) + CHAR(10)
                     FETCH NEXT FROM db_cursor INTO @ColumnName, @TypeName, @TypeLength;   
      END;   

CLOSE db_cursor;   
DEALLOCATE db_cursor;

INSERT INTO #ColumnMetadata
SELECT 
       @TableName
       , REPLACE(REPLACE(SUBSTRING(@TableName, CHARINDEX('.', @TableName)+1,100),'[',''),']','')
       , LEFT(@SQL, CASE WHEN LEN(@sql) = 0 THEN LEN(@Sql) ELSE LEN(@Sql)-4 END ) 'LooselyTyped'
       , LEFT(@SQL3, CASE WHEN LEN(@sql3) = 0 THEN LEN(@Sql3) ELSE LEN(@Sql3)-4 END ) AS 'StronglyTyped'
       , LEFT(@SQL2, CASE WHEN LEN(@sql2) = 0 THEN LEN(@Sql2) ELSE LEN(@Sql2)-4 END ) AS 'ColumnSelect'
       , LEFT(@SQL4, CASE WHEN LEN(@sql4) = 0 THEN LEN(@Sql4) ELSE LEN(@Sql4)-4 END )
       , replace(LOWER(REPLACE(REPLACE(REPLACE(@TableName, '[', ''),']',''),'.','')),'vw','')
	   , @listStr
	   , 'EXEC xp_cmdshell ''bcp "SELECT ' + LEFT(@SQL5, CASE WHEN LEN(@sql5) = 0 THEN LEN(@Sql5) ELSE LEN(@Sql5)-4 END ) + ' FROM ' + @DatabaseName + '.' + @TableName + '" queryout "G:\Adatis\SQLBits - SQLDW Planning - General\ExportedData\MagicWorksDW\'+@SchemaNameShort+'_'+@TableNameShort+'.txt" -T -c -t,''' AS 'Export'
       
--END 
--GO
SET @listStr = NULL
FETCH NEXT FROM db_cursor_outer INTO @TableName, @SchemaNameShort, @TableNameShort;  
END;  

CLOSE db_cursor_outer;   
DEALLOCATE db_cursor_outer;

SELECT * FROM #ColumnMetadata AS CM WHERE CM.LooselyTyped IS NOT NULL AND CM.LooselyTyped <> ''

END

GO


EXEC datawarehouse.AdatisASDWMetadata


