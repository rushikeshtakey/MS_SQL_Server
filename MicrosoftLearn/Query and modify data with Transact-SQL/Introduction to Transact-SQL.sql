USE adventureworks;

SELECT * 
FROM SalesLT.Product;

SELECT Name, StandardCost,ListPrice
FROM SalesLT.Product;

SELECT Name, ListPrice - StandardCost
FROM SalesLT.Product;

SELECT Name, (ListPrice - StandardCost) AS Markup
FROM SalesLT.Product;

SELECT ProductNumber, Color, Size, (Color + ',' + Size) AS ProductDetails
FROM SalesLT.Product;

SELECT (ProductID + ':' + Name)  AS ProductName
FROM SalesLT.Product;

SELECT (CAST(ProductID AS VARCHAR(5)) + ':' + Name)  AS ProductName
FROM SalesLT.Product;

SELECT (CONVERT(varchar(5),ProductID) + ':' + Name) AS ProductName
FROM SalesLT.Product;

 SELECT SellStartDate,
    CONVERT(nvarchar(30), SellStartDate) AS ConvertedDate,
     CONVERT(nvarchar(30), SellStartDate, 126) AS ISO8601FormatDate
 FROM SalesLT.Product;

  SELECT Name, CAST(Size AS Integer) AS NumericSize
 FROM SalesLT.Product; 

 SELECT Name, TRY_CAST(Size AS Integer) AS NumericSize
FROM SalesLT.Product; 

 SELECT Name, ISNULL(TRY_CAST(Size AS Integer),0) AS NumericSize
 FROM SalesLT.Product;

  SELECT ProductNumber, ISNULL(Color, '') + ', ' + ISNULL(Size, '') AS ProductDetails
 FROM SalesLT.Product;

  SELECT Name, NULLIF(Color, 'Multi') AS SingleColor
 FROM SalesLT.Product;

  SELECT Name, COALESCE(SellEndDate, SellStartDate) AS StatusLastUpdated
 FROM SalesLT.Product;

  SELECT Name,
     CASE
         WHEN SellEndDate IS NULL THEN 'Currently for sale'
         ELSE 'No longer available'
     END AS SalesStatus
 FROM SalesLT.Product;

  SELECT Name,
     CASE Size
         WHEN 'S' THEN 'Small'
         WHEN 'M' THEN 'Medium'
         WHEN 'L' THEN 'Large'
         WHEN 'XL' THEN 'Extra-Large'
         ELSE ISNULL(Size, 'n/a')
     END AS ProductSize
 FROM SalesLT.Product;


 ------------------------------------------------------------------------------------------------------------------------------------
 SELECT *
 FROM SalesLT.Customer;

  SELECT Title, FirstName, MiddleName, LastName, Suffix
 FROM SalesLT.Customer;

  SELECT SalesPerson, (ISNULL(Title,'') + ' ' + ISNULL(LastName,'')) AS CustomarName, Phone
 FROM SalesLT.Customer;

  SELECT CAST(CustomerID AS VARCHAR(5)) + ':' + CompanyName AS CustomarCompanies
 FROM SalesLT.Customer;

 SELECT '(' + (CAST(PurchaseOrderNumber AS VARCHAR(10)) + '(' + CAST(RevisionNumber AS VARCHAR(10)) + ')*'), 
		CONVERT(NVARCHAR(10),OrderDate,102) AS OderDate
 FROM SalesLT.SalesOrderHeader;

 SELECT 
 CASE
	WHEN MiddleName IS NULL THEN (FirstName + ' ' + LastName)
	ELSE (FirstName + ' ' + MiddleName + ' ' + LastName)
	END AS CustomerName
 FROM SalesLT.Customer;

   UPDATE SalesLT.Customer
  SET EmailAddress = NULL
  WHERE CustomerID % 7 = 1;

  SELECT CustomerID, COALESCE(EmailAddress, Phone) AS PrimaryContact
  FROM SalesLT.Customer;

    UPDATE SalesLT.SalesOrderHeader
  SET ShipDate = NULL
  WHERE SalesOrderID > 71899;

  SELECT SalesOrderID,
	CASE
	WHEN ShipDate IS NULL THEN 'Awaiting Shipment '
	ELSE 'Shipped'
	END AS ShippingStatus
  FROM SalesLT.SalesOrderHeader;