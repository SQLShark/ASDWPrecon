# Distributions  
In this demo we are looking to create a table and load it with some data. We will introduce creating and loading tables later in the day. So for now we have simplified this in to a stored procedure. 

To complete this lab you will need to do the following
1. Execute a stored procedure to populate a table
2. Run a Select * FROM [olap].[FactInternetSales_new]
3. Query DBCC PDW_SHOWSPACEUSED
4. Query sys.dm_pdw_nodes_db_partition_stats
5. Query vTableSizes
 

## Execute a stored procedure to populate a table
Running this will be a 
```sql
EXEC dbo.Lab002_PopulateFIS
```

## Run a Select * FROM [olap].[FactInternetSales_new]
This table has been completed using a round robin distribution. This might not mean a lot at this point.
We will come back to this. For now just run the example code. 
```sql
SELECT * FROM [olap].[FactInternetSales_new]
```

Next you want to run DBCC PDW_SHOWSPACEUSED. The purpose of this is to see how your data has been distributed across our distributions. 
```sql
DBCC PDW_SHOWSPACEUSED
```

By default this returns all allocations for the distributions, but you can filter it down to just the table you're after.

```sql
DBCC PDW_SHOWSPACEUSED('[olap].[FactInternetSales_new]')
```

Then you will want to see how your data has been partitioned across distributions. 
```sql
SELECT
    ps.pdw_node_id
  , ps.distribution_id
  , ps.object_id AS 'physical_object_id'
  , ps.index_id
  , ps.partition_number
  , ps.row_count
  , ps.used_page_count
FROM
    sys.dm_pdw_nodes_db_partition_stats AS ps;
```

Finally Microsoft produce a great view called vTableSizes. This has been pre-loaded in to the database you're using. 
Run the following query and take a look at how FactInternetSales_new has been distributed across nodes. 
This is a great view to have installed on all of your instances of Azure SQL Data Warehouse. 
```sql
SELECT * FROM dbo.vTableSizes WHERE two_part_name = '[olap].[FactInternetSales_new]'
```

## Additional queries you might want to have a look at: 
### Table space summary
This query returns the rows and space by table. It allows you to see which tables are your largest tables and whether they are round-robin, replicated, or hash -distributed. For hash-distributed tables, the query shows the distribution column.

```sql
SELECT 
     database_name
,    schema_name
,    table_name
,    distribution_policy_name
,      distribution_column
,    index_type_desc
,    COUNT(distinct partition_nmbr) as nbr_partitions
,    SUM(row_count)                 as table_row_count
,    SUM(reserved_space_GB)         as table_reserved_space_GB
,    SUM(data_space_GB)             as table_data_space_GB
,    SUM(index_space_GB)            as table_index_space_GB
,    SUM(unused_space_GB)           as table_unused_space_GB
FROM 
    dbo.vTableSizes
GROUP BY 
     database_name
,    schema_name
,    table_name
,    distribution_policy_name
,      distribution_column
,    index_type_desc
ORDER BY
    table_reserved_space_GB desc
;
```

### Table space by distribution type
```sql
SELECT 
     distribution_policy_name
,    SUM(row_count)                as table_type_row_count
,    SUM(reserved_space_GB)        as table_type_reserved_space_GB
,    SUM(data_space_GB)            as table_type_data_space_GB
,    SUM(index_space_GB)           as table_type_index_space_GB
,    SUM(unused_space_GB)          as table_type_unused_space_GB
FROM dbo.vTableSizes
GROUP BY distribution_policy_name
;
```

### Table space by index type
```sql
SELECT 
     index_type_desc
,    SUM(row_count)                as table_type_row_count
,    SUM(reserved_space_GB)        as table_type_reserved_space_GB
,    SUM(data_space_GB)            as table_type_data_space_GB
,    SUM(index_space_GB)           as table_type_index_space_GB
,    SUM(unused_space_GB)          as table_type_unused_space_GB
FROM dbo.vTableSizes
GROUP BY index_type_desc
;
```

### Distribution space summary
```sql
SELECT 
    distribution_id
,    SUM(row_count)                as total_node_distribution_row_count
,    SUM(reserved_space_MB)        as total_node_distribution_reserved_space_MB
,    SUM(data_space_MB)            as total_node_distribution_data_space_MB
,    SUM(index_space_MB)           as total_node_distribution_index_space_MB
,    SUM(unused_space_MB)          as total_node_distribution_unused_space_MB
FROM dbo.vTableSizes
GROUP BY     distribution_id
ORDER BY    distribution_id
;
```

Lab complete. 