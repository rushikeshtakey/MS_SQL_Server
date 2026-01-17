--Purpose of SELECT:to query tables, apply some logical manipulation, and return a result

/*logical query processing : I’m referring to the conceptual way in which standard SQL 
defines how a query should be processed and the final result achieved*/

/*physically query process: The Microsoft SQL Server engine doesn’t have to follow logical query processing to 
the letter; rather, it is free to physically process a query differently by rearranging processing phases.
SQL Server can—and in fact, often does—make many shortcuts in the physical processing of a query.*/

USE TSQL2012;

/*Logically processing order: In SQL, things are different. Even though the SELECT clause appears first in the query, 
it is logically processed almost last. The clauses are logically processed
in the following order:
1. FROM
2. WHERE
3. GROUP BY
4. HAVING
5. SELECT
6. ORDER BY
*/

SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)											--Listing 2-1--
HAVING COUNT(*) > 1
ORDER BY empid, orderyear;

/*Meaning of the above query (in logical order): 
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
ORDER BY empid, orderyear
Or, to present it in a more readable manner, here’s what the statement does:
1. Queries the rows from the Sales.Orders table
2. Filters only orders where the customer ID is equal to 71
3. Groups the orders by employee ID and order year
4. Filters only groups (employee ID and order year) having more than one order
5. Selects (returns) for each group the employee ID, order year, and number of orders
6. Orders (sorts) the rows in the output by employee ID and order year
*/

/*Why logical and syntax order is different:
The designers of SQL envisioned a declarative language with which you provide your request in an English-like manner.
Consider an instruction made by one human to another in English, such as, 
“Bring me the car keys from the top-left drawer in the kitchen.”
But if you were to express the same instruction to a robot, or a computer program
Your instruction would have probably been something like, “Go to the kitchen; open the top-left drawer;
grab the car keys; bring them to me.” The keyed-in order of the query clauses is similar to English—it
starts with the SELECT clause. Logical query processing order is similar to how you would provide
instructions to a robot—with the FROM clause processed first.*/

/*Meaning of FROM clause: In this clause, you specify the names of the tables that you want to query 
and table operators that operate on those tables.*/

SELECT orderid, custid, empid, orderdate, freight
FROM Sales.Orders;

/*Explaining above statements : following statement queries all rows from the Orders table in the Sales schema, 
selecting the attributes orderid, custid, empid, orderdate, and freight.*/

/*Identifiers rules: If an identifier is irregular—for
example, if it has embedded spaces or special characters, starts with a digit, or is a reserved
keyword—you have to delimit it. You can delimit identifiers in SQL Server in a couple of ways.
The standard SQL form is to use double quotes—for example, “Order Details”. The form specific
to SQL Server is to use square brackets—for example, [Order Details], but SQL Server also supports
the standard form.
With identifiers that do comply with the rules for the format of regular identifiers, delimiting
is optional. For example, a table called OrderDetails residing in the Sales schema can be
referred to as Sales.OrderDetails or “Sales”.”OrderDetails” or [Sales].[OrderDetails].*/

SELECT orderid, empid, orderdate, freight
FROM Sales.Orders
WHERE custid = 71;

/*Meaning of the above statement and WHERE clause: In the WHERE clause, you specify a predicate or logical expression to filter 
the rows returned by the FROM phase. Here WHERE phase filters only orders placed by customer 71.*/

/*WHERE Clause importance: it is important for query performance and SQL Server uses indexes rather than full table scan.
It also reduce the network traffic created by returning all possible rows to the caller and filtering on the client side.*/

-- WHERE returns only those rows whose values are TRUE and not FALSE and NULL due to three-valued-logic

/*GROUP BY meaning: It allows you to arrange the rows returned by the previous logical query processing phase in groups.
and the groups are determined by the elements you specify*/

/*Group BY role: all phases subsequent to the GROUP BY phase—including HAVING, SELECT, and ORDER BY—must operate on 
groups as opposed to operating on individual rows and must return a scalar (single value) per group*/

SELECT empid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate);

/*Aggregate Functions: Elements that do not participate in the GROUP BY list are allowed only as inputs to an aggregate function such as COUNT,
SUM, AVG, MIN, or MAX. For example, the following query returns the total freight and number of orders per each 
employee and order year.*/

SELECT
empid,
YEAR(orderdate) AS orderyear,
SUM(freight) AS totalfreight,
COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate);

/*Proof that select works after the group: If you try to refer to an attribute that does not participate in the GROUP BY list (such as freight) and not
as an input to an aggregate function in any clause that is processed after the GROUP BY clause, you
get an error—in such a case, there’s no guarantee that the expression will return a single value per
group. For example, the following query will fail.*/

SELECT empid, YEAR(orderdate) AS orderyear, freight
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate);

/*SQL Server produces the following error from the above query:
Msg 8120, Level 16, State 1, Line 1
Column 'Sales.Orders.freight' is invalid in the select list because it is not contained in
either an aggregate function or the GROUP BY clause.*/

/*Distint: Note that all aggregate functions ignore NULL marks with one exception—COUNT(*). For example,
consider a group of five rows with the values 30, 10, NULL, 10, 10 in a column called qty. The
expression COUNT(*) would return 5 because there are five rows in the group, whereas COUNT(qty)
would return 4 because there are four known values. If you want to handle only distinct occurrences
of known values, specify the DISTINCT keyword in the parentheses of the aggregate function. For
example, the expression COUNT(DISTINCT qty) would return 2, because there are two distinct known
values. The DISTINCT keyword can be used with other functions as well. For example, although the
expression SUM(qty) would return 60, the expression SUM(DISTINCT qty) would return 40. The expression
AVG(qty) would return 15, whereas the expression AVG(DISTINCT qty) would return 20.*/

SELECT
empid,
YEAR(orderdate) AS orderyear,
COUNT(DISTINCT custid) AS numcusts
FROM Sales.Orders
GROUP BY empid, YEAR(orderdate);

/*Meaning of HAVING : With the HAVING clause, you can specify a predicate to filter groups as opposed to filtering individual
rows, which happens in the WHERE phase.*/

--HAVING does not return NULL or FALSE Data and you can use Aggragate functions in it

SELECT empid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1;

/*SELECT Meaning: The SELECT clause is where you specify the attributes (columns) that you want to return in the result 
table of the query.*/

/*SELECT Alias: 
With no manipulation: In Listing 2-1 we have the following expressions: empid, YEAR(orderdate), and COUNT(*) here attribute with no
manipulation, such as empid, the name of the target attribute is the same as the name of the source attribute, and can use 
AS clause—for example, empid AS employee_id.

With manipulation: Expressions that do apply manipulation, such as YEAR(orderdate), T-SQL allows a query to return result
columns with no names in certain cases, I strongly recommend that you alias such expressions as YEAR(orderdate) AS orderyear 
so that all result attributes have names*/

/*Alias Syntax: <expression> AS <alias> OR <alias> = <expression> (“alias equals expression”) EX: orderyear = YEAR(orderdate) OR
<expression> <alias> (“expression space alias”) Ex: YEAR(orderdate) orderyear*/

/*Bug in <expression> <alias> (“expression space alias”): It is interesting to note that if by mistake you don’t specify a 
comma between two column names in the SELECT list, your code won’t fail. Instead, SQL Server will assume that the second name 
is an alias for the first column name. As an example :*/

SELECT orderid orderdate
FROM Sales.Orders;

/*Now our query looks like: */

SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1;

/* Proof that SELECT clause is processed after the FROM, WHERE, GROUP BY, and HAVING clauses : using select alias in WHERE :*/
SELECT orderid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE orderyear > 2006;

/*Solution to above problem: It’s interesting to note that SQL Server is capable of identifying the repeated use of the same
expression— YEAR(orderdate)—in the query. The expression only needs to be evaluated or calculated once :*/
SELECT orderid, YEAR(orderdate) AS orderyear
FROM Sales.Orders						--this same thing is done in Listing 2-1 in select and having clause with COUNT(*) function-- 
WHERE YEAR(orderdate) > 2006;

/*Can't use SELECT alias in SELECT also : Within the SELECT clause, you are still not allowed to refer 
to a column alias that was created in the same SELECT clause, regardless of whether the expression that 
assigns the alias appears to the left or right of the expression that attempts to refer to it. For example,
the following attempt is invalid.
*/
SELECT orderid,
YEAR(orderdate) AS orderyear,
orderyear + 1 AS nextyear
FROM Sales.Orders;

/*Solution of above code: tis will be explained in the section, “All-at-Once Operations.”*/
SELECT orderid,
YEAR(orderdate) AS orderyear,
YEAR(orderdate) + 1 AS nextyear
FROM Sales.Orders;

/*Why to use DISTICT clause: A SELECT query against the tables can still return a result with duplicate rows. The term “result set” 
is often used to describe the output of a SELECT query, but a result set doesn’t necessarily qualify as a set in the mathematical 
sense. For example: */

SELECT empid, YEAR(orderdate)
FROM Sales.Orders
WHERE custid = 71;

/*DISTICT clause: to guarantee uniqueness in the result of a SELECT statement. For example:*/

SELECT DISTINCT empid, YEAR(orderdate)
FROM Sales.Orders
WHERE custid = 71;

/*Asterisk (*): in the SELECT list to request all attributes from the queried tables instead of listing them explicitly*/

SELECT *
FROM Sales.Orders;

/*Why asterisk is a bad programming practice in most cases: SQL keeps ordinal positions for columns 
based on the order in which the columns were specified in the CREATE TABLE statement. By specifying SELECT *, 
you’re guaranteed to get the columns back in order based on their ordinal positions. Client applications can refer to columns in
the result by their ordinal positions (a bad practice in its own right) instead of by name. Any schema
changes applied to the table—such as adding or removing columns, rearranging their order, and so
on—might result in failures in the client application, or even worse, in logical bugs that will go unnoticed.
By explicitly specifying the attributes that you need, you always get the right ones, as long as
the columns exist in the table. If a column referenced by the query was dropped from the table, you
get an error and can fix your code accordingly.*/

--ORDER BY: This clause allows you to sort the rows in the output for presentation purposes
--Example: this code will sorts the rows in the output by employee ID and order year:
SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY empid, orderyear;

/*Order By unique Features: 
1) The ORDER BY phase is in fact the only phase in which you can refer to column aliases created in the SELECT phase,
2)if you define a column alias that is the same as an underlying column name, as in (col1 AS col1), and refer to that alias
in the ORDER BY clause, the new column is the one that is considered for ordering
3)you either specify ASC right after the expression, as in orderyear ASC, or don’t specify anything after the expression,
because ASC is the default
4)If you want to sort in descending order, you need to specify DESC after the expression, as in orderyear DESC.
5)Rather than using names of attributes you can use there ordenal positions in the select query, for example:
ORDER BY empid, orderyear
you could use:
ORDER BY 1, 2
This is considered bad progeamming practice because if in future you change the SELECT query you would get different result
6)T-SQL allows you to specify elements in the ORDER BY clause that do not appear in the SELECT
clause, meaning that you can sort by something that you don’t necessarily want to return in the output.
For example:*/
SELECT empid, firstname, lastname, country
FROM HR.Employees
ORDER BY hiredate;
/*7) However, when DISTINCT is specified, you are restricted in the ORDER BY list only to elements that
appear in the SELECT list. The reasoning behind this restriction is that when DISTINCT is specified, a
single result row might represent multiple source rows; therefore, it might not be clear which of the
multiple possible values in the ORDER BY expression should be used. Consider the following invalid
query: */

SELECT DISTINCT country
FROM HR.Employees
ORDER BY empid;

