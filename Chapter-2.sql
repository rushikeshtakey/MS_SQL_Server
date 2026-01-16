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
GROUP BY empid, YEAR(orderdate)
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

--HAVING does not return NULL or FALSE Data

SELECT empid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1;