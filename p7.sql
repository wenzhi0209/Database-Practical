CREATE OR REPLACE TRIGGER trg_customers_credit
BEFORE UPDATE OF creditLimit ON customers for each row 
DECLARE
l_day_of_month NUMBER; 
begin
L_day_of_month:=EXTRACT(DAY FROM sysdate);
IF(L_day_of_month BETWEEN 28 AND 30) THEN
  raise_application_error(-20100, 'Cannot update customer credit from 28th to 30th'); 
END IF;
dbms_output.put_line('Customer '||:old.customernumber||' initial credit limit of RM '||:old.creditlimit||' is adjusted to '||:new.creditlimit);
end;
/



update customers set creditlimit=20000 where customerNumber=496

select tablename from usertable


/* if dont have audit table*/
create table Price_Audit ( 
    IN_Product_id varchar(15),
    v_productname varchar (70),
    v_oldprice number (7,2), 
    v_newprice number (7,2), 
    user_name varchar (20), 
    date_change date
);

CREATE OR REPLACE TRIGGER TRG_INSERT_PRICE_AUDIT
    AFTER UPDATE OF MSRP ON PRODUCTS
    FOR EACH row
begin
  insert into PRICE_AUDIT
  values (:NEW.PRODUCTCODE, :NEW.PRODUCTNAME, :OLD.MSRP, :NEW.MSRP, USER ,SYSDATE);
end;
/

/*Product buy quantity another part decrease*/
CREATE OR REPLACE TRIGGER TRG_UPD_PRODQTY
    AFTER INSERT ON ORDERDETAILS
    FOR EACH row
begin
  UPDATE PRODUCTS 
  SET QUANTITYINSTOCK=QUANTITYINSTOCK-:NEW.QUANTITYORDERED
  WHERE PRODUCTCODE=:NEW.PRODUCTCODE;
end;
/

insert into ORDERDETAILS values(10422,'S18_2949',1000,100,3);

/*question 2
add unit sold to product
*/
alter table products add total_units_sold number(7) default 0;

CREATE OR REPLACE TRIGGER TRG_UPD_PRODSOLD
    AFTER INSERT ON ORDERDETAILS
    FOR EACH row
begin
  UPDATE PRODUCTS 
  SET total_units_sold=total_units_sold+:NEW.QUANTITYORDERED
  WHERE PRODUCTCODE=:NEW.PRODUCTCODE;
end;

/*check usersource*/
desc user_source
column name format A20

/*Test data*/
Insert into ORDERDETAILS values (10422,'S18_2957',200,90.00,4);
/*Check data*/
select PRODUCTCODE,total_units_sold from products where PRODUCTCODE='S18_2957';


/*statement level triggle*/
CREATE OR REPLACE TRIGGER trg_customers_credit1
BEFORE UPDATE OF creditLimit
ON customers 
-- for each row 
DECLARE
1_day_of_month NUMBER; 
BEGIN
l_day_of_month := EXTRACT (DAY FROM sysdate);
IF l_day_of_month BETWEEN 29 AND 30 THEN
  raise_application_error(-20100, 'Cannot update customer credit from 29th to 30th'); 
END IF;
dbms_output.put_line ('Customers'' credit limit is adjusted.'); END;
