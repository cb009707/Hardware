--4a.	One from any type of join, by combining 2 tables 
SELECT Customer_FName, Customer_LName, Order_ID, Order_TotalCost
FROM Customers AS C INNER JOIN Orderss AS O
ON C.Customer_ID = O.Customer_ID



--4b.	One Sub query by combining 3 tables
SELECT C.Customer_FName + ' ' + C.Customer_LName AS CustomerName, O.Order_ID
FROM Customers AS C
JOIN Orderss AS O ON C.Customer_ID = O.Customer_ID
WHERE O.Employee_ID IN (
    SELECT Employee_ID
    FROM Employees
    WHERE Employee_gender LIKE  ('M')
);


--4c.	Two queries using Like, between, IN, AND, OR operators
SELECT *
FROM Promotions
WHERE Promotion_Name LIKE 'K%' 
AND Promotion_price BETWEEN 500.00 AND 1000.00 
AND Promotion_Start BETWEEN '2024-01-01' AND '2024-12-31'; 

SELECT *
FROM Promotions
WHERE (Promotion_Name LIKE 'V%' OR Promotion_Name LIKE 'A%') 
AND (Promotion_price >= 600.00 OR Promotion_End >= '2025-02-28');


--4d.	One query, using aggregate functions 
 SELECT
     Customers.Customer_ID,
     Customers.Customer_FName,
     Customers.Customer_LName,
    SUM(Order_TotalCost) AS TotalOrder
FROM
    Orderss
JOIN
    Customers ON Orderss.Customer_ID = Customers.Customer_ID
GROUP BY
    Customers.Customer_ID,  Customers.Customer_FName,  Customers.Customer_LName
ORDER BY
    TotalOrder DESC;


--4e.	One query with, select, from where clauses. 
SELECT Customer_FName, Customer_LName
FROM Customers
WHERE Referrer_ID IS NULL



--4f.	Change one column name from any table. 
 EXEC sp_rename 'Customers.Customer_f', 'Customer_FName', 'COLUMN'


--5.	Explain the transactions happen in the above database and when it executing the transactions how the states of the 
--transactions going to change
The database starts off with begin transaction, the sql statements are part of this
transaction,then comes commit transactions if no errors are visible the statement is 
executed and commits the transactions,begin catch ,if an error comes during the transaction
it goes to the catch block.Finally the rollback transaction if an error occurs and the 
transaction is still happening @@TRANCOUNT > 0 ROLLBACK TRANSACTION this statement
rolls back the transaction undoing the changes made.Throw statemnt rethrows he caught 
exception.Using transaction ensures data consistency.
