-- #######################################################################################################################################
-- Create a Master Key
-- #######################################################################################################################################
BEGIN TRY
	CREATE MASTER KEY;
END TRY
BEGIN CATCH
	PRINT 'No Need'
END CATCH;
GO

-- #######################################################################################################################################
-- Create a Scoped Credential
-- #######################################################################################################################################
BEGIN TRY
CREATE DATABASE SCOPED CREDENTIAL AzureStorageCredential
WITH
    IDENTITY = 'user',
    SECRET = 'WR6PLCnUMJ9Hu6Wkt7EUadRLDnoVF3cTabiGm//3FBXXJOSFAPqjrkfqqEW9qT4P2OlsKDcY0iSRUfDWtNhKrA=='
END TRY
BEGIN CATCH
	PRINT 'No Need'
END CATCH;
GO

-- #######################################################################################################################################
--Create a File format
-- #######################################################################################################################################

BEGIN TRY
	DROP EXTERNAL FILE FORMAT TextFile
END TRY
BEGIN CATCH
	PRINT 'No Need'
END CATCH;
GO

BEGIN TRY
	CREATE EXTERNAL FILE FORMAT TextFile
WITH (
    FORMAT_TYPE = DelimitedText,
    FORMAT_OPTIONS (FIELD_TERMINATOR = ',', STRING_DELIMITER= '"')
)
END TRY
BEGIN CATCH
	PRINT 'No Need'
END CATCH;
GO


-- #######################################################################################################################################
-- Create a schema
-- #######################################################################################################################################

IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'ext')) 
BEGIN
    EXEC ('CREATE SCHEMA [ext] AUTHORIZATION [dbo]')
END

IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'oltp')) 
BEGIN
    EXEC ('CREATE SCHEMA [oltp] AUTHORIZATION [dbo]')
END

IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'olap')) 
BEGIN
    EXEC ('CREATE SCHEMA [olap] AUTHORIZATION [dbo]')
END