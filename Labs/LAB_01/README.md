# LAB-001 | Connect to Azure SQL Data Warehouse, check nodes and distributions  
In this lab we will be validating that you can connect, then we will be looking at the number of Nodes and Distributions.

1. Connect to the Azure SQL Data Warehouse
2. Analyse the number of nodes
3. Analyse the number of distributions 

Open Management studio. Hopefully you are running the latest version of SSMS (17.5).
Login to Azure SQL Data Warehouse. 

```sql
Server: magicadventure.database.windows.net
UserName: gandalf
Password: Password1234!
```

Once logged in, change you connection to your instance of Azure SQL Data Warehouse. 

## Analyse the number of nodes
Running the following query in SSMS will return the number of Nodes currently in use. 
```sql
SELECT  [pdw_node_id]   AS node_id
,       [type]          AS node_type
,       [name]          AS node_name
FROM    sys.[dm_pdw_nodes]
;
```

## Analyse the number of distributions 
Running the following query in SSMS will return the number of Distributions currently in use. 
```sql
SELECT  [distribution_id]   AS dist_id
,       [pdw_node_id]       AS node_id
,       [name]              AS dist_name
,       [position]          AS dist_position
FROM    sys.[pdw_distributions]
;
```