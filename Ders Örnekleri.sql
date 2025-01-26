-- SQL SERVER SCRIPTS
-- DQL => Data Query Language
-- DML => Data manipulation Language
-- DDL => Data Definition Language 
-- DCL => Data Control Language

-- DQL : DATA QUERY LANGUAGE
SELECT 4 + 5

SELECT 678 AS [Number], 'Can' AS [FirstName], 'Perk' AS [LastName]
UNION
SELECT 194, 'Mücahit', 'Bak'
UNION
SELECT 273, 'Uður', 'Dirgen'

SELECT GETDATE() AS [Current Date]

GO

SELECT * FROM Employees

SELECT FirstName, LastName, HomePhone FROM Employees

SELECT FirstName, LastName, HomePhone FROM Employees
ORDER BY FirstName ASC

GO
SELECT FirstName + ' ' + LastName AS FullName, HireDate FROM Employees
SELECT FirstName, LastName, BirthDate FROM Employees
SELECT FirstName, LastName, DATEDIFF(YEAR, BirthDate, GETDATE()) FROM Employees

SELECT ContactName, Country FROM Customers
WHERE Country = 'USA'

SELECT ProductName, UnitPrice, UnitsInStock FROM Products WHERE UnitPrice < 20

SELECT ProductName, UnitPrice, UnitsInStock FROM Products 
WHERE UnitPrice > 20 AND UnitPrice < 30

SELECT ProductName, UnitPrice, UnitsInStock FROM Products 
WHERE UnitPrice BETWEEN 20 AND 30

SELECT * FROM Categories
SELECT * FROM Customers

-- PRIMARY KEY : Satýrlar birbirinden ayýrmaya yarayan benzersiz deðer

--Ürüleri fiyat ve stok bilgisine göre en çok deðer önce gelecek þekilde listele
SELECT ProductName, UnitPrice * UnitsInStock AS [Summary] FROM Products
ORDER BY [Summary] DESC

-- Yaþlýdan gence personel listesi
SELECT FirstName, LastName, BirthDate FROM Employees
ORDER BY BirthDate ASC

-- Stokta kalmayan ürünler
SELECT ProductName, UnitsInStock FROM Products
WHERE UnitsInStock = 0

-- Kritik seviyede stok uyarýsý veren ürünler
SELECT ProductName, UnitsInStock FROM Products
WHERE UnitsInStock < 10 AND UnitsInStock > 0
ORDER BY UnitsInStock DESC

--Berlin'deki ürün tedarikçilerinin telefon numaralarý
SELECT CompanyName, Phone FROM Suppliers
WHERE Country = 'Germany' AND City = 'Berlin'

-- Adý An ile baþlayan müþteriler
SELECT ContactName FROM Customers
WHERE ContactName LIKE 'an%'

-- ARAÞTIR: Database Collations

-- Adý O ile biten müþteriler
SELECT ContactName FROM Customers
WHERE ContactName LIKE '%o'

-- Tablo birleþtirme iþlemleri (UNION)

-- Telefon Rehberi
SELECT 
	FirstName + ' ' + LastName AS FullName, 
	HomePhone AS PhoneNumber,
	'Çalýþan' AS [Type]
FROM Employees
UNION
SELECT ContactName, Phone, 'Müþteri' AS [Type] FROM Customers
UNION
SELECT ContactName, Phone, 'Tedarikçi' AS [Type] FROM Suppliers
ORDER BY FullName

-- Tablo birleþtirme iþlemleri (JOIN)
SELECT p.ProductName, p.UnitPrice, c.CategoryName
FROM Products AS p
INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID

-- Ýçecek olan ürünler
--Çözüm 1
SELECT ProductName, UnitPrice
FROM Products
WHERE CategoryID = 1

--Çözüm 2
SELECT p.ProductName, p.UnitPrice
FROM Products AS p
INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID
WHERE c.CategoryID = 1

--Çözüm 3 -- Önerilmez
SELECT p.ProductName, p.UnitPrice
FROM Products AS p
INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Beverages'

-- FOREIGN KEY : Baþka bir tablodan alýnan PRIMARY KEY'in mevcut tabloda kullanýldýðý hal
SELECT 
	p.ProductName, 
	od.UnitPrice, 
	od.Quantity, 
	od.UnitPrice * od.Quantity AS Summary, 
	o.OrderDate 
FROM [Order Details] AS od
INNER JOIN Products AS p ON od.ProductID = p.ProductID
INNER JOIN Orders AS o ON od.OrderID = o.OrderID
WHERE o.OrderID = 10260

--- Verilen sipariþ numarasýna göre hangi personelin hangi müþteriye satýþ yaptýðýný gösteren sorgu
SELECT 
	CONCAT(e.FirstName, ' ', e.LastName) Employee,
	c.ContactName Customer
FROM Orders o
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.OrderID = 10251

--- 1997 Ocak ayýnda Almanya'ya yapýlan sipariþlerin numaralarý ve 
--- sipariþ tarihleri ve sevkiyat tarihleri
SELECT o.OrderID, o.OrderDate, o.ShippedDate
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE 
	o.OrderDate BETWEEN '1997-01-01 00:00:00' AND '1997-01-31 23:59:59' AND
	c.Country = 'Germany'

-- Ernst Handel firmasýnýn 1997 yýlýnda verdiði sipariþler
SELECT o.OrderID, o.OrderDate FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE 
	YEAR(o.OrderDate) = 1997 AND c.CompanyName = 'Ernst Handel'

-- Ýçecek kategorisinde Nancy'nin sattýðý ürünler 
-- ve tarihe göre elde edilen gelir
-- Cool Yöntem
SELECT 
	  o.OrderDate, 
	  od.Quantity * od.UnitPrice Summary
FROM [Order Details] od
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE p.CategoryID = 1 AND 
	  o.EmployeeID = 1

-- Keko Yöntem
SELECT 
	  o.OrderDate, 
	  od.Quantity * od.UnitPrice Summary
FROM [Order Details] od
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE c.CategoryName = 'Beverages' AND 
	  e.FirstName = 'Nancy' AND
	  e.LastName = 'Davolio'

-- INNER SELECT QUERY : SUBQUERY
SELECT 
	  o.OrderDate, 
	  od.Quantity * od.UnitPrice Summary
FROM [Order Details] od
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE p.CategoryID = (
			SELECT CategoryID FROM Categories 
			WHERE CategoryName = 'Beverages'
	  ) AND 
	  o.EmployeeID = (
			SELECT EmployeeID FROM Employees
			WHERE FirstName = 'Nancy' AND LastName = 'Davolio'
	  )
-- PRO Yöntem
DECLARE @CategoryId INT;
DECLARE @EmployeeId INT;
SET @CategoryId = (
			SELECT CategoryID FROM Categories 
			WHERE CategoryName = 'Beverages'
	  );
SET @EmployeeId = (
			SELECT EmployeeID FROM Employees
			WHERE FirstName = 'Nancy' AND LastName = 'Davolio'
	  )
SELECT 
	  o.OrderDate, 
	  od.Quantity * od.UnitPrice Summary
FROM [Order Details] od
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE p.CategoryID = @CategoryId AND 
	  o.EmployeeID = @EmployeeId

-- Müþteriye göre bir sipariþin detayý
-- DOðrudan ID ile eriþim
SELECT p.ProductName, od.UnitPrice * od.Quantity Summary
FROM [Order Details] od
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Orders o ON od.OrderID = o.OrderID
WHERE o.CustomerID = 'ALFKI'

-- Mecburen SUBQUERY ile eriþim
SELECT p.ProductName, od.UnitPrice * od.Quantity Summary
FROM [Order Details] od
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Orders o ON od.OrderID = o.OrderID
WHERE o.CustomerID = (SELECT CustomerID FROM Customers WHERE CompanyName = 'Alfreds Futterkiste')

-- BÝR JOIN DAHA EKLERSEK - CHATGPT BUNA DESTEK VERDÝ :D
SELECT p.ProductName, od.UnitPrice * od.Quantity Summary
FROM [Order Details] od
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE c.CompanyName = 'Alfreds Futterkiste'


-- Denver bölgesine yapýlan satýþlar ve satýþý yapan personel ile 
-- müþteri firma adý ve telefon bilgisi
SELECT 
	CONCAT(e.FirstName, ' ', e.LastName) Employee,
	c.CompanyName,
	c.ContactName,
	c.Phone
FROM Employees e
INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN EmployeeTerritories et ON e.EmployeeID = et.EmployeeID
INNER JOIN Territories t ON et.TerritoryID = t.TerritoryID
WHERE t.TerritoryDescription = 'Denver'

-- AGGREGATE FUNCTIONS
-- Ürünler arasýndaki en yüksek etiket fiyatý
SELECT MAX(UnitPrice) FROM Products
SELECT TOP 1 UnitPrice FROM Products ORDER BY UnitPrice DESC

SELECT MIN(UnitPrice) FROM Products
-- 1997 Ocak ayýndaki sipariþlerin toplam cirosu
SELECT SUM(od.UnitPrice * od.Quantity) FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997 AND MONTH(o.OrderDate) = 1

-- 1997 Ocak ayýndaki sipariþlerin sipariþ bazlý ara toplamlarý
SELECT o.OrderID, SUM(od.UnitPrice * od.Quantity) FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997 AND MONTH(o.OrderDate) = 1
GROUP BY o.OrderID

-- 1997 Ocak ayýndaki sipariþlerin gün bazlý ara toplamlarý
SELECT o.OrderDate, SUM(od.UnitPrice * od.Quantity) FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997 AND MONTH(o.OrderDate) = 1
GROUP BY o.OrderDate

-- 1997 Ocak ayýnda Ürün bazlý cirolar
SELECT 
	p.ProductName, 
	SUM(od.UnitPrice * od.Quantity) Amount 
FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE YEAR(o.OrderDate) = 1997 AND MONTH(o.OrderDate) = 1
GROUP BY p.ProductName
ORDER BY Amount DESC

-- docker run --name dockersql -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=1q2w3e4R!" -p 11433:1433 -d mcr.microsoft.com/mssql/server:2022-latest