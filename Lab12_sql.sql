--adventure works dataset-- 
SELECT * FROM 
-- is the basic format of commands in sql. 

SELECT * 
FROM Categories;

SELECT CustomerID, 
       CompanyName, 
       Country 
FROM Customers
     WHERE Country = 'Germany' OR Country = 'France'
     ORDER BY Country;
--default sort is ascending, descending is DESC

SELECT DISTINCT Country 
FROM Customers;

SELECT customerID,
       CompanyNAme,       
       Country       
FROM Customers
     WHERE lower(Country) IN ('Germany','France', 'Spain')
     ORDER BY Country DESC;
--the above command is can be done by indexing                           
SELECT customerID,
       CompanyName,       
       Country       
FROM Customers 
     WHERE lower(Country) IN ('Germany','France', 'Spain')     
     ORDER BY 3 DESC;     

SELECT *
FROM [Order Details] LIMIT 10;
--here we use square brackets because table order details has two words with a 
--space in the middle

SELECT OrderID,
       SUM(quantity * UnitPrice) AS [Total Sales],       
       AVG(quantity * UnitPrice) AS Average,       
       ROUND(MAX(UnitPrice)) AS Maximum,       
       ROUND(MIN(UnitPrice)) AS Minimum,       
       COUNT(orderID),       
       COUNT(DISTINCT OrderID)              
FROM [Order Details] 
     GROUP BY orderID;
--in this case, the only distinct piece of info is ID,
--the rest are aggregate values so for each single ID,
--the return is aggregate metrics across

--NULL is like NA value in R. Doesn't work with math
--Look for NULL values by doing this

SELECT * FROM Orders WHERE quantity IS NULL;
SELECT * FROM Orders WHERE quantity IS NOT NULL;

SELECT DISTINCT OrderID
FROM [Order Details];

SELECT COUNT(*) 
FROM [Order Details];

SELECT Orders.OrderID, 
       CustomerID,       
       lineNo        
FROM Orders, [Order Details]
     WHERE Orders.OrderID = Details.OrderID;     

-- CAST(Order.orderID AS STRING) this is the same as
-- as.numeric/as.string in R 

SELECT Orders.OrderID,
       CustomerID,       
       quantity       
FROM Orders
     JOIN [Order Details] ON (Orders.OrderID = [Order Details].OrderID);     

--you can assign aliaes to save some typing 
SELECT Orders.OrderID,
       CustomerID,       
       quantity       
FROM Orders a
     JOIN [Order Details] b ON (a.OrderID = b.OrderID);     

--this above command can be further simplified into
SELECT Orders.OrderID, 
       CustomerID,       
       quantity       
FROM Orders a 
     JOIN [Order Details] b     
     USING (OrderId);     

--order of operations in SQL
--order of syntax writing
--1. SELECT
--2. FROM
--3. WHERE 
--3.5. HAVING
--4. GROUP BY
--5. ORDER BY
--order of run 
--1. FROM
--2. WHERE
--3. GROUP BY
--4. SELECT
--5. ORDER

--if you are using aggregate commands, 
--everything else that is not aggregated in SELECT should 
--be included in the GROUP BY section

SELECT orders.orderid, cust.companyname, sum(detalis.unitprice * detials quantity)
FROM orders
JOIN customers cust USING (customerID)
JOIN [order details] details using (Order ID)
GROUP BY details.[orderID], cust.companyName;

--the order in which you join is important because anything that has missing data on joins get dropped 

SELECT orders.orderid, cust.companyname, summed[Total Sales]
FROM orders
JOIN customers cust USING (customerID)
JOIN (SELECT OrderID, sum(UnitPrice * quantity) AS [Total Sales]
FROM [Order Details]
GROUP BY orderID) summed
USINg (orderID);


SELECT unitprice, total, unitprice / total
FROM [Order Detals] a 
JOIN (SELECT sum(Unitprice) total FROM [Order Details]) b;

SELECT 18.94/573753.98; 
FROM(
SELECT min(n), max(n)
SELECT orderID, count(*) n,
FROM [Order Details]
GROUP BY orderid 
HAVING count(*) >2 );





SELECT CompanyName, OrderID FROM Customers LEFT JOIN Orders
 ON Customers.CustomerID = Orders.CustomerID; 

SELECT CompanyName, OrderID FROM Customers INNER JOIN Orders
 ON Customers.CustomerID = Orders.CustomerID; 

SELECT CompanyName, OrderID FROM Customers OUTER JOIN Orders
 ON Customers.CustomerID = Orders.CustomerID; 

SELECT CustomerID, DivisionName FROM Customers LEFT JOIN Divisions
 ON Customers.DivisionID = Divisions.DivisionID;

SELECT DivisionName FROM Divisions LEFT JOIN Customers
 ON Divisions.DivisionID = Customers.DivisionID;

SELECT ContactName, CompanyName FROM Orders LEFT JOIN Customers
 ON Orders.CustomerID = Customers.CustomerID; 
 WHERE Orders.CustomerID Is NULL

