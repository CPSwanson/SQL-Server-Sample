/*
PURPOSE Script to create and populate tables utilized in Mainstream Anime Emporium
CREATED 09/12/2018
AUTHOR Christopher Paul Swanson
*/

--Table setup
Create Table cpswanson.customers --Holds information pertaining to each customer
(customerid int Primary Key Identity(1000,4), --Unique id for customer, set to auto-increment by 4 for each new customer
username varchar(15) Unique Not Null, --Username used by customer to log in to application
password varchar(15) Not Null, --Password used by customer to log into database
first_name varchar(20) Not Null,
last_name varchar(20) Not Null,
address varchar(30),
city varchar(25),
state varchar(2),
zip varchar(5),
phone varchar(14),
email varchar(50), --Used for password recovery
Constraint ck_customers_zip Check(zip Like '[0-9][0-9][0-9][0-9][0-9]'),
Constraint ck_customers_phone
	Check(phone Like '([0-9][0-9][0-9]) [0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'))

Create Table cpswanson.employees --Holds information pertainting to each employee
(empid int Primary Key Identity(2000,4), --Unique id for employee, set to auto increment by 4 for each new employee
username varchar(15) Unique Not Null,  --Username used by employee to log in to application
password varchar(15) Not Null, --Password used by employee to log into database
first_name varchar(20) Not Null,
last_name varchar(20) Not Null,
phone varchar(14),
email varchar(50),
manager_id int, --Checked upon login to see if user is a mananger; yes if null
Constraint ck_employees_phone
	Check(phone Like '([0-9][0-9][0-9]) [0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
Constraint fk__employees_managerid Foreign Key (manager_id) References cpswanson.employees(empid))

Create Table cpswanson.suppliers --Holds information pertaining to product suppliers
(supplierid int Primary Key Identity(4000,1),
name varchar(25) Not Null,
phone varchar(14),
email varchar(50),
Constraint ck_supplier_phone
	Check(phone Like '([0-9][0-9][0-9]) [0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'))

Create Table cpswanson.products --Holds information pertaining to products being sold
(productid int Primary Key Identity(3000,4),
description varchar(75),
price money Not Null,
discount decimal(4,2) Default 0.00, --Item are initially sold at full price
supplierid int,
quantity int Not Null,
Constraint fk_product_supplierid Foreign Key (supplierid) References cpswanson.suppliers(supplierid))

Create Table cpswanson.empSchedule --Holds information on each employee's work schedule for the week
(employeeid int Primary Key,
Mon varchar(40) Not Null,
Tues varchar(40) Not Null,
Wed varchar(40) Not Null,
Thur varchar(40) Not Null,
Fri varchar(40) Not Null,
Sat varchar(40) Not Null,
Sun varchar(25) Not Null,
Sick_days_left int Not Null,
Vacation_days_left int Not Null,
Constraint fk_schedule_empid Foreign Key (employeeid) References cpswanson.employees(empid))

Create Table cpswanson.orders --Holds information on each confirmed order
(orderid int Primary Key Identity(100,4),
customerid int Not Null,
orderdate date,
shippeddate date,
totalPrice money,
Constraint fk_orders_custID Foreign Key (customerid) References cpswanson.customers(customerid))

Create Table cpswanson.orderDetails --Holds contents of each order
(orderid int Not Null,
productid int Not Null,
numOrdered int Not Null,
Constraint fk_orderDetails_orderid Foreign Key (orderid) References cpswanson.orders(orderid),
Constraint fk_orderDetails_productid Foreign Key (productid) References cpswanson.products(productid) On Delete Cascade)

Create Table cpswanson.productImages --Stores image related to products
(productid int Not Null,
pImage varbinary(MAX),
Constraint fk_ProductImages_productid Foreign Key (productid) References cpswanson.products(productid) On Delete Cascade)

Create Table cpswanson.invoices --Stores information on invoices for add products or products with added inventory
(productid int not null,
date date not null,
quantity int not null,
cost money not null,
Constraint fk_invoices_productid Foreign Key (productid) References cpswanson.products(productid) On Delete Cascade)

Create table cpswanson.schRequests --Stores information on schedule requests made by employees
(empID int,
request text,
Constraint fk_schRequests Foreign Key (empID) References cpswanson.employees(empID))
Go

--Data Insert
Insert Into cpswanson.employees(username,password,first_name,last_name,phone,email,manager_id)
Values('jGordan','password1','James','Gordan','(254) 572-0980','jGordan@liveWire.com',NULL),
('tWhitlow','password2','Tyler','Whitlow','(254) 469-8746','tWhitlow@liveWire.com',2000),
('aBorden','password3','Allen','Borden','(254) 123-2469','aBorden@liveWire.com',2000)

Insert Into cpswanson.suppliers(name,phone,email)
Values('Anime Shippers','(279) 369-9007', 'james.mcCane@animeshippers.com')

Insert Into cpswanson.products(description,price,supplierid,quantity)
Values('Anteiku Coffee T-Shirt : S',19.99,4000,20),
('Anteiku Coffee T-Shirt : M',24.99,4000,20),
('Anteiku Coffee T-Shirt : L',29.99,4000,20),
('My Hero Academia All Might T-Shirt : S',19.99,4000,20),
('My Hero Academia All Might T-Shirt : M',24.99,4000,20),
('My Hero Academia All Might T-Shirt : L',29.99,4000,20),
('Naruto Shippuden Nine Tails Hoodie : S',19.99,4000,20),
('Naruto Shippuden Nine Tails Hoodie : M',24.99,4000,20),
('Naruto Shippuden Nine Tails Hoodie : L',29.99,4000,20),
('Yu-Gi-Oh Seto Kaiba Hoodie : S',19.99,4000,20),
('Yu-Gi-Oh Seto Kaiba Hoodie : M',24.99,4000,20),
('Yu-Gi-Oh Seto Kaiba Hoodie : L',29.99,4000,20),
('One Punch Man Okay T-Shirt : S',19.99,4000,20),
('One Punch Man Okay T-Shirt : M',24.99,4000,20),
('One Punch Man Okay T-Shirt : L',29.99,4000,20),
('Fairy Tail Grand Magic Games Poster',44.99,4000,20),
('Re: Zero Poster',44.99,4000,20),
('Konosuba! Poster',44.99,4000,20),
('Attack on Titan Poster',44.99,4000,20),
('One Piece Roranoro Zoro Wanted Poster',44.99,4000,20),
('Character Gallery Poster',44.99,4000,20),
('Bleach Soul Reaper Poster',44.99,4000,20),
('No Game No Life: Zero Poster',44.99,4000,20),
('Overlord Poster',44.99,4000,20),
('Dragon Ball Z Poster',44.99,4000,20)

Insert Into cpswanson.empSchedule(employeeid,Mon,Tues,Wed,Thur,Fri,Sat,Sun,Sick_days_left,Vacation_days_left)
Values(2004,'8A.M.-5P.M. Inv Mgmt','8A.M.-5P.M. Inv Mgmt','8A.M.-5P.M. Inv Mgmt','8A.M.-5P.M. Inv Mgmt','8A.M.-5P.M. Inv Mgmt','8A.M.-5P.M. Inv Mgmt','8A.M.-5P.M. Inv Mgmt',7,25),
(2000,'8A.M.-5P.M. DBA','8A.M.-5P.M. DBA','8A.M.-5P.M. DBA','8A.M.-5P.M. DBA','8A.M.-5P.M. DBA','8A.M.-5P.M. DBA','8A.M.-5P.M. DBA',7,25),
(2008,'8A.M.-5P.M. Order Proc','8A.M.-5P.M. Order Proc','8A.M.-5P.M. Order Proc','8A.M.-5P.M. Order Proc','8A.M.-5P.M. Order Proc','8A.M.-5P.M. Order Proc','8A.M.-5P.M. Order Proc',7,25)
Go

Create View cpswanson.vw_MAESales --Used to diplays sales reports to manager
As
Select o.orderdate, p.description, Cast(((p.price - (p.price * (p.discount/100))) * oD.numOrdered) As money) As 'Sale Price' ,oD.numOrdered
From cpswanson.orders o
Join cpswanson.orderDetails oD On oD.orderid = o.orderid
Join cpswanson.products p On p.productid = oD.productid
Go

/*
Manages product inventroy after a sell has been made
*/
Create Trigger cpswanson.cpswanson_Inventory
On cpswanson.orderDetails
For Insert As
Declare
	cur_Inserted Cursor
	For Select i.productid, i.numOrdered
	From inserted i

Declare @id int
Declare @num int
Begin
	Open cur_Inserted

	Fetch Next From cur_Inserted Into @id, @num

	While @@FETCH_STATUS = 0
	Begin
		Update cpswanson.products
		Set quantity = quantity - @num
		Where productid = @id
	Fetch Next From cur_Inserted Into @id, @num
	End

	Close cur_Inserted
End
Go