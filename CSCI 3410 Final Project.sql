/**********************************************************************

 ██████╗███████╗ ██████╗██╗    ██████╗ ██╗  ██╗ ██╗ ██████╗ 
██╔════╝██╔════╝██╔════╝██║    ╚════██╗██║  ██║███║██╔═████╗
██║     ███████╗██║     ██║     █████╔╝███████║╚██║██║██╔██║
██║     ╚════██║██║     ██║     ╚═══██╗╚════██║ ██║████╔╝██║
╚██████╗███████║╚██████╗██║    ██████╔╝     ██║ ██║╚██████╔╝
 ╚═════╝╚══════╝ ╚═════╝╚═╝    ╚═════╝      ╚═╝ ╚═╝ ╚═════╝                                                          
 ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
||F |||i |||n |||a |||l |||       |||P |||r |||o |||j |||e |||c |||t ||
||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
|/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|

**********************************************************************/

/**********************************************************************

 Database Developer Name: Trevor Crow
           Project Title: Basic Online Store
      Script Create Date: 4/28/2019

**********************************************************************/

/**********************************************************************
	CREATE TABLE SECTION
**********************************************************************/

create table THCROW8732.Users(
	UsersId int not null unique identity(1,1),
	FirstName varchar(100) not null,
	LastName varchar(100) not null,
	UsersName varchar(100) not null,
	UsersPassword varchar(8000) not null,
	Email varchar(8000) not null
);

create table THCROW8732.Product(
	ProductId int not null unique identity(1,1),
	ProductName varchar(100) not null,
	ProductPrice money not null,
	Stock int not null,
	DateIntroduced date not null default getdate()
);

create table THCROW8732.ProductDetails(
	ProductDetailsId int not null unique identity(1,1),
	ProductId int not null references THCROW8732.Product(ProductId),
	ProductCreatorFirstName varchar(100) not null,
	ProductCreatorLastName varchar(100) not null,
	ProductProductionCost money not null
);

create table THCROW8732.PaymentInfo(
	PaymentId int not null unique identity(1,1),
	UsersId int not null references THCROW8732.Users(UsersId),
	CardNumber varchar(14) not null,
	CardGoodThru date not null,
	CardCVV varchar(3) not null
);

create table THCROW8732.UsersDeliveryAddress(
	DeliveryId int not null unique identity(1,1),
	UsersId int not null references THCROW8732.Users(UsersId),
	Street varchar(500) not null,
	City varchar(100) not null,
	TheState varchar(50) not null,
	PostalCode varchar(7) not null
);

create table THCROW8732.Orders(
	OrderId int not null unique identity(1,1),
	UsersId int not null references THCROW8732.Users(UsersId),
	OrderStatus bit not null, --1 means it's been processed and 0 means it has not been
	OrderDate date not null default getdate(),
	ShippedDate date null
);

create table THCROW8732.OrderDetails(
	OrderDetailsId int not null unique identity(1,1),
	OrderId int not null references THCROW8732.Orders(OrderId),
	ProductId int not null references THCROW8732.Product(ProductId),
	PaymentId int not null references THCROW8732.PaymentInfo(PaymentId),
	DeliveryId int not null references THCROW8732.UsersDeliveryAddress(DeliveryId),
	Amount int not null
);

/**********************************************************************
	CREATE STORED PROCEDURE SECTION
**********************************************************************/

go

create procedure THCROW8732.UpdateProductPrice (
	@Id int,
	@Amount money --Can be positive or negative because the value will be added onto the current price
)
as
begin
	update THCROW8732.Product
	set ProductPrice = ProductPrice+@Amount
	where THCROW8732.Product.ProductId = @Id;
end

go

create procedure THCROW8732.DeleteOrderDetailsRecord (
	@Id int
)
as
begin
	delete from THCROW8732.OrderDetails
	where OrderDetailsId = @Id;
end

go

/**********************************************************************
	DATA POPULATION SECTION
**********************************************************************/

declare @Cup int;
declare @Onion int;
declare @Wine int;
declare @Beef int;
declare @Chicken int;
declare @User_ID int;
declare @Payment int;
declare @Delivery int;
declare @Order int;
declare @Amount int;

--Product and ProductDetails
insert into THCROW8732.Product values ('Cup', 23.29, 100, '2018-05-17');
set @Cup = scope_identity();
insert into THCROW8732.ProductDetails values (@Cup, 'Asta', 'Yuno', 2.29);

insert into THCROW8732.Product values ('Onion', 15.00, 100, '2019-01-20');
set @Onion = scope_identity();
insert into THCROW8732.ProductDetails values (@Onion, 'Afton', 'Zeal', 3.45);

insert into THCROW8732.Product values ('Wine', 9.00, 100, '2019-01-08');
set @Wine = scope_identity();
insert into THCROW8732.ProductDetails values (@Wine, 'Zoster', 'Ali', 2.99);

insert into THCROW8732.Product values ('Beef', 41.99, 100, '2019-04-10');
set @Beef = scope_identity();
insert into THCROW8732.ProductDetails values (@Beef, 'Shubert', 'Fonzo', 0.99);

insert into THCROW8732.Product values ('Chicken', 69.45, 100, '2018-07-05');
set @Chicken = scope_identity();
insert into THCROW8732.ProductDetails values (@Chicken, 'Felis', 'Gasto', 2.23);

--Users, PaymentInfo, and UsersDeliveryAddress, Orders, and OrderDetails
insert into THCROW8732.Users values ('Joshia', 'Leather', 'jleather0', 'HFfOn3hTTQao', 'jleather0@techcrunch.com');
set @User_ID = scope_identity();
insert into THCROW8732.PaymentInfo values (@User_ID, '12345678901112', '3030-02-23', '123');
set @Payment = scope_identity();
insert into THCROW8732.UsersDeliveryAddress values (@User_ID, '1234 Idiot Drive', 'Vanderbilt', 'Georgia', '30580');
set @Delivery = scope_identity();
insert into THCROW8732.Orders values (@User_ID, 1, getdate(), null);
set @Order = scope_identity();
insert into THCROW8732.OrderDetails values (@Order, @Beef, @Payment, @Delivery, 23);
insert into THCROW8732.OrderDetails values (@Order, @Onion, @Payment, @Delivery, 15);
insert into THCROW8732.OrderDetails values (@Order, @Chicken, @Payment, @Delivery, 1);

insert into THCROW8732.Users values ('Gareth', 'Evitts', 'gevitts1', 'tZmlcHsRtHC', 'gevitts1@fema.gov');
set @User_ID = scope_identity();
insert into THCROW8732.PaymentInfo values (@User_ID, '13343338902222', '3040-01-14', '222');
set @Payment = scope_identity();
insert into THCROW8732.UsersDeliveryAddress values (@User_ID, '1332 Idiot Drive', 'Vanderbilt', 'Georgia', '30580');
set @Delivery = scope_identity();
insert into THCROW8732.Orders values (@User_ID, 1, getdate(), null);
set @Order = scope_identity();
insert into THCROW8732.OrderDetails values (@Order, @Wine, @Payment, @Delivery, 2);

insert into THCROW8732.Users values ('Ricky', 'Lipmann', 'rlipmann2', '54ltV0szpjIP', 'rlipmann2@jimdo.com');
set @User_ID = scope_identity();
insert into THCROW8732.PaymentInfo values (@User_ID, '18888888801112', '3022-02-23', '323');
set @Payment = scope_identity();
insert into THCROW8732.UsersDeliveryAddress values (@User_ID, '2222 Idiot Drive', 'Vanderbilt', 'Georgia', '30580');
set @Delivery = scope_identity();
insert into THCROW8732.Orders values (@User_ID, 0, getdate(), null);
set @Order = scope_identity();
insert into THCROW8732.OrderDetails values (@Order, @Cup, @Payment, @Delivery, 99);

insert into THCROW8732.Users values ('Wat', 'Kleinhandler', 'wkleinhandler3', 'lwMDo6b0J', 'wkleinhandler3@cdc.gov');
set @User_ID = scope_identity();
insert into THCROW8732.PaymentInfo values (@User_ID, '12345678955555', '3110-05-03', '456');
set @Payment = scope_identity();
insert into THCROW8732.UsersDeliveryAddress values (@User_ID, '5252 Idiot Drive', 'Vanderbilt', 'Georgia', '30580');
set @Delivery = scope_identity();
insert into THCROW8732.Orders values (@User_ID, 1, getdate(), null);
set @Order = scope_identity();
insert into THCROW8732.OrderDetails values (@Order, @Chicken, @Payment, @Delivery, 56);

insert into THCROW8732.Users values ('Shoshanna', 'Bunten', 'sbunten4', 'AdTi1DtOXUqd', 'sbunten4@phoca.cz');
set @User_ID = scope_identity();
insert into THCROW8732.PaymentInfo values (@User_ID, '66666678901112', '3030-08-23', '666');
set @Payment = scope_identity();
insert into THCROW8732.UsersDeliveryAddress values (@User_ID, '5656 Swampna Drive', 'Clayton', 'Minnesota', '105086');
set @Delivery = scope_identity();
insert into THCROW8732.Orders values (@User_ID, 0, getdate(), null);
set @Order = scope_identity();
insert into THCROW8732.OrderDetails values (@Order, @Onion, @Payment, @Delivery, 15);




/**********************************************************************
	RUN STORED PROCEDURE SECTION
**********************************************************************/

exec THCROW8732.UpdateProductPrice 1,'2.00';
exec THCROW8732.DeleteOrderDetailsRecord 1;


/**********************************************************************
	END OF SCRIPT
**********************************************************************/