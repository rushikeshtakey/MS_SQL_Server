USE Rushi;

if OBJECT_ID('dbo.employees','U') IS NOT NULL
	DROP TABLE dbo.Employees;

CREATE TABLE Employees
(
	empid INT NOT NULL,
	firstname VARCHAR(30) NOT NULL,
	lastname VARCHAR(30) NOT NULL,
	hireid DATE NOT NULL,
	mgrid INT NULL,
	ssn VARCHAR(30) NOT NULL,
	salary MONEY NOT NULL
);

ALTER TABLE Employees
	ADD CONSTRAINT PK_EMPLOYEES
	PRIMARY KEY(empid);

ALTER TABLE Employees
	ADD CONSTRAINT UQE_EMPLOYEES_ssn
	UNIQUE(ssn);

DROP TABLE IF EXISTS dbo.Orders;

CREATE TABLE Orders
(
	orderid	INT			 NOT NULL,
	empid	INT			 NOT NULL,
	custid	VARCHAR(10)  NOT NULL,
	orderts DATETIME2	 NOT NULL,
	qty		INT			 NOT NULL,
	CONSTRAINT PK_Orders
	PRIMARY KEY(orderid)
);

ALTER TABLE Orders
	ADD CONSTRAINT FK_Orders_Employees
	FOREIGN KEY(empid)
	REFERENCES dbo.Employees(empid)


ALTER TABLE Employees
	ADD CONSTRAINT FK_Employees_Employees
	FOREIGN KEY(mgrid)
	REFERENCES dbo.Employees(empid)

ALTER TABLE Employees
	ADD CONSTRAINT CHK_EMPLOYEES_SALARY
	CHECK(salary > 0.00);

ALTER TABLE dbo.Orders
	ADD CONSTRAINT DEF_Orders_orderts
	DEFAULT(SYSDATETIME()) FOR orderts;

	/*DROP TABLE dbo.Orders, dbo.Employees;*/