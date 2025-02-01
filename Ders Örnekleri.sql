-- SQL SERVER SCRIPTS
-- DQL => Data Query Language
-- DML => Data manipulation Language
-- DDL => Data Definition Language 
-- DCL => Data Control Language

-- DQL : DATA QUERY LANGUAGE
SELECT 4 + 5

SELECT 678 AS [Number], 'Can' AS [FirstName], 'Perk' AS [LastName]
UNION
SELECT 194, 'M�cahit', 'Bak'
UNION
SELECT 273, 'U�ur', 'Dirgen'

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

-- PRIMARY KEY : Sat�rlar birbirinden ay�rmaya yarayan benzersiz de�er

--�r�leri fiyat ve stok bilgisine g�re en �ok de�er �nce gelecek �ekilde listele
SELECT ProductName, UnitPrice * UnitsInStock AS [Summary] FROM Products
ORDER BY [Summary] DESC

-- Ya�l�dan gence personel listesi
SELECT FirstName, LastName, BirthDate FROM Employees
ORDER BY BirthDate ASC

-- Stokta kalmayan �r�nler
SELECT ProductName, UnitsInStock FROM Products
WHERE UnitsInStock = 0

-- Kritik seviyede stok uyar�s� veren �r�nler
SELECT ProductName, UnitsInStock FROM Products
WHERE UnitsInStock < 10 AND UnitsInStock > 0
ORDER BY UnitsInStock DESC

--Berlin'deki �r�n tedarik�ilerinin telefon numaralar�
SELECT CompanyName, Phone FROM Suppliers
WHERE Country = 'Germany' AND City = 'Berlin'

-- Ad� An ile ba�layan m��teriler
SELECT ContactName FROM Customers
WHERE ContactName LIKE 'an%'

-- ARA�TIR: Database Collations

-- Ad� O ile biten m��teriler
SELECT ContactName FROM Customers
WHERE ContactName LIKE '%o'

-- Tablo birle�tirme i�lemleri (UNION)

-- Telefon Rehberi
SELECT 
	FirstName + ' ' + LastName AS FullName, 
	HomePhone AS PhoneNumber,
	'�al��an' AS [Type]
FROM Employees
UNION
SELECT ContactName, Phone, 'M��teri' AS [Type] FROM Customers
UNION
SELECT ContactName, Phone, 'Tedarik�i' AS [Type] FROM Suppliers
ORDER BY FullName

-- Tablo birle�tirme i�lemleri (JOIN)
SELECT p.ProductName, p.UnitPrice, c.CategoryName
FROM Products AS p
INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID

-- ��ecek olan �r�nler
--��z�m 1
SELECT ProductName, UnitPrice
FROM Products
WHERE CategoryID = 1

--��z�m 2
SELECT p.ProductName, p.UnitPrice
FROM Products AS p
INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID
WHERE c.CategoryID = 1

--��z�m 3 -- �nerilmez
SELECT p.ProductName, p.UnitPrice
FROM Products AS p
INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Beverages'

-- FOREIGN KEY : Ba�ka bir tablodan al�nan PRIMARY KEY'in mevcut tabloda kullan�ld��� hal
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

--- Verilen sipari� numaras�na g�re hangi personelin hangi m��teriye sat�� yapt���n� g�steren sorgu
SELECT 
	CONCAT(e.FirstName, ' ', e.LastName) Employee,
	c.ContactName Customer
FROM Orders o
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.OrderID = 10251

--- 1997 Ocak ay�nda Almanya'ya yap�lan sipari�lerin numaralar� ve 
--- sipari� tarihleri ve sevkiyat tarihleri
SELECT o.OrderID, o.OrderDate, o.ShippedDate
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE 
	o.OrderDate BETWEEN '1997-01-01 00:00:00' AND '1997-01-31 23:59:59' AND
	c.Country = 'Germany'

-- Ernst Handel firmas�n�n 1997 y�l�nda verdi�i sipari�ler
SELECT o.OrderID, o.OrderDate FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE 
	YEAR(o.OrderDate) = 1997 AND c.CompanyName = 'Ernst Handel'

-- ��ecek kategorisinde Nancy'nin satt��� �r�nler 
-- ve tarihe g�re elde edilen gelir
-- Cool Y�ntem
SELECT 
	  o.OrderDate, 
	  od.Quantity * od.UnitPrice Summary
FROM [Order Details] od
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE p.CategoryID = 1 AND 
	  o.EmployeeID = 1

-- Keko Y�ntem
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
-- PRO Y�ntem
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

-- M��teriye g�re bir sipari�in detay�
-- DO�rudan ID ile eri�im
SELECT p.ProductName, od.UnitPrice * od.Quantity Summary
FROM [Order Details] od
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Orders o ON od.OrderID = o.OrderID
WHERE o.CustomerID = 'ALFKI'

-- Mecburen SUBQUERY ile eri�im
SELECT p.ProductName, od.UnitPrice * od.Quantity Summary
FROM [Order Details] od
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Orders o ON od.OrderID = o.OrderID
WHERE o.CustomerID = (SELECT CustomerID FROM Customers WHERE CompanyName = 'Alfreds Futterkiste')

-- B�R JOIN DAHA EKLERSEK - CHATGPT BUNA DESTEK VERD� :D
SELECT p.ProductName, od.UnitPrice * od.Quantity Summary
FROM [Order Details] od
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE c.CompanyName = 'Alfreds Futterkiste'


-- Denver b�lgesine yap�lan sat��lar ve sat��� yapan personel ile 
-- m��teri firma ad� ve telefon bilgisi
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
-- MIN MAX SUM AVG COUNT
-- �r�nler aras�ndaki en y�ksek etiket fiyat�
SELECT MAX(UnitPrice) FROM Products
SELECT TOP 1 UnitPrice FROM Products ORDER BY UnitPrice DESC

SELECT MIN(UnitPrice) FROM Products
-- 1997 Ocak ay�ndaki sipari�lerin toplam cirosu
SELECT SUM(od.UnitPrice * od.Quantity) FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997 AND MONTH(o.OrderDate) = 1

-- 1997 Ocak ay�ndaki sipari�lerin sipari� bazl� ara toplamlar�
SELECT o.OrderID, SUM(od.UnitPrice * od.Quantity) FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997 AND MONTH(o.OrderDate) = 1
GROUP BY o.OrderID

-- 1997 Ocak ay�ndaki sipari�lerin g�n bazl� ara toplamlar�
SELECT o.OrderDate, SUM(od.UnitPrice * od.Quantity) FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997 AND MONTH(o.OrderDate) = 1
GROUP BY o.OrderDate

-- 1997 Ocak ay�nda �r�n bazl� cirolar
SELECT 
	p.ProductName, 
	SUM(od.UnitPrice * od.Quantity) Amount 
FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE YEAR(o.OrderDate) = 1997 AND MONTH(o.OrderDate) = 1
GROUP BY p.ProductName
ORDER BY Amount DESC

-- docker (podman) run --name dockersql -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=1q2w3e4R!" -p 11433:1433 -d mcr.microsoft.com/mssql/server:2022-latest
--SQL Server Management Studio

-- Ka� �r�n sat�lmaktad�r
SELECT COUNT(0) AS ProductCount FROM Products

-- Stokta olan �r�n adedi
SELECT COUNT(0) FROM Products
WHERE UnitsInStock > 0

-- Kategoriye g�re �r�n adedi
SELECT CategoryId, COUNT(0) ProductCount FROM Products
GROUP BY CategoryID
ORDER BY 2 DESC -- 2. kolona g�re tersten s�rala

SELECT c.CategoryName, COUNT(0) ProductCount 
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY CategoryName
ORDER BY ProductCount DESC -- 2. kolona g�re tersten s�rala

-- Stokta toplam ka� paral�k �r�n var
SELECT SUM(UnitPrice * UnitsInStock) AS Summary FROM Products

--1997 y�l�nda al�nan sipari�lerin toplam cirosu
SELECT SUM(od.UnitPrice * od.Quantity) Summary
FROM [Order Details] od
INNER JOIN Orders o ON od.OrderId = o.OrderID
WHERE YEAR(o.OrderDate) = 1997

--Y�ll�k sipari�leri toplam cirosu
SELECT YEAR(o.OrderDate) AS [Year], SUM(od.UnitPrice * od.Quantity) Summary
FROM [Order Details] od
INNER JOIN Orders o ON od.OrderId = o.OrderID
GROUP BY YEAR(o.OrderDate)
ORDER BY 1

--1997 y�l�nda m��teriye g�re sipari� cirosu
SELECT c.CompanyName, SUM(od.UnitPrice * od.Quantity) Summary 
FROM [Order Details] od
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 1997
GROUP BY c.CompanyName
ORDER BY CompanyName

--1997 y�l�nda 10000 ve �zeri sipari� veren m��teriler ve sipari� tutarlar�
-- Y�ntem 1
SELECT CompanyName, Summary 
FROM (
	SELECT c.CompanyName, SUM(od.UnitPrice * od.Quantity) Summary 
	FROM [Order Details] od
	INNER JOIN Orders o ON od.OrderID = o.OrderID
	INNER JOIN Customers c ON o.CustomerID = c.CustomerID
	WHERE YEAR(o.OrderDate) = 1997
	GROUP BY c.CompanyName
) AS Customers
WHERE Summary >= 10000
ORDER BY Summary DESC

-- Cool Y�ntem
SELECT c.CompanyName, SUM(od.UnitPrice * od.Quantity) Summary 
FROM [Order Details] od
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 1997
GROUP BY c.CompanyName
HAVING (SUM(od.UnitPrice * od.Quantity) > 10000) -- AGGREGATE FUNCTION i�in filtre yapma
ORDER BY Summary DESC

-- 
SELECT 
	ROW_NUMBER() OVER (ORDER BY od.OrderID ASC) AS OrderGroup, 
	od.OrderID, 
	p.ProductName, 
	od.UnitPrice * od.Quantity Summary
FROM [Order Details] od
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE o.CustomerID = 'ALFKI'

SELECT 
	od.OrderID, 
	ROW_NUMBER() OVER (PARTITION BY od.OrderID ORDER BY p.ProductName) AS OrderGroup, 
	p.ProductName, 
	od.UnitPrice * od.Quantity Summary
FROM [Order Details] od
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE o.CustomerID = 'ANTON'

-- �r�nleri kategorisine g�re gruplama
SELECT 
	ROW_NUMBER() OVER (PARTITION BY c.CategoryName ORDER BY p.ProductName) Number,
	c.CategoryName, 
	p.ProductName 
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
ORDER BY c.CategoryName

-- En y�ksek sat��a sahip 5 �r�n
--Y�ntem 1
SELECT TOP 5 WITH TIES -- Son de�er ayn� ise e�it olanlar� da getirir dolay�s� ile 5 yerine 6-7 kay�t d�nebilir
	p.ProductName, 
	SUM(od.UnitPrice * od.Quantity) Summary 
FROM [Order Details] od
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY Summary DESC

SELECT ProductName, Summary FROM (
	SELECT 
		ROW_NUMBER() OVER (ORDER BY SUM(od.UnitPrice * od.Quantity) DESC) [Rank],
		p.ProductName, 
		SUM(od.UnitPrice * od.Quantity) Summary 
	FROM [Order Details] od
	INNER JOIN Products p ON od.ProductID = p.ProductID
	GROUP BY p.ProductName
) AS Orders
WHERE [Rank] <= 5 

-- CTE : Commo Table Expressions
WITH PL AS 
(
	SELECT ProductId AS Id, ProductName AS Name, CategoryName AS Category
	FROM Products p
	INNER JOIN Categories c ON p.CategoryID = c.CategoryID
	WHERE c.CategoryName = 'Beverages'
)

SELECT *
FROM [Order Details] od
INNER JOIN PL p ON od.ProductID = p.Id

-- Almanya'ki m��terilerin sipari�lerinin toplam kazanc�
WITH CUS AS (
	SELECT CustomerID FROM Customers WHERE Country = 'Germany'
)

SELECT SUM (od.UnitPrice * od.Quantity) Summary FROM [Order Details] od
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN CUS c ON o.CustomerID = c.CustomerID

-- Her bir m��terinin toplam harcamas� ile en �ok sipari� verdi�i 
-- �r�n kategorisi ve son sipari� tarihi

WITH CustSum AS (
	-- Her m��terinin toplam al��veri�i
	SELECT 
		o.CustomerID, 
		SUM(od.Quantity * od.UnitPrice) AS Summary,
		MAX(o.OrderDate) AS LastOrderDate
	FROM [Order Details] od
	INNER JOIN Orders o ON od.OrderID = o.OrderID
	GROUP BY o.CustomerID
),

CustCat AS (
	-- her m��terinin en �ok sipari� verdi�i kategoriye g�re s�rala
	SELECT 
		ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY COUNT(p.ProductID) DESC) AS Sira,
		o.CustomerID, 
		p.CategoryID, 
		COUNT(p.ProductID) AS Summary
	FROM [Order Details] od
	INNER JOIN Orders o ON od.OrderID = o.OrderID
	INNER JOIN Products p ON od.ProductID = p.ProductID
	GROUP BY o.CustomerID, p.CategoryID
)

SELECT s.CustomerID, s.Summary, ct.CategoryName, s.LastOrderDate FROM CustSum s
INNER JOIN CustCat c ON s.CustomerID = c.CustomerID
INNER JOIN Categories ct ON c.CategoryID = ct.CategoryID
WHERE c.Sira = 1 and s.Summary > 10000
ORDER BY s.Summary DESC

SELECT * FROM Categories
SELECT * FROM Products WHERE CategoryID = 9
SELECT * FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
--INNER JOIN
SELECT p.ProductName, c.CategoryName FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
--LEFT JOIN
SELECT p.ProductName, c.CategoryName FROM Products p
LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
--RIGHT JOIN
SELECT p.ProductName, c.CategoryName FROM Products p
RIGHT JOIN Categories c ON p.CategoryID = c.CategoryID

-- NULL CHECK
SELECT * FROM Products WHERE CategoryID IS NULL
SELECT * FROM Products WHERE CategoryID IS NOT NULL

-- �OKLU PARAMETRE ARAMA
-- ��ecek ve deniz �r�n� olanlar
SELECT * FROM Products WHERE CategoryID = 1 OR CategoryID = 8
SELECT * FROM Products WHERE CategoryID IN (1,8)