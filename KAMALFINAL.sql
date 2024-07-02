USE master;
 
IF DB_ID('kamalhardware') IS NOT NULL             
	BEGIN
		PRINT 'Database exists - dropping.';
		DROP DATABASE kamalhardware;
	END

GO

PRINT 'Creating database.';
CREATE DATABASE kamalhardware;

GO


USE kamalhardware;

GO

BEGIN TRY 
    BEGIN TRANSACTION;

	--Customer Table
	CREATE TABLE Customers (
		Customer_ID INT PRIMARY KEY NOT NULL,
		Customer_FName VARCHAR(255) NOT NULL,
		Customer_LName VARCHAR(255) NOT NULL,
		Customer_phone VARCHAR(50) NOT NULL,
		Customer_email VARCHAR(255) NOT NULL,
		Referrer_ID INT NULL,
		CONSTRAINT ck_phone CHECK (Customer_phone LIKE '0112%'),
		CONSTRAINT ck_Cust_Email CHECK (Customer_email LIKE '%_@__%.__%'),
		CONSTRAINT fk_Customer_Referrer FOREIGN KEY (Referrer_ID) REFERENCES Customers(Customer_ID)
	);

	CREATE TABLE Employees (
		Employee_ID INT PRIMARY KEY NOT NULL,
		Employee_FName VARCHAR(255) NOT NULL,
		Employee_LName VARCHAR(255) NOT NULL,
		Employee_phone VARCHAR(50) NOT NULL,
		Employee_gender CHAR(1) NOT NULL,
		CONSTRAINT emp_gender CHECK (Employee_gender IN('M', 'F')),
		CONSTRAINT emp_phone CHECK (Employee_phone LIKE '0112%')
	);

	CREATE TABLE Suppliers (
		Supplier_ID INT PRIMARY KEY NOT NULL,
		Supplier_Name VARCHAR(255) NOT NULL,
		Supplier_phone VARCHAR(50) NOT NULL,
		Supplier_email VARCHAR(255) NOT NULL,
		CONSTRAINT ck_phone_supp CHECK (Supplier_phone LIKE '0112%'),
		CONSTRAINT ck_Supp_Email CHECK (Supplier_email LIKE '%_@__%.__%'),
	);

	CREATE TABLE Products (
		Product_ID INT PRIMARY KEY NOT NULL,
		Product_Name VARCHAR(255) NOT NULL,
		Product_description VARCHAR(255) NOT NULL,
	);

	CREATE TABLE Suppliers_Products (
		Supplier_ID INT PRIMARY KEY NOT NULL,
		Product_ID INT NOT NULL,
		Product_Price DECIMAL(10, 2) NOT NULL,
		Product_Quantity INT NOT NULL,
		CONSTRAINT ck_Quan CHECK (Product_quantity >= 0),
		CONSTRAINT fk_Suppliers_Products_Suppliers FOREIGN KEY (Supplier_ID) REFERENCES Suppliers(Supplier_ID),
		CONSTRAINT fk_Suppliers_Products_Products FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
	);


	CREATE TABLE Orderss (
		Order_ID INT PRIMARY KEY NOT NULL,
		Order_Date DATETIME NOT NULL DEFAULT GETDATE(),
		Order_TotalCost DECIMAL(10, 2) NOT NULL,
		Customer_ID INT NOT NULL,
		Employee_ID INT NOT NULL,
		CONSTRAINT fk_Orders_Customer FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID),
		CONSTRAINT fk_Orders_Employee FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID)
	);

	CREATE TABLE Orderss_Products (
		Order_ID INT PRIMARY KEY NOT NULL,
		Product_ID  INT NOT NULL,
		Quantity INT NOT NULL,
		CONSTRAINT ck_quant CHECK (Quantity >= 0),
		CONSTRAINT fk_Orders_Product_Orders FOREIGN KEY (Order_ID) REFERENCES Orderss(Order_ID),
		CONSTRAINT fk_Orders_Product_Product FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
	);

	CREATE TABLE Returnss (
		Return_ID INT PRIMARY KEY NOT NULL,
		Return_Date DATE NOT NULL,
		Product_Name VARCHAR(255) NOT NULL,
		Product_quantity INT NOT NULL,
		Customer_ID INT NOT NULL,
		Employee_ID INT NOT NULL,
		CONSTRAINT ck_quantity CHECK (Product_quantity >= 0),
		CONSTRAINT fk_Return_Customer FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID),
		CONSTRAINT fk_Return_Employee FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID)
	);

	CREATE TABLE Deliveries (
		Delivery_Id INT PRIMARY KEY NOT NULL,
		Delivery_Date DATE NOT NULL,
		Delivery_Address VARCHAR(255) NOT NULL,
		Employee_ID INT NOT NULL,
		Customer_ID INT NOT NULL,
		CONSTRAINT ck_Deli_date CHECK (Delivery_Date >= GETDATE()),
		CONSTRAINT ck_deli_add CHECK (Delivery_Address NOT LIKE '%[^0-9A-za-z ,./-]%'),
		CONSTRAINT fk_Delivery_Employee FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID),
		CONSTRAINT fk_Delivery_Customer FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
	);

	CREATE TABLE Deliveries_Employees (
		Delivery_ID INT PRIMARY KEY NOT NULL,
		Employee_ID INT NOT NULL,
		CONSTRAINT fk_Delivery_Employee_Delivery FOREIGN KEY (Delivery_ID) REFERENCES Deliveries(Delivery_Id),
		CONSTRAINT fk_Delivery_Employee_Employee FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID)
	);

	CREATE TABLE Promotions (
		Promotion_Id INT PRIMARY KEY NOT NULL,
		Promotion_Name VARCHAR(255) NOT NULL,
		Promotion_price MONEY NOT NULL,
		Promotion_Start DATE NOT NULL,
		Promotion_End DATE NOT NULL,
		Product_ID INT NOT NULL,
		CONSTRAINT fk_Promotions FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID),
	);

	COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;

	THROW; 
	END CATCH
	GO


	BEGIN TRY
	BEGIN TRANSACTION;

	-- Insert into Customer
	INSERT INTO Customers VALUES
	(1,'Nimal', 'Perera', '0112-123356', 'nimal@gmail.com', NULL),
	(2,'Kamal', 'Silva', '0112-654321', 'kamal@gmail.com', 1),
	(3,'Sarath', 'Fernando', '0112-234567', 'sarath@gmail.com', NULL),
	(4,'Priyani', 'Rajapaksa', '0112-345678', 'priyani@gmail.com', 2),
	(5,'Tharindu', 'Samaraweera', '0112-456789', 'tharindu@gmail.com', 2),
	(6,'Lakmini', 'Jayawardena', '0112-567890', 'lakmini@gmail.com', 3),
	(7,'Suresh', 'Dias', '0112-678901', 'suresh@gmail.com', 4),
	(8,'Anuradha', 'Weerasuriya', '0112-789012', 'anuradha@gmail.com', 5),
	(9,'Dilshan', 'Peries', '0112-890123', 'dilshan@gmail.com', 6),
	(10,'Bhagth', 'Liyanage', '0112-901234', 'bhagth@gmail.com', 7);

	-- Insert into Employee
	INSERT INTO Employees VALUES
	(100,'Sunil', 'Rajapaksa', '0112-3345678', 'M'),
	(200,'Priyanka', 'Fernando', '0112-3876543', 'F'),
	(300,'Asanka', 'Gurusinghe', '0112-3234567', 'M'),
	(400,'Mahela', 'Jaya', '0112-3345678', 'M'),
	(500,'Sanath', 'Jayasuriya', '0112-3456789', 'M'),
	(600,'Chamari', 'Atapattu', '0112-3567890', 'F'),
	(700,'Lasith', 'kusal', '0112-3678901', 'M'),
	(800,'Muttiah', 'Mura', '0112-3789012', 'M'),
	(900,'Kumar', 'Veer', '0112-3390123', 'M'),
	(1000,'Angelo', 'Sellapuge', '0112-3101234', 'M');

	-- Insert into Supplier
	INSERT INTO Suppliers VALUES
	(150,'Lanka Supplies', '0112-567890', 'lanka@gmail.com'),
	(250,'Colombo Supplies', '0112-987654', 'colombo@gmail.com'),
	(350,'Galle Supplies', '0112-876543', 'galle@gmail.com'),
	(450,'Kandy Supplies', '0112-765432', 'kandy@gmail.com'),
	(550,'Matara Supplies', '0112-654321', 'matara@gmail.com'),
	(650,'Jaffna Supplies', '0112-543210', 'jaffna@gmail.com'),
	(750,'Negombo Supplies', '0112-432109', 'negombo@gmail.com'),
	(850,'Dambulla Supplies', '0112-321098', 'dambulla@gmail.com'),
	(950,'Trincomalee Supplies', '0112-210987', 'trincomalee@gmail.com'),
	(1050,'Battaramulla Supplies', '0112-109876', 'battaramulla@gmail.com');


	-- Insert into Product
	INSERT INTO Products VALUES
	(15,'Nails', 'Any Kinds of Nails available '),
	(25,'Hammer', 'Any Kinds of Hammer available'),
	(35,'Wrench', 'Any Kinds of Wrench available'),
	(45,'Wheelbarrow', 'Any Kinds of Wheelbarrow available'),
	(55,'Toolbelt', 'Any Kinds of Toolbelt available'),
	(65,'Tape', 'Any Kinds of Tape available'),
	(75,'Shovel', 'Any Kinds of Shovel available'),
	(85,'Bricks', 'Any Kinds of Bricks available'),
	(95,'Drill', 'Any Kinds of Drill available'),
	(105,'MultiPlug', 'Any Kinds of MultiPlug available');

	INSERT INTO Suppliers_Products VALUES
	(150,15, 100.00, 1),
	(250,25,200.00, 1),
	(350,35,300.00, 2),
	(450,45, 400.00, 3),
	(550,55, 500.00, 3),
	(650,65, 600.00, 4),
	(750,75, 700.00, 5),
	(850,85, 800.00, 6),
	(950,95, 900.00, 6),
	(1050,105, 1100.00, 7);


	-- Insert into Orders
	INSERT INTO Orderss VALUES
	(51, '2024-12-19', 1500.00,1,100),
	(71, '2024-12-29', 2500.00,2,200),
	(31, '2024-12-09', 3500.00,3,300),
	(12, '2024-12-12', 4500.00,4,400),
	(21, '2024-12-13', 5500.00,5,500),
	(41, '2024-12-04', 6500.00,6,600),
	(81, '2024-12-05', 7500.00,7,700),
	(61,'2024-12-10', 8500.00,8,800),
	(91, '2024-12-11', 9500.00,9,900),
	(101, '2024-12-12', 1050.00,10,1000);


	-- Insert into Orders_Product
	INSERT INTO Orderss_Products VALUES
	(51, 15, 10),
	(71, 25, 5),
	(31, 35, 20),
	(12, 45, 15),
	(21, 55, 7),
	(41, 65, 8),
	(81, 75, 30),
	(61, 85, 25),
	(91, 95, 12),
	(101, 105, 14);


	-- Insert into Returns
	INSERT INTO Returnss VALUES
	(111,'2024-02-01', 'Nails', 105, 1, 100),
	(222,'2024-02-02', 'Hammer', 205, 2, 200),
	(333,'2024-02-03', 'Wheelbarrow', 305, 3, 300),
	(444,'2024-02-04', 'Toolbelt', 405, 4, 400),
	(555,'2024-02-05', 'Tape', 505, 5, 500);



	-- Insert into Delivery
	INSERT INTO Deliveries VALUES
	(1001, '2025-02-01', '12 Lotus Road, Colombo 1', 100, 1),
	(1002, '2025-02-02', '56 Galle Road, Colombo 3', 200, 2),
	(1003, '2025-02-03', '78 Main Street, Galle', 300, 3),
	(1004, '2025-02-04', '79 Main Street, Jaffna', 400, 4),
	(1005, '2025-02-05', '18 Main Street, Rajigirya', 500, 5);


	-- Insert into Delivery_Employee
	INSERT INTO Deliveries_Employees VALUES
	(1001, 100),
	(1002, 200),
	(1003, 300);


	-- Insert into Promotion
	INSERT INTO Promotions VALUES
	(11000,'New Year Sale', 500.00, '2024-04-01', '2024-04-30',15),
	(21000,'Vesak Festival Offer', 750.00, '2024-05-01', '2024-05-31',25),
	(31000,'Poson Poya Promotion', 300.00, '2024-06-01', '2024-06-30',35),
	(41000,'Perahera Sale', 450.00, '2024-07-01', '2024-07-31',45),
	(51000,'Kandy Special', 1000.00, '2024-08-01', '2024-08-31',55),
	(61000,'Christmas Bonanza', 1500.00, '2024-12-01', '2024-12-31',65),
	(71000,'Avurudu Offers', 600.00, '2025-04-01', '2025-04-30',75),
	(81000,'Back to School', 200.00, '2025-01-01', '2025-01-31',85),
	(91000,'Valentine’s Day Special', 850.00, '2025-02-01', '2025-02-28',95),
	(20000,'Sinharaja Special', 950.00, '2025-03-01', '2025-03-31',105);


		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
	GO


 
 SELECT * FROM Customers
 SELECT * FROM Deliveries
 SELECT * FROM Deliveries_Employees
 SELECT * FROM Employees
 SELECT * FROM Orderss
 SELECT * FROM Orderss_Products
 SELECT * FROM Products
 SELECT * FROM Promotions
 SELECT * FROM Returnss
 SELECT * FROM Suppliers
 SELECT * FROM Suppliers_Products
 



