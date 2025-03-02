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

-- DML : Data Manipulation Query

-- INSERT, UPDATE, DELETE
-- Kategori Ekle
-- Ekleme yaparken NOT NULL olan alanlar� vermek zorunday�z
-- Ekleme yaparken kolonlar� belirtmek istemiyorsan�z, tablo tan�m�ndaki 
--  t�m kolonlar� SIRASINA g�re eklemeniz gerekir.
INSERT INTO Shippers
VALUES ('Titanic Coo.', '+44 75 654200')

INSERT INTO Categories 
	(CategoryName, Description)
VALUES
	('Electronics', 'Home stuffs that use electricity')

INSERT INTO Categories 
	(CategoryName, Description)
VALUES
	('Glassware', 'Everything needed at home')

SELECT * FROM Categories

INSERT INTO Products
	(ProductName, UnitsInStock, UnitPrice, CategoryID, QuantityPerUnit)
VALUES
	('S�p�rge', 45, 800, 9, '1 piece in box')

INSERT INTO Products
	(ProductName, UnitsInStock, UnitPrice, CategoryID, QuantityPerUnit)
VALUES
	('Kahve Makinesi', 20, 650, 9, '1 piece in box')

INSERT INTO Products
	(ProductName, UnitsInStock, UnitPrice, CategoryID, QuantityPerUnit)
VALUES
	('G�rg�r', 250, 35, 10, '2 piece in box')

INSERT INTO Products
	(ProductName, UnitsInStock, UnitPrice, CategoryID, QuantityPerUnit)
VALUES
	('�aydanl�k', 200, 76, 10, '1 piece in box')

INSERT INTO Products
	(ProductName, UnitsInStock, UnitPrice, CategoryID, QuantityPerUnit)
VALUES
	('Ayna', 27, 128, 10, '1 piece in box')

INSERT INTO Products
	(ProductName, UnitsInStock, UnitPrice, CategoryID, QuantityPerUnit)
VALUES
	('�aydanl�k', 200, 76, 10, '1 piece in box')

---------------------
INSERT INTO Suppliers
	(CompanyName, ContactName, Country, City, Phone)
VALUES
	('Arzum', 'Arzu Kaya', 'Turkiye', 'Ankara', '0312 456 1232')

INSERT INTO Suppliers
	(CompanyName, ContactName, Country, City, Phone)
VALUES
	('Tefal', 'Tevfik Alsancak', 'Turkiye', '�zmir', '0232 154 0988')

-- DELETE
-- �al���t�rld�ktan sonra geri al�nmas� m�mk�n olmayan sorgudur.
-- Olabildi�ince Primary Key �zerinden silme yap�lmal�d�r
DELETE FROM Categories WHERE CategoryID = 12 -- (HARD DELETE)

DELETE FROM Categories WHERE CategoryID IN (13, 14)

DELETE FROM Products WHERE ProductID = 81 -- Primary �zerinden sil

SELECT * FROM Products WHERE CategoryID IN (9, 10)

-- UPDATE

UPDATE Products SET SupplierID = 31 WHERE ProductID = 80

UPDATE Products SET SupplierID = 32 WHERE ProductID IN (81, 82)

--UPDATE Products SET SupplierID = 31
--DELETE FROM Products
--DELETE FROM [Order Details]

-- Herkes kendisini m��teri olarak ekleyecek
SELECT * FROM Customers
INSERT INTO Customers 
	(CustomerID, CompanyName, ContactName, ContactTitle, Country, City, Address)
VALUES 
	('CPERK', 'Perque Digital', 'Can Perk', 'Sales Manager', 'T�rkiye', 'Ankara', 'K�z�lay')
-- Herkes bir �r�n kategorisi se�ecek
SELECT * FROM Categories
INSERT INTO Categories 
	(CategoryName, Description)
VALUES 
	('Cleaning', 'Soap, shampoo, all cleaning materials')
-- Herkes Kendi ad�na bir sa�lay�c� firma a�acak
INSERT INTO Suppliers
	(CompanyName, ContactName, Country, City, Phone)
VALUES
	('Henkel', 'Olga Swachf', 'Germany', 'Berlin', '+49 735654512')

INSERT INTO Suppliers
	(CompanyName, ContactName, Country, City, Phone)
VALUES
	('Viking', 'Tamer Da�dan', 'Turkiye', 'Denizli', '+90 244 6543222')

SELECT * FROM Suppliers

UPDATE Suppliers SET CompanyName = 'MyPower Tuning', ContactName = 'M�cahit Bak' WHERE SupplierID = 36
-- Herkes se�ilen kategori ve sa�lay�c�ya g�re 2 - 3 �r�n ekleyecek

INSERT INTO Products
	(ProductName, UnitsInStock, UnitPrice, CategoryID, SupplierID, QuantityPerUnit)
VALUES
	('Persil', 760, 87, 11, 34, '1 piece in box')

INSERT INTO Products
	(ProductName, UnitsInStock, UnitPrice, CategoryID, SupplierID, QuantityPerUnit)
VALUES
	('Vernel', 387, 112, 11, 34, '4 boxes in basket')

INSERT INTO Products
	(ProductName, UnitsInStock, UnitPrice, CategoryID, SupplierID, QuantityPerUnit)
VALUES
	('Pril', 400, 21.90, 11, 34, '1.5 lt x 4 packages')

INSERT INTO Products
	(ProductName, UnitsInStock, UnitPrice, CategoryID, SupplierID, QuantityPerUnit)
VALUES
	('Viking S�v� Deterjan', 118, 39.98, 11, 35, '2 lt x 2 packages')

INSERT INTO Products
	(ProductName, UnitsInStock, UnitPrice, CategoryID, SupplierID, QuantityPerUnit)
VALUES
	('Viking Tech Y�zey', 90, 41.76, 11, 35, '2 lt x 2 packages')

SELECT * FROM Products

SELECT * FROM Products WHERE ProductID = 85
UPDATE Products SET UnitPrice = 8400 WHERE ProductID = 85
-- Eklenen �r�nler ve istenirse di�er �r�nlerle bir sat�� kayd� a��lacak

INSERT INTO Orders
	(CustomerID, EmployeeID, OrderDate, RequiredDate)
VALUES
	('CPERK', 1, GETDATE(), DATEADD(DAY, 5, GETDATE()))

-- BULK INSERT
INSERT INTO [Order Details]
VALUES
	(11081, 88, 87, 3, 0),
	(11081, 90, 21.90, 8, 0),
	(11081, 91, 39.98, 4, 0),
	(11081, 92, 41.76, 2, 0),
	(11081, 89, 112, 1, 0)

SELECT * FROM [Order Details]
WHERE OrderID = 11078

UPDATE [Order Details] 
SET UnitPrice = 8400, Quantity = 3
WHERE OrderID = 11078 AND ProductID = 85

SELECT SUM(UnitPrice * Quantity) FROM [Order Details] WHERE OrderID = 11078

-- GETDATE : DateTime.Now
-- DATEADD : DateT�me.Now.AddDays(5)

SELECT TOP 10 * FROM Orders ORDER BY OrderID DESC

--- �DEV : SELECT INTO Ara�t�r

-- DDL: Data Definition Language
-- CREATE, ALTER, DROP
-- SELECT INTO, VIEW, FUNCTION, STORED PROCEDURE, TRIGGER ve INDEX
GO
CREATE SCHEMA vektorel
GO
CREATE TABLE vektorel.Vehicles
(
	VehicleID INT NOT NULL PRIMARY KEY,
	PlateNumber varchar(10) NOT NULL,
	Brand varchar(10) NULL,
	VehicleType SMALLINT NULL,
	LastMaintanenceDate DATETIME NULL
)

INSERT INTO vektorel.Vehicles
VALUES (1, '06EFY320', 'Ford', 1, NULL),
	   (2, '06BCG098', 'Mitsubishi', 2, '2023-02-05 12:09:23')

SELECT * FROM vektorel.Vehicles

INSERT INTO vektorel.Vehicles
(VehicleID, PlateNumber, Brand, VehicleType, LastMaintanenceDate)
VALUES (4, '06ATD454', 'Ford', 1, NULL)

INSERT INTO vektorel.Vehicles
(VehicleID, PlateNumber, Brand)
VALUES (5, '06FGA590', 'Volvo')

-- Tabloyu sil
DROP TABLE vektorel.Vehicles

CREATE TABLE vektorel.Vehicles
(
	VehicleID INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
	PlateNumber varchar(10) NOT NULL,
	Brand varchar(10) NULL,
	VehicleType SMALLINT NULL, -- 1: Kamyon, 2: Kamyonet, 3: Otomobil
	LastMaintanenceDate DATETIME NULL
)

INSERT INTO vektorel.Vehicles
VALUES ('06EFY320', 'Ford', 1, NULL),
	   ('06BCG098', 'Mitsubishi', 2, '2023-02-05 12:09:23')

INSERT INTO vektorel.Vehicles
(PlateNumber, Brand, VehicleType, LastMaintanenceDate)
VALUES ('06ATD454', 'Ford', 1, NULL)

INSERT INTO vektorel.Vehicles
(PlateNumber, Brand)
VALUES ('06FGA590', 'Volvo')

SELECT * FROM vektorel.Vehicles
GO
-- Tabloyu d�zenle
ALTER TABLE vektorel.Vehicles
ADD Note TEXT NULL

ALTER TABLE vektorel.Vehicles
ADD IsActive BIT NOT NULL DEFAULT(1)

INSERT INTO vektorel.Vehicles
(PlateNumber, Brand)
VALUES ('06DBA230', 'Volvo')

INSERT INTO vektorel.Vehicles
(PlateNumber, Brand, IsActive)
VALUES ('06EFD677', 'BMC', 0)

ALTER TABLE vektorel.Vehicles
DROP COLUMN Note

SELECT * FROM vektorel.Vehicles

-- NOT NULL CONSTRAINT'i i.in eklendi
-- A�a��daki sorgu �al��m�yordu
UPDATE vektorel.Vehicles SET VehicleType = 1 WHERE VehicleType IS NULL

ALTER TABLE vektorel.Vehicles
ALTER COLUMN VehicleType TINYINT NOT NULL

INSERT INTO vektorel.Vehicles
(PlateNumber, Brand, VehicleType, IsActive)
VALUES ('06BGC833', 'BMC', 1, 1)

WITH cte AS
(
	SELECT 
		FirstName + ' ' + LastName AS FullName, 
		HomePhone AS PhoneNumber,
		'�al��an' AS [Type]
	FROM Employees
	UNION
	SELECT ContactName, Phone, 'M��teri' AS [Type] FROM Customers
	UNION
	SELECT ContactName, Phone, 'Tedarik�i' AS [Type] FROM Suppliers
)

select 
	ROW_NUMBER() OVER(ORDER BY FullName) AS PersonID, 
	FullName, 
	PhoneNumber, 
	Type 
into vektorel.PhoneBook
from cte

ALTER TABLE vektorel.PhoneBook
ALTER COLUMN PersonID INT NOT NULL

ALTER TABLE vektorel.PhoneBook
ADD CONSTRAINT PK_PersonID PRIMARY KEY CLUSTERED(PersonID)

INSERT INTO vektorel.Vehicles
(PlateNumber, Brand, VehicleType, IsActive)
VALUES ('06PRK20', 'Honda', 3, 1)

SELECT * FROM vektorel.Vehicles

ALTER TABLE vektorel.Vehicles
ADD CONSTRAINT Vehicle_Type_Check CHECK (VehicleType IN (1, 2, 3))

ALTER TABLE vektorel.Vehicles
DROP CONSTRAINT Vehicle_Type_Check

ALTER TABLE vektorel.Vehicles
ADD CONSTRAINT Vehicle_Type_Check CHECK (VehicleType IN (1, 2, 3, 4)) -- 4: Motosiklet

-- VIEWS
GO

CREATE VIEW vektorel.YearlySales
AS
SELECT YEAR(o.OrderDate) AS Year, SUM(od.UnitPrice * od.Quantity) AS Total
FROM dbo.Orders o
INNER JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY YEAR(o.OrderDate)

---
SELECT * FROM vektorel.YearlySales ORDER BY Year

-- VIEW vs MATERIALIZED VIEW

SELECT 
	PlateNumber, 
	Brand, 
	CASE VehicleType 
	WHEN 1 THEN 'Kamyon'
	WHEN 2 THEN 'Kamyonet'
	WHEN 3 THEN 'Otomobil'
	ELSE 'Di�er'
	END AS Type,
	CASE IsActive 
	WHEN 1 THEN 'Kullan�mda'
	WHEN 0 THEN 'Kullan�m D���'
	END AS UsageStatus
FROM vektorel.Vehicles

-- Bu sorguyu EF �al��t�rd� :D
CREATE TABLE [vektorel].[EmployeeVehicles] (
    [ID] int NOT NULL IDENTITY,
    [EmployeeID] int NOT NULL,
    [VehicleID] int NOT NULL,
    [StartDate] datetime2 NOT NULL,
    [EndDate] datetime2 NULL,
    CONSTRAINT [PK_EmployeeVehicles] PRIMARY KEY ([ID]),
    CONSTRAINT [FK_EmployeeVehicles_Employees_EmployeeID] FOREIGN KEY ([EmployeeID]) REFERENCES [Employees] ([EmployeeID]) ON DELETE CASCADE,
    CONSTRAINT [FK_EmployeeVehicles_Vehicles_VehicleID] FOREIGN KEY ([VehicleID]) REFERENCES [vektorel].[Vehicles] ([VehicleID]) ON DELETE CASCADE
)
--
-- BU korguyu da EF �al��t�rd�
--INSERT INTO [vektorel].[EmployeeVehicles] ([EmployeeID], [EndDate], [StartDate], [VehicleID])
--OUTPUT INSERTED.[ID]
--VALUES (@p0, @p1, @p2, @p3);
GO
select * from vektorel.EmployeeVehicles