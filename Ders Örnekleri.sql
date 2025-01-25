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