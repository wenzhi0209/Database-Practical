
--data
insert into low_stock 
values('S10_8998','1952 Alpine Renault 1300','Classic Cars','1:10','Classic Metal Creations','Turnable front wheels; steering function; detailed interior; detailed engine; opening hood; opening trunk; opening doors; and detailed chassis.',45,98.58,214.3,0);
insert into low_stock 
values('S10_8999','1952 Alpine Renault 1300','Classic Cars','1:10','Classic Metal Creations','Turnable front wheels; steering function; detailed interior; detailed engine; opening hood; opening trunk; opening doors; and detailed chassis.',65,98.58,214.3,0);



CREATE VIEW London_customers_view AS
SELECT *
FROM customers
WHERE UPPER(city) = 'LONDON'; 

CREATE VIEW LOW_STOCK AS 
SELECT * FROM PRODUCTS
WHERE QUANTITYINSTOCK <50;

select productcode,QUANTITYINSTOCK from LOW_STOCK;

insert into low_stock2 values('S10_8997','1952 Alpine Renault 1300','Classic Cars','1:10','Classic Metal Creations','Turnable front wheels; steering function; detailed interior; detailed engine; opening hood; opening trunk; opening doors; and detailed chassis.',15,98.58,214.3,0);
insert into low_stock2 values('S10_8996','1952 Alpine Renault 1300','Classic Cars','1:10','Classic Metal Creations','Turnable front wheels; steering function; detailed interior; detailed engine; opening hood; opening trunk; opening doors; and detailed chassis.',165,98.58,214.3,0);

CREATE VIEW low_stock2 AS
SELECT * FROM products
WHERE quantityInStock < 50
WITH CHECK OPTION CONSTRAINT low_stock2_50qty;

insert into low_stock3 values('S10_8995','1952 Alpine Renault 1300','Classic Cars','1:10','Classic Metal Creations','Turnable front wheels; steering function; detailed interior; detailed engine; opening hood; opening trunk; opening doors; and detailed chassis.',15,98.58,214.3,0);
CREATE VIEW low_stock3 AS
SELECT *
FROM products
WHERE quantityInStock < 50
WITH READ ONLY CONSTRAINT low_stock3_readOnly;



CREATE OR REPLACE VIEW HIGH_ORDER_VIEW (CustomerNumber, OrderNumber, OrderDate, OrderTotalValue, TotalNoOfItems) AS
  select A.customerNumber, A.orderNumber, orderDate,    
             sum(B.priceEach*B.quantityOrdered) ,   
             sum(quantityOrdered)
from   orders A,  orderDetails B
where  A.orderNumber = b.orderNumber
group by A.customerNumber, A.orderNumber, orderDate
having sum(B.priceEach*B.quantityOrdered) > 50000;

select A.customerNumber, customerName, country, ordernumber
from customers A, high_order_view B
where A.customerNumber = b.customerNumber
order by 1;

select A.customerNumber, customerName, country, sum(ordertotalvalue) TotalSales
from customers A, high_order_view B
where A.customerNumber = b.customerNumber
group by A.customerNumber,customerName, country
order by TotalSales desc;

create or replace view lastyear_order_view as
select ordernumber, orderdate,customernumber
  from orders
 where extract(year from orderDate)= extract(year from sysdate)-1;
 
select extract(month from orderdate)"No",to_char(orderDate,'MON')"MONTH",
sum(quantityOrdered)"Number of items sold", sum(quantityOrdered*priceEach)"total sales"
from lastyear_order_view o, orderDetails d
where o.orderNumber=d.orderNumber
group by extract(month from orderdate),to_char(orderDate,'MON')
order by 1;


select sum(quantityOrdered*priceEach),p.productcode,productname
from products p, orderDetails d
where p.productcode=d.productcode
group by p.productcode,productname
order by 1 desc;