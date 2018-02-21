use AdventureWorksDW2012;
GO

EXEC master.dbo.sp_configure 'show advanced options', 1
RECONFIGURE
EXEC master.dbo.sp_configure 'xp_cmdshell', 1
RECONFIGURE; 

BEGIN TRY
	DROP VIEW dbo.config 
END TRY
BEGIN CATCH
	PRINT 'No Need'
END CATCH;
GO

CREATE VIEW dbo.config AS 
SELECT 
	s.Name AS 'SchemaName'
	, T.NAme AS 'TableName'
	, 'EXEC xp_cmdshell ''bcp "SELECT * FROM  AdventureWorksDW2012.' + s.Name +'.'+  T.NAme + '" queryout "G:\Adatis\SQLBits - SQLDW Planning - General\ExportedData\MagicWorksDW\' + s.Name +'_'+  T.NAme + '.txt" -T -c -t''' AS 'Export'
	, 'AzCopy /Source:"G:\Adatis\SQLBits - SQLDW Planning - General\ExportedData\MagicWorksDW" /Dest:https://magicworksblob.blob.core.windows.net/'+  LOWER(T.NAme) + ' /DestKey:WR6PLCnUMJ9Hu6Wkt7EUadRLDnoVF3cTabiGm//3FBXXJOSFAPqjrkfqqEW9qT4P2OlsKDcY0iSRUfDWtNhKrA== /Pattern:"' + s.Name +'_'+  T.NAme + '.txt" /y' AS 'Import'
FROM
	sys.tables t 
	INNER JOIN sys.schemas S ON S.schema_id = t.schema_id;
GO

SELECT * FROM dbo.config

EXEC xp_cmdshell 'bcp "SELECT * FROM adventureworksDW2012.dbo.config" queryout "G:\Adatis\SQLBits - SQLDW Planning - General\ExportedData\MagicWorksDW\config.txt" -T -c -t,'

-- #######################################################################################################################################
-- 
-- #######################################################################################################################################

use AdventureWorksDW2012;
GO

EXEC master.dbo.sp_configure 'show advanced options', 1
RECONFIGURE
EXEC master.dbo.sp_configure 'xp_cmdshell', 1
RECONFIGURE 

SELECT 
	s.Name
	, T.NAme
	, 'EXEC xp_cmdshell ''bcp "SELECT * FROM AdventureWorksDW2012.' + s.Name +'.'+  T.NAme + '" queryout "G:\Adatis\SQLBits - SQLDW Planning - General\ExportedData\MagicWorksDW\' + s.Name +'_'+  T.NAme + '.txt" -T -c -t,'''
	, 'AzCopy /Source:"G:\Adatis\SQLBits - SQLDW Planning - General\ExportedData\MagicWorksDW" /Dest:https://magicworksblob.blob.core.windows.net/bcptest /DestKey:WR6PLCnUMJ9Hu6Wkt7EUadRLDnoVF3cTabiGm//3FBXXJOSFAPqjrkfqqEW9qT4P2OlsKDcY0iSRUfDWtNhKrA== /Pattern:"bcptest.txt"'
FROM
	sys.tables t 
	INNER JOIN sys.schemas S ON S.schema_id = t.schema_id
