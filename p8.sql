CREATE TABLE EMPLOYEES_AUDIT
{
    TRANSDATE date,
    NO_OF_INSERT NUMBER(3),
    NO_OF_UPDATE NUMBER(3),
    NO_OF_DELETE NUMBER(3),
}

CREATE OR REPLACE TRIGGER TRACK_EMPLOYEES
BEFORE INSERT OR UPDATE OR DELETE ON EMPLOYEES
DECLARE
    V_DATE DATE;
begin
    select TransDate
    into V_DATE
    from EMPLOYEES_AUDIT
    where to_char(TransDate,'DD-MON-YY') = to_char(SYSDATE,'DD-MON-YY'); 
    -- check if there is already a record for today 

   if SQL%FOUND THEN 
   CASE 
   WHEN INSERTING 
   THEN UPDATE Employees_AUDIT 
   SET No_Of_Insert = No_Of_Insert + 1 
   where to_char(TransDate,'DD-MON-YY') = to_char(SYSDATE,'DD-MON-YY'); 
   
   WHEN UPDATING 
   THEN UPDATE Employees_AUDIT 
   SET No_Of_Update = No_Of_Update + 1 
   where to_char(TransDate,'DD-MON-YY') = to_char(SYSDATE,'DD-MON-YY'); 
   
   WHEN DELETING 
   THEN UPDATE Employees_AUDIT 
   SET No_Of_Delete = No_Of_Delete + 1
   where to_char(TransDate,'DD-MON-YY') = to_char(SYSDATE,'DD-MON-YY'); 
   END CASE; 
   end if; 

   exception 
   when no_data_found then 
   CASE 
   WHEN INSERTING THEN INSERT INTO Employees_AUDIT VALUES(sysdate,1,0,0); 
   WHEN UPDATING THEN INSERT INTO Employees_AUDIT VALUES(sysdate,0,1,0); 
   WHEN DELETING THEN INSERT INTO Employees_AUDIT VALUES(sysdate,0,0,1); 
   END CASE; 
END; /








alter table orders add
(
    orderAmount     number(7,2) default 0.00,
    discount        number(2,2) default 0.05,
    totolDiscount   number(7,2) default 0.00,
    finalTotal      number(7,2) default 0.00
);


create table CUSTOMERS_MONTHLY
( customerNumber number(11) NOT NULL, 
  yearNo    number(4) NOT NULL,
  monthNo   number(2) NOT NULL,
  monthly_Amount number(9,2),
  primary key (customerNumber, yearNo, monthNo)
);

CREATE OR REPLACE TRIGGER TRG_UPT_ORDERS_AMT 
AFTER INSERT ON orderDetails 
FOR EACH ROW 
DECLARE 
v_OrderAmount NUMBER := 0.00; 
v_TotalDiscount NUMBER := 0.00; 
v_FinalTotal NUMBER := 0.00; 
v_discount number(2,2); 
BEGIN 
select discount into v_discount from Orders 
where orderNumber = :new.orderNumber; 

v_OrderAmount := :new.priceEach * :new.quantityOrdered; 
v_TotalDiscount := ROUND( v_OrderAmount * v_discount,2); 
v_FinalTotal := v_OrderAmount - v_TotalDiscount; 

UPDATE ORDERS 
SET 
OrderAmount = OrderAmount + v_OrderAmount, 
TotalDiscount = TotalDiscount + v_TotalDiscount, 
FinalTotal = FinalTotal + v_FinalTotal 
WHERE orderNumber = :new.orderNumber; 
END; 
/

CREATE OR REPLACE TRIGGER TRG_UPT_CUST_MONTHLY 
AFTER UPDATE OF FinalTotal ON Orders 
FOR EACH ROW 
DECLARE 
v_custNum CUSTOMERS.CUSTOMERNUMBER%TYPE; 
BEGIN 
Select customerNumber into v_custNum From CUSTOMERS_MONTHLY 
Where customerNumber = :new.customerNumber 
AND YearNo = EXTRACT(Year From(:new.OrderDate)) 
AND MonthNo = EXTRACT(Month From(:new.OrderDate)); 

IF SQL%FOUND THEN UPDATE CUSTOMERS_MONTHLY 
SET Monthly_Amount = Monthly_Amount + :new.FinalTotal - :old.FinalTotal 
WHERE customerNumber = :new.customerNumber 
AND YearNo = EXTRACT(Year From(:new.OrderDate)) 
AND MonthNo = EXTRACT(Month From(:new.OrderDate)); 
END IF; 
EXCEPTION WHEN NO_DATA_FOUND 
THEN INSERT INTO CUSTOMERS_MONTHLY 
VALUES (:new.customerNumber,EXTRACT(Year From(:new.OrderDate)), 
EXTRACT(Month From(:new.OrderDate)),:new.FinalTotal); 
END;
/

delete from orderDetails;
insert into orderdetails values(10100,'S18_1749',30,136,3);
insert into orderdetails values(10100,'S18_2248',50,55.09,2);
insert into orderdetails values(10100,'S18_4409',22,75.46,4);

select orderNumber,OrderAmount,TotalDiscount,finaltotal
  from orders
 where orderNumber=10100;

 select * from CUSTOMERS_MONTHLY;








CREATE OR REPLACE VIEW MANAGER_VIEW AS  
  select distinct(Wkr.reportsTo) AS ManagerID, Mgr.lastname,               
        Mgr.firstname, Mgr.jobTitle  
    from employees Mgr, employees Wkr  
   where (Wkr.reportsTo = Mgr.employeeNumber); 

CREATE OR REPLACE TRIGGER update_mgr_view 
INSTEAD OF UPDATE ON manager_view 
FOR EACH ROW 
BEGIN -- allow the following updates to the underlying employees table 
UPDATE employees 
SET JobTitle = :NEW.jobTitle WHERE employeeNumber = :OLD.ManagerId; 
END; 
/

update manager_view set jobTitle = 'Senior Sales Rep' where ManagerID = 1621;







create table Salary_Grade
(Grade number(2) not null unique,
 Min_Salary number(6,2) not null,
 Max_Salary number(7,2) not null );
 
insert into salary_grade values(1,1800.00,3500.00);
insert into salary_grade values(2,3000.00,6000.00);
insert into salary_grade values(3,5500.00,8500.00);


alter table employees add(
    Sal_Code number(1)default 1, 
    salary Number(7,2) default 0.00
);


CREATE OR REPLACE TRIGGER TRG_validate_EMP_SALARY
before insert or UPDATE OF salary ON employees
FOR EACH ROW 
DECLARE 

min_s NUMBER (7,2);
max_s NUMBER (7,2);

BEGIN 
    select  min_salary,max_salary
      into min_s,max_s
      from Salary_Grade
     where Grade=:new.Sal_Code;

     if not(:new.salary BETWEEN min_s and max_s) then 
        raise_application_error(-20000, 'The new salary is not within the correct range');
     end if;


END;
/


insert into employees(employeenumber,lastname,firstname, sal_code, salary) 
  values (1905, 'Sam','Lim', 2, 5000 );
insert into employees(employeenumber,lastname,firstname, sal_code, salary) 
  values (1906, 'Adam','Tim', 2, 8000 );
update employees set salary = 6300 where employeenumber = 1905;


create or replace procedure prc_add_new_emp(eno in number,lname in varchar,fname in varchar,salcode in number, sal in number)is
begin
  --insert
end;