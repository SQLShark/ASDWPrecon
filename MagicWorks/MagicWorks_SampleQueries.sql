USE AdventureWorks;
GO

SELECT 
	P.FirstName + ' ' + P.LastName
	, ProductCategory.Name
	, ProductSubCategory.Name
	, Product.Name

FROM Sales.SalesOrderDetail SOD
INNER JOIN Sales.SalesOrderHeader SOH ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Production.Product ON Product.ProductID = SOD.ProductID
INNER JOIN Production.ProductSubcategory ON ProductSubcategory.ProductSubcategoryID = Product.ProductSubcategoryID
INNER JOIN Production.ProductCategory ON ProductCategory.ProductCategoryID = ProductSubcategory.ProductCategoryID
INNER JOIN Person.Person P ON P.BusinessEntityID = SOH.CustomerID