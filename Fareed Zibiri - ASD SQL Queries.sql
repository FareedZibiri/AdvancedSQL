ADVANCED SQL AND DATABASES

QUERY 1.1

SELECT
  Individual.CustomerID AS CustomerID,
  Contact.FirstName AS FirstName,
  Contact.LastName AS LastName,
  CONCAT(FirstName," ", LastName) AS full_name,
  CONCAT(COALESCE(Title,'Dear'), ' ', LastName)  AS addressing_title,
  Contact.EmailAddress AS EmailAddress,
  Contact.Phone AS Phone,
  Customer.AccountNumber AS AccountNumber,
  Customer.CustomerType AS CustomerType,
  Address.City AS City,
  Address.AddressLine1 AS AddressLine1,
  Address.AddressLine2 AS AddressLine2,
  StateProvince.Name AS State,
  CountryRegion.Name AS Country,
  COUNT (SalesOrderHeader.salesorderID) AS number_orders,
  ROUND(SUM(SalesOrderHeader.totalDue),3) AS total_amount,
  MAX(SalesOrderHeader.OrderDate) AS date_last_order
FROM
  `adwentureworks_db.individual` Individual
JOIN
  `adwentureworks_db.contact` Contact
ON
  Individual.ContactID = Contact.ContactID
JOIN
  `adwentureworks_db.customer` Customer
ON
  Customer.CustomerID = Individual.CustomerID
JOIN
  `adwentureworks_db.customeraddress` CustomerAddress
ON
  CustomerAddress.CustomerID = Customer.CustomerID
JOIN
  `adwentureworks_db.address` Address
ON
  Address.AddressID = CustomerAddress.AddressID
JOIN
  `adwentureworks_db.stateprovince` StateProvince
ON
  StateProvince.StateProvinceID = Address.StateProvinceID
JOIN
  `adwentureworks_db.countryregion` CountryRegion
ON
  CountryRegion.CountryRegionCode = StateProvince.CountryRegionCode
JOIN
  `adwentureworks_db.salesorderheader` SalesOrderHeader
ON
  SalesOrderHeader.CustomerID = Customer.CustomerID
GROUP BY
  CustomerID,
  FirstName,
  LastName,
  full_name,
  addressing_title,
  EmailAddress,
  Phone,
  AccountNumber,
  CustomerType,
  City,
  AddressLine1,
  AddressLine2,
  State,
  Country
ORDER BY
  total_amount DESC
LIMIT
  200


QUERY 1.2

WITH
  CustomerOverview AS (
  SELECT
    Individual.CustomerID AS CustomerID,
    Contact.FirstName AS FirstName,
    Contact.LastName AS LastName,
    CONCAT(FirstName," ", LastName) AS full_name,
    CONCAT(COALESCE(Title,'Dear'), ' ', LastName)  AS addressing_title,
    Contact.EmailAddress AS EmailAddress,
    Contact.Phone AS Phone,
    Customer.AccountNumber,
    Customer.CustomerType,
    Address.City AS City,
    Address.AddressLine1 AS AddressLine1,
    Address.AddressLine2 AS AddressLine2,
    StateProvince.Name AS State,
    CountryRegion.Name AS Country,
    COUNT (SalesOrderHeader.salesorderID) AS number_orders,
    ROUND(SUM(SalesOrderHeader.totalDue),3) AS total_amount,
    MAX(SalesOrderHeader.OrderDate) AS date_last_order
  FROM
    `adwentureworks_db.individual` Individual
  JOIN
    `adwentureworks_db.contact` Contact
  ON
    Individual.ContactID = Contact.ContactID
  JOIN
    `adwentureworks_db.customer` Customer
  ON
    Customer.CustomerID = Individual.CustomerID
  JOIN
    `adwentureworks_db.customeraddress` CustomerAddress
  ON
    CustomerAddress.CustomerID = Customer.CustomerID
  JOIN
    `adwentureworks_db.address` Address
  ON
    Address.AddressID = CustomerAddress.AddressID
  JOIN
    `adwentureworks_db.stateprovince` StateProvince
  ON
    StateProvince.StateProvinceID = Address.StateProvinceID
  JOIN
    `adwentureworks_db.countryregion` CountryRegion
  ON
    CountryRegion.CountryRegionCode = StateProvince.CountryRegionCode
  JOIN
    `adwentureworks_db.salesorderheader` SalesOrderHeader
  ON
    SalesOrderHeader.CustomerID = Customer.CustomerID
  GROUP BY
    CustomerID,
    FirstName,
    LastName,
    full_name,
    addressing_title,
    EmailAddress,
    Phone,
    AccountNumber,
    CustomerType,
    City,
    AddressLine1,
    AddressLine2,
    State,
    Country
  ORDER BY
    total_amount DESC )
SELECT
  CustomerOverview.*
FROM
  CustomerOverview
WHERE
  date_last_order < (
  SELECT
    DATE_SUB(MAX(SalesOrderHeader.OrderDate), INTERVAL 365 DAY)
  FROM
    `adwentureworks_db.salesorderheader` SalesOrderHeader )
LIMIT
  200


QUERY 1.3

WITH
  CustomerOverview AS (
  SELECT
    Individual.CustomerID AS CustomerID,
    Contact.FirstName AS FirstName,
    Contact.LastName AS LastName,
    CONCAT(FirstName," ", LastName) AS full_name,
    CONCAT(COALESCE(Title,'Dear'), ' ', LastName)  AS addressing_title,
    Contact.EmailAddress AS EmailAddress,
    Contact.Phone AS Phone,
    Customer.AccountNumber AS AccountNumber,
    Customer.CustomerType AS CustomerType,
    Address.City AS City,
    Address.AddressLine1 AS AddressLine1,
    Address.AddressLine2 AS AddressLine2,
    StateProvince.Name AS State,
    CountryRegion.Name AS Country,
    COUNT (SalesOrderHeader.salesorderID) AS number_orders,
    ROUND(SUM(SalesOrderHeader.totalDue),3) AS total_amount,
    MAX(SalesOrderHeader.OrderDate) AS date_last_order
  FROM
    `adwentureworks_db.individual` Individual
  JOIN
    `adwentureworks_db.contact` Contact
  ON
    Individual.ContactID = Contact.ContactID
  JOIN
    `adwentureworks_db.customer` Customer
  ON
    Customer.CustomerID = Individual.CustomerID
  JOIN
    `adwentureworks_db.customeraddress` CustomerAddress
  ON
    CustomerAddress.CustomerID = Customer.CustomerID
  JOIN
    `adwentureworks_db.address` Address
  ON
    Address.AddressID = CustomerAddress.AddressID
  JOIN
    `adwentureworks_db.stateprovince` StateProvince
  ON
    StateProvince.StateProvinceID = Address.StateProvinceID
  JOIN
    `adwentureworks_db.countryregion` CountryRegion
  ON
    CountryRegion.CountryRegionCode = StateProvince.CountryRegionCode
  JOIN
    `adwentureworks_db.salesorderheader` SalesOrderHeader
  ON
    SalesOrderHeader.CustomerID = Customer.CustomerID
  GROUP BY
    CustomerID,
    FirstName,
    LastName,
    full_name,
    addressing_title,
    EmailAddress,
    Phone,
    AccountNumber,
    CustomerType,
    City,
    AddressLine1,
    AddressLine2,
    State,
    Country
  ORDER BY
    total_amount DESC )
SELECT
  CustomerOverview.*,
  CASE
    WHEN CustomerOverview.date_last_order < ( SELECT DATE_SUB(MAX(SalesOrderHeader.OrderDate), INTERVAL 365 DAY) FROM `adwentureworks_db.salesorderheader` SalesOrderHeader) THEN "Inactive"
    ELSE "Active"
END
  AS Classification
FROM
  CustomerOverview
GROUP BY
  CustomerID,
  FirstName,
  LastName,
  full_name,
  addressing_title,
  EmailAddress,
  Phone,
  AccountNumber,
  CustomerType,
  City,
  AddressLine1,
  AddressLine2,
  State,
  Country,
  number_orders,
  total_amount,
  date_last_order
ORDER BY
  1 DESC
LIMIT
  500;


QUERY 1.4

WITH
  CustomerOverview AS (
  SELECT
    Individual.CustomerID AS CustomerID,
    Contact.FirstName AS FirstName,
    Contact.LastName AS LastName,
    CONCAT(FirstName," ", LastName) AS full_name,
    CONCAT(COALESCE(Title,'Dear'), ' ', LastName)  AS addressing_title,
    Contact.EmailAddress AS EmailAddress,
    Contact.Phone AS Phone,
    Customer.AccountNumber AS AccountNumber,
    Customer.CustomerType AS CustomerType,
    Address.City AS City,
    Address.AddressLine1 AS AddressLine1,
    Address.AddressLine2 AS AddressLine2,
    StateProvince.Name AS State,
    CountryRegion.Name AS Country,
    COUNT (SalesOrderHeader.salesorderID) AS number_orders,
    ROUND(SUM(SalesOrderHeader.totalDue),3) AS total_amount,
    MAX(SalesOrderHeader.OrderDate) AS date_last_order
  FROM
    `adwentureworks_db.individual` Individual
  JOIN
    `adwentureworks_db.contact` Contact
  ON
    Individual.ContactID = Contact.ContactID
  JOIN
    `adwentureworks_db.customer` Customer
  ON
    Customer.CustomerID = Individual.CustomerID
  JOIN
    `adwentureworks_db.customeraddress` CustomerAddress
  ON
    CustomerAddress.CustomerID = Customer.CustomerID
  JOIN
    `adwentureworks_db.address` Address
  ON
    Address.AddressID = CustomerAddress.AddressID
  JOIN
    `adwentureworks_db.stateprovince` StateProvince
  ON
    StateProvince.StateProvinceID = Address.StateProvinceID
  JOIN
    `adwentureworks_db.countryregion` CountryRegion
  ON
    CountryRegion.CountryRegionCode = StateProvince.CountryRegionCode
  JOIN
    `adwentureworks_db.salesorderheader` SalesOrderHeader
  ON
    SalesOrderHeader.CustomerID = Customer.CustomerID
  JOIN
    `adwentureworks_db.salesterritory` SalesTerritory
  ON
    SalesTerritory.TerritoryID = Customer.TerritoryID
  WHERE
    SalesTerritory.Group = 'North America'
  GROUP BY
    CustomerID,
    FirstName,
    LastName,
    full_name,
    addressing_title,
    EmailAddress,
    Phone,
    AccountNumber,
    CustomerType,
    City,
    AddressLine1,
    AddressLine2,
    State,
    Country )
SELECT
  CustomerOverview.*,
  CASE
    WHEN CustomerOverview.date_last_order < ( SELECT DATE_SUB(MAX(SalesOrderHeader.OrderDate), INTERVAL 365 DAY) FROM `adwentureworks_db.salesorderheader` SalesOrderHeader) THEN "Inactive"
    ELSE "Active"
END
  AS Classification,
  LEFT(CustomerOverview.AddressLine1, STRPOS(CustomerOverview.AddressLine1, ' ')-1) AS address_no,
  RIGHT(CustomerOverview.AddressLine1, LENGTH(CustomerOverview.AddressLine1) - STRPOS(CustomerOverview.AddressLine1, ' ')) AS address_st
FROM
  CustomerOverview
WHERE
  CustomerOverview.date_last_order > (
  SELECT
    DATE_SUB(MAX(SalesOrderHeader.OrderDate), INTERVAL 365 DAY)
  FROM
    `adwentureworks_db.salesorderheader` SalesOrderHeader)
  AND (CustomerOverview.total_amount > 2500
    OR CustomerOverview.number_orders >= 5)
GROUP BY
  CustomerID,
  FirstName,
  LastName,
  full_name,
  addressing_title,
  EmailAddress,
  Phone,
  AccountNumber,
  CustomerType,
  City,
  AddressLine1,
  AddressLine2,
  State,
  Country,
  number_orders,
  total_amount,
  date_last_order
ORDER BY
  State,
  Country,
  date_last_order


QUERY 2.1

SELECT
  LAST_DAY(DATE(SalesOrderHeader.OrderDate)) AS order_month,
  SalesTerritory.CountryRegionCode,
  SalesTerritory.Name AS Region,
  COUNT( SalesOrderHeader.SalesOrderID) AS number_orders,
  COUNT (DISTINCT SalesOrderHeader.CustomerID) AS number_customers,
  COUNT (DISTINCT SalesOrderHeader.SalesPersonID) AS number_salespersons,
  CAST(ROUND(SUM(SalesOrderHeader.TotalDue)) AS int) AS Total_w_tax
FROM
  `adwentureworks_db.salesorderheader` SalesOrderHeader
JOIN
  `adwentureworks_db.salesterritory` SalesTerritory
ON
  SalesOrderHeader.TerritoryID = SalesTerritory.TerritoryID
GROUP BY
  order_month,
  CountryRegionCode,
  Region


QUERY 2.2

WITH
  SalesDetail AS (
  SELECT
    LAST_DAY(DATE(SalesOrderHeader.OrderDate)) AS order_month,
    SalesTerritory.CountryRegionCode,
    SalesTerritory.Name AS Region,
    COUNT( SalesOrderHeader.SalesOrderID) AS number_orders,
    COUNT (DISTINCT SalesOrderHeader.CustomerID) AS number_customers,
    COUNT (DISTINCT SalesOrderHeader.SalesPersonID) AS number_salespersons,
    CAST(ROUND(SUM(SalesOrderHeader.TotalDue)) AS int) AS Total_w_tax
  FROM
    `adwentureworks_db.salesorderheader` SalesOrderHeader
  JOIN
    `adwentureworks_db.salesterritory` SalesTerritory
  ON
    SalesOrderHeader.TerritoryID = SalesTerritory.TerritoryID
  GROUP BY
    order_month,
    CountryRegionCode,
    Region )
SELECT
  SalesDetail.order_month,
  SalesDetail.CountryRegionCode,
  SalesDetail.Region,
  SalesDetail.number_orders,
  SalesDetail.number_customers,
  SalesDetail.number_salespersons,
  SalesDetail.Total_w_tax,
  SUM(SalesDetail.Total_w_tax) OVER (PARTITION BY SalesDetail.CountryRegionCode, SalesDetail.Region ORDER BY SalesDetail.order_month) AS cumulative_sum
FROM
  SalesDetail
GROUP BY
  SalesDetail.order_month,
  SalesDetail.CountryRegionCode,
  SalesDetail.Region,
  SalesDetail.number_orders,
  SalesDetail.number_customers,
  SalesDetail.number_salespersons,
  SalesDetail.Total_w_tax


QUERY 2.3

WITH
  SalesDetail AS (
  SELECT
    LAST_DAY(DATE(SalesOrderHeader.OrderDate)) AS order_month,
    SalesTerritory.CountryRegionCode,
    SalesTerritory.Name AS Region,
    COUNT( SalesOrderHeader.SalesOrderID) AS number_orders,
    COUNT (DISTINCT SalesOrderHeader.CustomerID) AS number_customers,
    COUNT (DISTINCT SalesOrderHeader.SalesPersonID) AS number_salespersons,
    CAST(ROUND(SUM(SalesOrderHeader.TotalDue)) AS int) AS Total_w_tax
  FROM
    `adwentureworks_db.salesorderheader` SalesOrderHeader
  JOIN
    `adwentureworks_db.salesterritory` SalesTerritory
  ON
    SalesOrderHeader.TerritoryID = SalesTerritory.TerritoryID
  GROUP BY
    order_month,
    CountryRegionCode,
    Region )
SELECT
  SalesDetail.order_month,
  SalesDetail.CountryRegionCode,
  SalesDetail.Region,
  SalesDetail.number_orders,
  SalesDetail.number_customers,
  SalesDetail.number_salespersons,
  SalesDetail.Total_w_tax,
  RANK() OVER (PARTITION BY SalesDetail.CountryRegionCode, SalesDetail.Region ORDER BY SalesDetail.Total_w_tax DESC) AS country_sales_rank,
  SUM(SalesDetail.Total_w_tax) OVER (PARTITION BY SalesDetail.CountryRegionCode, SalesDetail.Region ORDER BY SalesDetail.order_month) AS cumulative_sum
FROM
  SalesDetail
#WHERE  SalesDetail.Region = 'France'
GROUP BY
  SalesDetail.order_month,
  SalesDetail.CountryRegionCode,
  SalesDetail.Region,
  SalesDetail.number_orders,
  SalesDetail.number_customers,
  SalesDetail.number_salespersons,
  SalesDetail.Total_w_tax
ORDER BY 
country_sales_rank,
SalesDetail.order_month


QUERY 2.4

WITH
  SalesDetail AS (
  SELECT
    LAST_DAY(DATE(SalesOrderHeader.OrderDate)) AS order_month,
    SalesTerritory.CountryRegionCode,
    SalesTerritory.Name AS Region,
    COUNT( SalesOrderHeader.SalesOrderID) AS number_orders,
    COUNT (DISTINCT SalesOrderHeader.CustomerID) AS number_customers,
    COUNT (DISTINCT SalesOrderHeader.SalesPersonID) AS number_salespersons,
    CAST(ROUND(SUM(SalesOrderHeader.TotalDue)) AS int) AS Total_w_tax
  FROM
    `adwentureworks_db.salesorderheader` SalesOrderHeader
  JOIN
    `adwentureworks_db.salesterritory` SalesTerritory
  ON
    SalesOrderHeader.TerritoryID = SalesTerritory.TerritoryID
  GROUP BY
    order_month,
    CountryRegionCode,
    Region ),

  TaxDetail AS (
  SELECT
    StateProvince.CountryRegionCode AS CountryRegion,
    ROUND(AVG(MaxTaxRate.TaxRate), 2) AS mean_tax_rate,
    ROUND(COUNT(DISTINCT MaxTaxRate.StateProvinceID) / COUNT( DISTINCT StateProvince.StateProvinceID), 2) AS perc_provinces_w_tax

  FROM
    `adwentureworks_db.stateprovince` StateProvince  
  LEFT JOIN 
  (SELECT SalesTaxRate.StateProvinceID, MAX (SalesTaxRate.TaxRate) TaxRate
  FROM `adwentureworks_db.salestaxrate` SalesTaxRate
  GROUP BY SalesTaxRate.StateProvinceID) AS MaxTaxRate
  ON 
    MaxTaxRate.StateProvinceID = StateProvince.StateProvinceID
  GROUP BY
    CountryRegion

)

SELECT
  SalesDetail.order_month,
  SalesDetail.CountryRegionCode,
  SalesDetail.Region,
  SalesDetail.number_orders,
  SalesDetail.number_customers,
  SalesDetail.number_salespersons,
  SalesDetail.Total_w_tax,
  RANK() OVER (PARTITION BY SalesDetail.CountryRegionCode, SalesDetail.Region ORDER BY SalesDetail.Total_w_tax DESC) AS country_sales_rank,
  SUM(SalesDetail.Total_w_tax) OVER (PARTITION BY SalesDetail.CountryRegionCode, SalesDetail.Region ORDER BY SalesDetail.order_month) AS cumulative_sum,
  TaxDetail.mean_tax_rate,
  TaxDetail.perc_provinces_w_tax

FROM
  SalesDetail
JOIN
 TaxDetail
ON SalesDetail.CountryRegionCode = TaxDetail.CountryRegion
#WHERE SalesDetail.CountryRegionCode = 'US'

GROUP BY
  SalesDetail.order_month,
  SalesDetail.CountryRegionCode,
  SalesDetail.Region,
  SalesDetail.number_orders,
  SalesDetail.number_customers,
  SalesDetail.number_salespersons,
  SalesDetail.Total_w_tax,
  TaxDetail.mean_tax_rate,
  TaxDetail.perc_provinces_w_tax

ORDER BY
country_sales_rank,
SalesDetail.order_month