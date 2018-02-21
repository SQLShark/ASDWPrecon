-- #######################################################################################################################################
-- Create a sample procedure
-- #######################################################################################################################################

BEGIN TRY
	DROP PROC dbo.Lab002_PopulateFIS
END TRY
BEGIN CATCH
	PRINT 'No Need'
END CATCH;
GO

CREATE PROC dbo.Lab002_PopulateFIS AS 
BEGIN 

BEGIN TRY
	DROP TABLE [olap].[FactInternetSales_new]
END TRY
BEGIN CATCH
	PRINT 'No Need'
END CATCH


CREATE TABLE [olap].[FactInternetSales_new]
WITH
(
    DISTRIBUTION = ROUND_ROBIN
,   CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT  *
FROM    [ext].[FactInternetSales]

END;
GO 
