
use tsq;

DROP TABLE IF EXISTS dbo.Employees;

CREATE TABLE Employees
(
	empid		INT			NOT NULL,
	firstname	VARCHAR(30) NOT NULL,
	lastname	VARCHAR(30) NOT NULL,
	hiredate	DATE		NOT NULL,
	mgrid		INT			NULL,
	ssn			VARCHAR(20) NOT NULL,
	salary		MONEY		NOT NULL

);

--All types of constraints except for default constraints can be defined as composite constraints

--What is PRIMARY KEY:
--A primary key constraint enforces the uniqueness of rows and also disallows NULLs in the constraint attributes

--PRIMARY KEY condetions to use
--1)An attempt to define a primary Key constraint on a column that allows NULLs will be rejected by the RDBMS.
--2)Each table can have only one primary key.

ALTER TABLE dbo.Employees
	ADD CONSTRAINT PK_Employees
	PRIMARY KEY(empid);

/*UNIQUE MEANING: A unique constraint enforces the uniqueness of rows*/

/*UNIQUE condetions to use
1) you can define multiple unique constraints within the same table
2) a unique constraint is not restricted to columns defined as NOT NULL.*/

ALTER TABLE dbo.Employees
	ADD CONSTRAINT UNQ_ssn_Emplouees
	UNIQUE(ssn);

DROP TABLE IF EXISTS dbo.Orders

CREATE TABLE dbo.Orders
(
	orderid	INT			NOT NULL,
	empid	INT			NOT NULL,
	custid	VARCHAR(10) NOT NULL,
	ordate	DATETIME2	NOT NULL,
	qty		INT			NOT NULL

	CONSTRAINT PK_Orders
		PRIMARY KEY(orderid)
);

ALTER TABLE dbo.Orders
	ADD CONSTRAINT FK_Orders_Employees
	FOREIGN KEY(empid)
	REFERENCES dbo.Employees(empid)
	ON DELETE CASCADE;
/*
ALTER TABLE dbo.Employees
	ADD CONSTRAINT FK_Employees_Employees
	FOREIGN KEY(mgrid)
	REFERENCES dbo.Employees(empid)
	ON DELETE CASCADE;*/

insert into dbo.Employees 
VALUES
(101,'rushi','takey','20250715',11,'10025',25000),
(102,'Krushna','Takey','20201127',12,'10026',30000);


insert into dbo.Orders
VALUES
(01,101,'201','20250715',10);
/*
DELETE FROM dbo.Employees
WHERE empid = 101;
DELETE FROM dbo.Employees
WHERE empid = 102;
select * from dbo.eMPLOYEES;*/

ALTER TABLE dbo.Employees
	ADD CONSTRAINT CHK_Salary_Employees
	CHECK(salary > 0.00);

ALTER TABLE dbo.Orders
	ADD CONSTRAINT DFU_Ordate_Orders
	DEFAULT(SYSDATETIME()) FOR ordate;

-- DROP TABLE IF EXISTS  dbo.Orders, dbo.Employees;
