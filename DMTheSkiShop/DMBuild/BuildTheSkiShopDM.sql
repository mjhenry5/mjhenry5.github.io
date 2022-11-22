-- Build TheSkiShop DM --
-- INFO 3300 Phase 2 --
-- Created by Morgan Henry --
-- Created on 10/11/2022 -- 
-- Peer reviewers Jackson Holmbeck and Josh Poresky --

IF NOT EXISTS(SELECT * FROM sys.databases
WHERE NAME = N'TheSkiShopDM')
CREATE DATABASE TheSkiShopDM
GO
--
USE TheSkiShopDM
GO
--

--
--Drop Existing Tables
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'FactSales'
	)
	DROP TABLE FactSales;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimEmployee'
	)
	DROP TABLE DimEmployee;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimCustomerDemographic'
	)
	DROP TABLE DimCustomerDemographic;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimProduct'
	)
	DROP TABLE DimProduct;
-- 
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimDate'
	)
	DROP TABLE DimDate;
--
--Begin creating dim tables with the fact table being created last
--
CREATE TABLE DimDate 
	(Date_SK			INT CONSTRAINT pk_date_sk PRIMARY KEY, 
	Date				DATE,
	FullDate			NCHAR(10), -- Date in MM-dd-yyyy format
	DayOfMonth			INT, -- Field will hold day number of Month
	DayName				NVARCHAR(9), -- Contains name of the day, Sunday, Monday 
	DayOfWeek			INT, -- First Day Sunday=1 and Saturday=7
	DayOfWeekInMonth	INT, -- 1st Monday or 2nd Monday in Month
	DayOfWeekInYear		INT,
	DayOfQuarter		INT,
	DayOfYear			INT,
	WeekOfMonth			INT, -- Week Number of Month 
	WeekOfQuarter		INT, -- Week Number of the Quarter
	WeekOfYear			INT, -- Week Number of the Year
	Month				INT, -- Number of the Month 1 to 12{}
	MonthName			NVARCHAR(9), -- January, February etc
	MonthOfQuarter		INT, -- Month Number belongs to Quarter
	Quarter				NCHAR(2), 
	QuarterName			NVARCHAR(9), -- First,Second...
	Year				INT, -- Year value of Date stored in Row
	YearName			NCHAR(7), -- CY 2017,CY 2018
	MonthYear			NCHAR(10), -- Jan-2018,Feb-2018
	MMYYYY				INT,
	FirstDayOfMonth		DATE,
	LastDayOfMonth		DATE,
	FirstDayOfQuarter	DATE,
	LastDayOfQuarter	DATE,
	FirstDayOfYear		DATE,
	LastDayOfYear		DATE,
	IsHoliday			BIT, -- Flag 1=National Holiday, 0-No National Holiday
	IsWeekday			BIT, -- 0=Week End ,1=Week Day
	Holiday				NVARCHAR(50), -- Name of Holiday in US
	Season				NVARCHAR(10) -- Name of Season
	);
--
CREATE TABLE DimProduct
	(Product_SK			INT IDENTITY(1,1) NOT NULL CONSTRAINT pk_product_sk PRIMARY KEY,
	Product_AK 			INT NOT NULL,
	ProductName			NVARCHAR(200) NOT NULL,
	ProductDescription	NVARCHAR(200) NOT NULL,
	BrandName			NVARCHAR(30) NOT NULL,
	Price				DECIMAL(18,4) NOT NULL,
	StartDate			DATETIME NOT NULL,
	EndDate				DATETIME NULL
	);
--
CREATE TABLE DimCustomerDemographic
	(Customer_SK		INT IDENTITY(1,1) NOT NULL CONSTRAINT pk_customer_sk PRIMARY KEY,
	Customer_AK 		INT NOT NULL,
	CustomerLevel		NVARCHAR(30) NOT NULL,
	BirthDate			DATETIME NOT NULL,
	Gender				NVARCHAR(2) NOT NULL,
	Income				DECIMAL(18,4) NOT NULL,
	MaritalStatus		NVARCHAR(2) NOT NULL,
	HouseholdSize		INT NOT NULL
	);
--
CREATE TABLE DimEmployee
	(Employee_SK		INT IDENTITY(1,1) NOT NULL CONSTRAINT pk_employee_sk PRIMARY KEY,
	Employee_AK			INT NOT NULL,
	EmployeeType		NVARCHAR(25) NOT NULL,
	FirstName			NVARCHAR(15) NOT NULL,
	LastName			NVARCHAR(30) NOT NULL,
	StartDate			DATETIME NOT NULL,
	EndDate				DATETIME NULL
	);
--
CREATE TABLE FactSales
	(Purchase_DD	    INT NOT NULL,
	Product_SK			INT NOT NULL,
	Customer_SK 		INT NOT NULL,
	Employee_SK			INT NOT NULL,
	PurchaseDateKey		INT NOT NULL,
	PurchaseCost		DECIMAL(18,4) NOT NULL,
	PurchaseQuantity	INT NOT NULL,
	Category			NVARCHAR(20) NOT NULL,			
	CategoryQuantity	INT NOT NULL,
	CommissionRate		DECIMAL(3,2) NOT NULL,
	TotalCommission		DECIMAL(18,4)
	CONSTRAINT fk_dim_Product FOREIGN KEY (Product_SK) REFERENCES DimProduct(Product_SK),
	CONSTRAINT fk_dim_CustomerDemographic FOREIGN KEY (Customer_SK) REFERENCES DimCustomerDemographic(Customer_SK),
	CONSTRAINT fk_dim_Employee FOREIGN KEY (Employee_SK) REFERENCES DimEmployee(Employee_SK),
	CONSTRAINT fk_dim_Date FOREIGN KEY (PurchaseDateKey) REFERENCES DimDate(Date_SK)
	);