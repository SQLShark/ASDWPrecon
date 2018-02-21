# Distributions

This lab aims to introduce you to the idea of redistributing data within tables. This is a common technique when exploring performance issues and working on the initial design of your data model. Don't be afraid to try several different distributions - the data movement service is very efficient, the overhead of trying it out isn't too great!

In this lab we will:
1. Create a table using round robin distribution
2. Redistribute using a poor key choice
3. Redistribute using a good key choice
4. Redistribute as a replicated table
5. Use your skew tools to review your new tables

## Setting up your initial table

First, we need to bring in some data we can work with, run the following script to select records from one of our external tables and store it as a local table using the distributions.

```sql
CREATE TABLE dbo.FactInternetSales
WITH
(
	CLUSTERED COLUMNSTORE INDEX,
	DISTRIBUTION = ROUND_ROBIN
)
AS
SELECT *
  FROM [ext].[FactInternetSales]
```

This creates our first table - let's take a look at how it's been distributed across the distributions using vTableSizes:

```sql
SELECT two_part_name, distribution_id, row_count
FROM [dbo].[vTableSizes]
WHERE two_part_name = '[dbo].[FactInternetSales]'
```

This should have a fairly even (not exact!) spread across the various distributions.

## Redistribute as a badly distributed HASH()

Now let's create a copy of the table using a HASH distribution. We can pick a column and distribute it out. Run the following script to create our table using something that perhaps isn't the best choice - maybe it doesn't have many values, maybe one of the values has way more records than others. We've picked CurrencyKey, but feel free to choose your own!

```sql
CREATE TABLE dbo.FactInternetSalesPH_Bad
WITH
(
	CLUSTERED COLUMNSTORE INDEX,
	DISTRIBUTION = HASH(CurrencyKey)
)
AS
SELECT *
  FROM [dbo].[FactInternetSales]
```

This creates a new table and distributes the data from the select statement. Let's take a look at how that distributed:

```sql
SELECT two_part_name, distribution_id, row_count
FROM [dbo].[vTableSizes]
WHERE two_part_name = '[dbo].[FactInternetSalesPH_Bad]'
```

If you've picked poorly then you should be seeing a huge disparity in record distribution. For CurrencyKey, many distributions won't have any records at all as there are not enough unique values to cover all distributions.

## Redistribute as a well distributed HASH()

Let's try again with a better column to distribute on. We often join to the table using the ProductKey so that is a fair candidate for our distribution.

```sql
CREATE TABLE dbo.FactInternetSalesPH
WITH
(
	CLUSTERED COLUMNSTORE INDEX,
	DISTRIBUTION = HASH(ProductKey)
)
AS
SELECT *
  FROM [dbo].[FactInternetSales]
```

Once again, let's see how that looks:

```sql
SELECT two_part_name, distribution_id, row_count
FROM [dbo].[vTableSizes]
WHERE two_part_name = '[dbo].[FactInternetSalesPH]'
```

Not perfect, but a lot better! It's very rare to find a table that does have a very well distributed key that also meets are other criteria.

## Rebuild as a Replicated Table

Our final replication type is our Replicated table. This works differently in that queries do not hit all distributions at all but a copy is pushed on to the compute nodes themselves which is used in those queries.

```sql
CREATE TABLE dbo.FactInternetSalesREP
WITH
(
	CLUSTERED COLUMNSTORE INDEX,
	DISTRIBUTION = REPLICATE
)
AS
SELECT *
  FROM [dbo].[FactInternetSales]
```

## Review Skew

You can use the skew analysis views to decide which of your tables would be best in this scenario.

```sql
--Return distribution usage
DBCC PDW_SHOWSPACEUSED

--Return ALL table across ALL distributions
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

--Formatted view, good for exploring distribution skew
SELECT *
  FROM [dbo].[vTableSizes]
```