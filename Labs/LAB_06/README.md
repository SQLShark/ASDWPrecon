# Performance DMV and EXPLAIN [15 Minutes]

This lab will introduce you to the system views used to monitor performance within Azure SQLDW. We will look at an example query and the execution plan behind it.

We will:
1. Bring in the necessary data for our query
2. Run a large query
3. Identify performance problems upfront using EXPLAIN
4. Identify performance problems after execution using DMVS

# Load the Data
Firstly, let's load a couple of tables from our external polybase layer so we have something to work with:

```sql
CREATE TABLE dbo.SalesOrderHeader
WITH
(
	CLUSTERED COLUMNSTORE INDEX,
	DISTRIBUTION = ROUND_ROBIN
)
AS
SELECT *
  FROM [ext].SalesOrderHeader

CREATE TABLE dbo.Customer
WITH
(
	CLUSTERED COLUMNSTORE INDEX,
	DISTRIBUTION = ROUND_ROBIN
)
AS
SELECT *
  FROM [ext].Customer

CREATE TABLE dbo.SalesOrderDetail
WITH
(
	CLUSTERED COLUMNSTORE INDEX,
	DISTRIBUTION = ROUND_ROBIN
)
AS
SELECT *
  FROM [ext].SalesOrderDetail
```

Once that has completed, we can now run our query to gather some performance results.

# Run Query
We've put together a very simple query that joins several tables together - this involves a little bit of data movement and could potentially be optimised, but we don't know how until we know what's happening when we execute the query!


```sql
SELECT
	C.[CustomerID],
	SUM(CAST([LineTotal] as money)) TotalSales
FROM
	dbo.Customer C
	INNER JOIN dbo.SalesOrderHeader SOH ON C.CustomerID = SOH.CustomerID
	INNER JOIN dbo.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
GROUP BY C.[CustomerID]
OPTION (LABEL = 'This is the query we are interested in')
```

# Using the EXPLAIN Keyword

Firstly, we can ask Azure SQLDW how it's going to approach the problem. Putting the EXPLAIN keyword in front of the statement produces an XML output. In SSMS currently this is returned as a text result set, you'll need to copy it into a text reader such as VSCode, Visual Studio or Notepad++ to visualise the XML properly.

```sql
EXPLAIN
SELECT
	C.[CustomerID],
	SUM(CAST([LineTotal] as money)) TotalSales
FROM
	dbo.Customer C
	INNER JOIN dbo.SalesOrderHeader SOH ON C.CustomerID = SOH.CustomerID
	INNER JOIN dbo.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
GROUP BY C.[CustomerID]
OPTION (LABEL = 'This is the query we are interested in')
```

You should see the different <dsql_operation> tags and the various different operation types underneath - Broadcast Move, Shuffle Move etc - these are the data movements that are occurring and could potentially be avoided.

# Using the performance DMVs

What if we see performance problems but we don't know the query that caused it?

First, we can use the sys.dm_pdw_exec_requests view - this tells us all the queries that have been run recently. It can be used to see where queries with large resource classes have been run, what sql statement consisted of and the overall duration.

```sql
SELECT *
FROM sys.dm_pdw_exec_requests
```

What was the most expensive query run recently? You might notice that some queries don't have a resource class - that's because any queries on system views or using DDL won't inherit the user's resource class and will automatically use a small rc. You will also notice that each query has a unique ID. What's even more useful - you can see the "Label" for our query, it should be populated with our "This is the query we are interested in" comment!

But what happened within that statement? We can see the individual steps (data movement, sql etc) by querying another DMV.

```sql
SELECT *
FROM sys.dm_pdw_request_steps
WHERE request_id = <Request ID>
```

Put the request you're trying to analyse into the above query and run it. You'll see a number of steps, with details of how long each step took, where it was run (control node, compute nodes or distributions) and whether it was a data movement step or a sql engine step. This will resemble the details you saw in the EXPLAIN plan.

Finally, we can dig into what each of those steps actually did on each distribution. We have two choices for this - one for SQL operations and another for DMS.

For SQL tasks:
```sql
SELECT *
FROM sys.dm_pdw_sql_requests
WHERE request_id = <Request ID> AND step_index = <Step Number>
```

For DMS tasks:
```sql
SELECT *
FROM sys.dm_pdw_dms_workers
WHERE request_id = <Request ID> AND step_index = <Step Number>
```

With these tools, you can dig right into the details of any queries that have been run recently.

## NOTE
These DMVs will only show data collected since the SQL DataWarehouse was last resumed - as new requests come in, older queries will gradually be aged out of these views.