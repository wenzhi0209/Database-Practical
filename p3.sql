create or replace procedure prc_check_creditAmount(cust_no in number, requeted_amt in number ) is

    max_credit customers.creditlimit%type;
    error_limit_exceed exception;

Begin

    select creditlimit into max_credit
    from customers
    where customernumber =cust_no;

    if requeted_amt> max_credit then
        raise error_limit_exceed
    end if;

    DBMS.OUTPUT.PUT_LINE("Your requested credit amout is acceptable");

exception
   when error_limit_exceed then
    DBMS.OUTPUT.PUT_LINE("Your requested credit amout is over the limit");
   when NO_DATA_FOUND then 
    DBMS.OUTPUT.PUT_LINE("customer is not exist");

END;
/



create or replace procedure prc_check_lastorder(cust_no in number) is
num_day NUMBER;
num_month NUMBER;
num_year NUMBER;
last_date DATE;
check_cust_no number;

BEGIN
	
    select customernumber
      into check_cust_no
      from orders
     where customernumber = cust_no;


	SELECT MAX(orderDate) INTO last_date 
	FROM orders
	WHERE customernumber = cust_no;
	num_day:= sysdate-last_date;
	DBMS_OUTPUT.PUT_LINE ('Customer '||cust_no|| ' last made an order on '||last_date||'.');

    IF num_day >= 30
    THEN
        num_month:= round(num_day/30,1);
        if num_month>=12 then
            num_year:= round(num_month/12,1);
            DBMS_OUTPUT.PUT_LINE ('That was '||num_year||' years ago.');
        ELSE
            DBMS_OUTPUT.PUT_LINE ('That was '||num_month||' months ago.');
        end if;
   
    
    ELSE
    DBMS_OUTPUT.PUT_LINE ('That was '||num_day||' days ago.');
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE ('The customer has not made any purchases');


END;
/

EXEC prc_check_lastorder(496)



create or replace procedure prc_check_salePrice(orderno in number, prodcode in varchar2) is

    odate DATE;
    saleprice orderdetails.priceeach%type;
    costprice products.buyprice%type;
    discprice orderdetails.priceeach%type;

begin

  select orderdate
    into odate
    from orders
   where ordernumber=orderno;

   if(sysdate-odate < 30) then
        select priceeach
        into saleprice
        from orderdetails
        where ordernumber=orderno and productcode=prodcode;

        select buyprice
        into costprice
        from products
        where productcode=prodcode;

        discprice:= saleprice* 0.95;
            if (discprice< (1.05*costprice)) then
                DBMS_OUTPUT.PUT_LINE ('claim rejected no fullfil policy');
            else
                DBMS_OUTPUT.PUT_LINE ('claim accepted');
                update orderdetails
                set priceeach=discprice
                where ordernumber= orderno and productcode=prodcode;
            end if;
          
   else
       DBMS_OUTPUT.PUT_LINE ('claim rejected over date');
   end if;

   exception
    when no_data_found then
       DBMS_OUTPUT.PUT_LINE ('No such order');
        

end;
/

select ordernumber from orderdetails;
select * from orderdetails where ordernumber=10312;
select orderdate from orders where ordernumber=10312;
update orders set orderdate= add_months(orderdate,3)