# Managing surrogates [10 Minutes]

This lab tackles a very common data warehousing issue - applying surrogate keys to a dimension table during an insert. The standard approach for this would be to use an IDENTITY table, but this is very different in SQLDW and so we have a few options.

To complete this Lab, we need to:
1. Run a script to set up our demo
2. Run Option 1 - Applying Surrogate Keys via Identity
3. Run Option 2 - Applying Surrogate Keys via ROW_NUMBER()
4. Run Option 3 - Applying Surrogate Keys via HASH()

## Populate Dimension & Delta Table for our Demo

We first need to set up a table and some changed records so that we can model our surrogate inserts. Run the following script to pull data in from the DimProduct external table and land it as dbo.DimProduct. This is taken from the AdventureWorksDW sample and so already has surrogate keys generated.

```sql
CREATE TABLE dbo.DimProduct
WITH
	(
		HEAP,
		DISTRIBUTION = ROUND_ROBIN
	)
AS
SELECT *
FROM ext.DimProduct

CREATE TABLE dbo.DimProductDelta
WITH
	(
		HEAP,
		DISTRIBUTION = ROUND_ROBIN
	)
AS
	SELECT TOP 10
		[ProductAlternateKey] + 'D' [ProductAlternateKey] , [ProductSubcategoryKey], [WeightUnitMeasureCode], [SizeUnitMeasureCode], [EnglishProductName], [SpanishProductName], [FrenchProductName], [StandardCost], [FinishedGoodsFlag], [Color], [SafetyStockLevel], [ReorderPoint], [ListPrice], [Size], [SizeRange], [Weight], [DaysToManufacture], [ProductLine], [DealerPrice], [Class], [Style], [ModelName], [EnglishDescription], [FrenchDescription], [ChineseDescription], [ArabicDescription], [HebrewDescription], [ThaiDescription], [GermanDescription], [JapaneseDescription], [TurkishDescription], [StartDate], [EndDate], [Status]
	FROM [dbo].[DimProduct]
UNION ALL
	SELECT TOP 10 
		[ProductAlternateKey], [ProductSubcategoryKey], [WeightUnitMeasureCode], [SizeUnitMeasureCode], [EnglishProductName], [SpanishProductName], [FrenchProductName], [StandardCost], [FinishedGoodsFlag], [Color], [SafetyStockLevel], [ReorderPoint], [ListPrice], [Size], [SizeRange], [Weight], [DaysToManufacture], [ProductLine], [DealerPrice], [Class], [Style], [ModelName], [EnglishDescription], [FrenchDescription], [ChineseDescription], [ArabicDescription], [HebrewDescription], [ThaiDescription], [GermanDescription], [JapaneseDescription], [TurkishDescription], [StartDate], [EndDate], [Status]
	FROM dbo.DimProduct
```

This will create the two tables we're using for our example. Take a look at DimProduct, which contains records already populated with data including surrogate keys, and the DimProductDelta  table that contains records which need a surrogate appending before being added to our dimension table.

## Option 1 - IDENTITY Tables

Similar to the normal SQL Server engine, Azure SQLDW can have identity columns which will automatically populate as records are added. However, in order to enable massively parallel inserts, the identities generated are sparsely populated and there is potential for collisions.

First we need to create the new dimension table, run the following script to create a DimProduct_Identity with the IDENTITY(1,1) attribute on the ProductKey column

```sql
CREATE TABLE [dbo].[DimProduct_Identity]
(
	[ProductKey] [int] IDENTITY(1,1) NOT NULL,
	[ProductAlternateKey] [nvarchar](25) NULL,
	[ProductSubcategoryKey] [int] NULL,
	[WeightUnitMeasureCode] [nchar](3) NULL,
	[SizeUnitMeasureCode] [nchar](3) NULL,
	[EnglishProductName] [nvarchar](50) NOT NULL,
	[SpanishProductName] [nvarchar](50) NULL,
	[FrenchProductName] [nvarchar](50) NULL,
	[StandardCost] [money] NULL,
	[FinishedGoodsFlag] [bit] NOT NULL,
	[Color] [nvarchar](15) NOT NULL,
	[SafetyStockLevel] [smallint] NULL,
	[ReorderPoint] [smallint] NULL,
	[ListPrice] [money] NULL,
	[Size] [nvarchar](50) NULL,
	[SizeRange] [nvarchar](50) NULL,
	[Weight] [float] NULL,
	[DaysToManufacture] [int] NULL,
	[ProductLine] [nchar](2) NULL,
	[DealerPrice] [money] NULL,
	[Class] [nchar](2) NULL,
	[Style] [nchar](2) NULL,
	[ModelName] [nvarchar](50) NULL,
	[EnglishDescription] [nvarchar](400) NULL,
	[FrenchDescription] [nvarchar](400) NULL,
	[ChineseDescription] [nvarchar](400) NULL,
	[ArabicDescription] [nvarchar](400) NULL,
	[HebrewDescription] [nvarchar](400) NULL,
	[ThaiDescription] [nvarchar](400) NULL,
	[GermanDescription] [nvarchar](400) NULL,
	[JapaneseDescription] [nvarchar](400) NULL,
	[TurkishDescription] [nvarchar](400) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Status] [nvarchar](7) NULL
)
WITH
(
	DISTRIBUTION = HASH ( [ProductAlternateKey] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO

```

We can now insert records into this table. Note that we need to run this as a straight insert, we cannot use the CTAS syntax in combination with an identity.

```sql
INSERT INTO [dbo].[DimProduct_Identity]
([ProductAlternateKey], [ProductSubcategoryKey], [WeightUnitMeasureCode], [SizeUnitMeasureCode], [EnglishProductName], [SpanishProductName], [FrenchProductName], [StandardCost], [FinishedGoodsFlag], [Color], [SafetyStockLevel], [ReorderPoint], [ListPrice], [Size], [SizeRange], [Weight], [DaysToManufacture], [ProductLine], [DealerPrice], [Class], [Style], [ModelName], [EnglishDescription], [FrenchDescription], [ChineseDescription], [ArabicDescription], [HebrewDescription], [ThaiDescription], [GermanDescription], [JapaneseDescription], [TurkishDescription], [StartDate], [EndDate], [Status])
SELECT * FROM dbo.DimProductDelta
```

Once that has completed, we can look at the records that have been inserted

```sql
SELECT * FROM [dbo].[DimProduct_Identity]
```

Normally, we would expect our records to be numbers 1-20, but you should see something quite different! Azure SQLDW will sparsely populate the identity to enable the parallel inserts needed to improve performance. Also, not being able to use a CTAS means our loading patterns have to be updated.

## Option 2 - ROW_NUMBER() Pattern

A standard approach is to use the ROW_NUMBER() window function within our select statement to generate a seqeuential integer for each row of the delta table. We can add the current maximum key to this number to ensure we are not duplicating existing keys.

```sql
DECLARE @MaxKey int = (SELECT MAX(ProductKey) FROM dbo.DimProduct)

SELECT ISNULL(DP.ProductKey,ROW_NUMBER() OVER (ORDER BY DPD.ProductAlternateKey) + @MaxKey) as ProductKey,
DPD.*
FROM dbo.DimProductDelta DPD LEFT JOIN
	dbo.DimProduct DP ON DPD.ProductAlternateKey = DP.ProductAlternateKey
```

This is a fairly straight-forward approach and is very commonly used across organisations that are managing Kimball-style warehouses in Azure SQLDW. There is a performance impact from joining to the dimension to retrieve existing keys - if it is a large dimension you might want to split this into an "Inserts" and an "Update/Delete" statement to manage performance separately.

## Option 3 - Applying Surrogates via HASH

A final option would be to apply a HASHBYTES to your business key. This removes the need to join to the dimension table in order to see where records already exist, the hash can be generated during earlier data transformations.

```sql
SELECT LOWER(CONVERT(CHAR(32),HASHBYTES('MD5',DPD.ProductAlternateKey),2)) ProductKey,
	DPD.*
FROM dbo.DimProductDelta DPD
```

This is a common loading pattern where the emphasis is on getting data into the system as fast as possible. Patterns such as Data Vault favour this method, but you can certainly use it in classic warehousing if you are performing many small updates throughout the day.

Lab Complete