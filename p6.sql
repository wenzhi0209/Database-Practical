CREATE OR REPLACE PROCEDURE Question1 (prodLine in varchar)  AS 
    
    v_desc productlines.textDescription%type;
    v_count number(3):=0;

    cursor product_cursor is
    select productCode,productName,MSRP,quantityinstock
    from Products where upper(productline)=upper(prodLine); 

  
begin

    DBMS_OUTPUT.PUT_LINE('Product Line : '|| prodLine);
    Select textDescription into v_desc from productlines where upper(productline)=upper(prodLine);
    DBMS_OUTPUT.PUT_LINE(chr(10)||v_desc||chr(10)||chr(10));



    FOR product_rec in product_cursor loop

        v_count:=v_count+1;
        DBMS_OUTPUT.PUT_LINE(rpad(v_count,3,' ')||'. '||rpad(product_rec.productCode,15,' ')||rpad(product_rec.productName,40' ')||rpad(product_rec.MSRP,10,' ')||rpad(product_rec.quantityinstock,10,' ')); 

    end loop;

    DBMS_OUTPUT.PUT_LINE(chr(10)||chr(10)||'Number of products : '||v_count);

    exception
      when no_data_found then
        DBMS_OUTPUT.PUT_LINE(chr(10)||'HELLO DONT SIMPLY INPUT WHAT YOU WANT');
end;
/

exec Question1('Planes')
exec Question1('CAR')

//
//------------------modify based on the last week Question1
//------------------add in the date range 
//------------------Chnage customer no into date between 2 range

CREATE OR REPLACE PROCEDURE prc_order_details_with_for_cur (v_fromdate varchar,v_todate varchar)  AS 
    v_total number(11,2);
    v_totalwholeSales number(11,2):=0;

    cursor order_cursor is select customerNumber, orderNumber, orderDate, requiredDate, shippedDate 
    from ORDERS 
    where orderdate BETWEEN to_date(v_fromdate,'dd/mm/yyyy') and to_date(v_todate,'dd/mm/yyyy'); 

    cursor orderDetail_cursor(IN_orderNo number) 
    is select productCode, quantityOrdered, priceEach 
    from ORDERDETAILS where orderNumber = IN_orderNo; 
begin

    FOR order_rec in order_cursor loop
        DBMS_OUTPUT.PUT_LINE('Customer No : '||order_rec.customerNumber); 
        DBMS_OUTPUT.PUT_LINE('Order No : '||order_rec.orderNumber); 
        DBMS_OUTPUT.PUT_LINE('Order Date : '||order_rec.orderDate); 
        DBMS_OUTPUT.PUT_LINE('Shipped : '||order_rec.shippedDate); 
        DBMS_OUTPUT.PUT_LINE('Required Date : '||order_rec.requiredDate); 
        dbms_output.put_line(chr(10)); 

        v_total:=0;
        For details_rec in orderDetail_cursor(order_rec.orderNumber)loop
          DBMS_OUTPUT.PUT_LINE(details_rec.productCode||'***'||details_rec.quantityOrdered||'***'||details_rec.priceEach);
          v_total:= details_rec.quantityOrdered * details_rec.priceEach;
        end loop;
        v_totalwholeSales:=v_totalwholeSales+v_total;
        DBMS_OUTPUT.PUT_LINE('TOTAL SALES AMOUNT FOR THIS OREDER IS '||v_total);

        DBMS_OUTPUT.PUT_LINE('End of Customer '||order_rec.customerNumber||'************************'); 
        dbms_output.put_line(chr(10)); 

    end loop;

    dbms_output.put_line(chr(10)); 
    dbms_output.put_line(chr(10)); 
    DBMS_OUTPUT.PUT_LINE('TOTAL SALES AMOUNT FOR THIS PERIOD '||v_fromdate||'-'||v_todate||' IS '||v_totalwholeSales);
end;
/

exec prc_order_details_with_for_cur ('15/10/2020', '15/12/2020')




//------ Profit margin = (MSRP-buyPrice) / buyprice
//------

CREATE OR REPLACE PROCEDURE Question4ProfitMargin (prodLine in varchar)  AS 
    
    v_desc productlines.textDescription%type;
    v_count number(3):=0;

    cursor calc_profitCursor is 
    select productCode,productName,Round((MSRP-buyPrice)/buyPrice*100,2) ProfitMargin
    from product_cursor
    where upper(productline)=upper(prodLine)
    order by ProfitMargin desc;

begin

    DBMS_OUTPUT.PUT_LINE('Product Line : '|| prodLine);
    Select textDescription into v_desc from productlines where upper(productline)=upper(prodLine);
    DBMS_OUTPUT.PUT_LINE(chr(10)||v_desc||chr(10)||chr(10));



    FOR product_rec in product_cursor loop

        v_count:=v_count+1;
        DBMS_OUTPUT.PUT_LINE(rpad(v_count,3,' ')||'. '||rpad(product_rec.productCode,15,' ')||rpad(product_rec.productName,40' ')||rpad(ProfitMargin,10,' ')); 

    end loop;

    DBMS_OUTPUT.PUT_LINE(chr(10)||chr(10)||'Number of products : '||v_count);

    exception
      when no_data_found then
        DBMS_OUTPUT.PUT_LINE(chr(10)||'HELLO DONT SIMPLY INPUT WHAT YOU WANT');
end;
/




//---Q5 Product total unit sales report
//---
CREATE OR REPLACE PROCEDURE ProductTotalUnitSales  AS 
    
    cursor prod_sales_cur is
    select p.productCode prodC, productName,sum(quantityOrdered) totalUnit, sum(quantityOrdered*priceEach) totalSales
    from orderdetails o,procducts p
    where o.productcode=p.productcode
    group by p.productcode,productName
    order by totalUnit desc;
   

begin

    for productSales in prod_sales_cur loop
      
      DBMS_OUTPUT.PUT_LINE(prodC||productName||totalUnit||totalSales);
      dbms_output.put_line(chr(10)); 

    end loop;
    
    exception
      when no_data_found then
        DBMS_OUTPUT.PUT_LINE(chr(10)||'HELLO DONT SIMPLY INPUT WHAT YOU WANT');
end;
/


//---Check customer order who did not continue buy product from us
//--- Want to use view or not depends own yourself

create view Last6MthOrder_view as 
  select customernumber, max(orderdate) as lastdate
   from orders
   group by customernumber 
   having months_between(sysdate,max(orderdate))>=6
   order by  2;

//---Procedure
CREATE OR REPLACE PROCEDURE check_cust_sta  AS 
    
    cursor cust_lastorder_cursor is 
    select a.customernumber custno, customername, phone, a.ordernumber orderno, lastdate
    from orders a, Last6MthOrder_view b, customers c
    where a.customernumber = b.customernumber
     and  a.orderdate = lastdate
     and a.customernumber = c.customernumber
    order by a.customernumber;
   
   orderTotal number(12,2);

begin

    for lastORec in cust_lastorder_cursor loop
      DBMS_OUTPUT.PUT_LINE(lastORec.custno||' '||lastORec.customername||' '||lastORec.phone);

      select sum(quantityOrdered*priceEach) into orderTotal
      from orderDetails
      where ordernumber=lastORec.orderno;
    
        DBMS_OUTPUT.PUT_LINE('The last order '||lastORec.lastdate||' total for this customer : '||orderTotal);
        dbms_output.put_line(chr(10)); 
    end loop;
    
    exception
      when no_data_found then
        DBMS_OUTPUT.PUT_LINE(chr(10)||'HELLO DONT SIMPLY INPUT WHAT YOU WANT');
end;
/

exec check_cust_sta
