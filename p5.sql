CREATE OR REPLACE PROCEDURE prc_order_details (v_customerNoIN in number)  AS 
 v_orderNo ORDERS.orderNumber%TYPE;
 v_orderDate ORDERS.orderDate%TYPE; 
 v_requiredDate ORDERS.requiredDate%TYPE; 
 v_shippedDate ORDERS.shippedDate%TYPE; 
 v_custNo ORDERS.customerNumber%TYPE; 
 v_productCode ORDERDETAILS.productCode%TYPE; 
 v_qtyOrd ORDERDETAILS.quantityOrdered%TYPE; 
 v_priceEach ORDERDETAILS.priceEach%TYPE; 

 cursor order_cursor is select 
 customerNumber, orderNumber, orderDate, requiredDate, shippedDate 
 from ORDERS where customerNumber=v_customerNoIN; 

 cursor orderDetail_cursor 
 is select productCode, quantityOrdered, priceEach 
 from ORDERDETAILS where orderNumber = v_orderNo; 

 BEGIN OPEN order_cursor; 
 FETCH order_cursor 
 INTO v_custNo, v_orderNo, v_orderDate, v_requiredDate, v_shippedDate;
 WHILE 
    order_cursor%FOUND 
LOOP 
    DBMS_OUTPUT.PUT_LINE('Customer No : '||v_custNo); 
    DBMS_OUTPUT.PUT_LINE('Order No : '||v_orderNo); 
    DBMS_OUTPUT.PUT_LINE('Order Date : '||v_orderDate); 
    DBMS_OUTPUT.PUT_LINE('Shipped : '||v_shippedDate); 
    DBMS_OUTPUT.PUT_LINE('Required Date : '||v_requiredDate); 
    dbms_output.put_line(chr(10)); 
    OPEN orderDetail_cursor; 
    FETCH orderDetail_cursor 
    INTO v_productCode, v_qtyOrd, v_priceEach; 
    WHILE 
        orderDetail_cursor%FOUND 
    LOOP 
        DBMS_OUTPUT.PUT_LINE(v_productCode||'***'||v_qtyOrd||'***'||v_priceEach);
        FETCH orderDetail_cursor INTO v_productCode, v_qtyOrd, v_priceEach;
    END LOOP; 
    CLOSE orderDetail_cursor; 
    DBMS_OUTPUT.PUT_LINE('End of Customer '||v_custNo||'************************'); 
    dbms_output.put_line(chr(10)); 
    FETCH order_cursor INTO v_custNo, v_orderNo, v_orderDate, v_requiredDate, v_shippedDate; 
END LOOP; 
    CLOSE order_cursor; 
END;

exec prc_order_details
exec prc_order_details(282)





DECLARE
    CURSOR order_cursor (in_year NUMBER :=2020 , in_customer NUMBER := 141)  IS
        SELECT o.ordernumber, orderdate,  SUM(quantityOrdered * priceEach) Total
        FROM orderDetails d, orders o
        where d.orderNumber = o.orderNumber and
        status = 'Shipped' AND EXTRACT( YEAR FROM orderDate) = in_year
        and customernumber =     in_customer
        group by o.ordernumber, orderdate;
    totalAmt number(11,2) :=0;
BEGIN
   FOR cust_order IN order_cursor LOOP
        dbms_output.put_line(cust_order.ordernumber||'   '|| cust_order.orderdate 
            ||  '   '||cust_order.Total);
       totalAmt := totalAmt + cust_order.Total;
    END LOOP;
    dbms_output.put_line(RPAD('-',50,'-'));
    dbms_output.put_line(chr(10)||'Total amount of purchase is '|| 
        to_char( totalAmt, '$999,999,999.99'));
  END;
/






DECLARE
        CURSOR c_product (low_price NUMBER, high_price NUMBER)     IS
        SELECT *
        FROM products
        WHERE msrp BETWEEN low_price AND high_price;
BEGIN
     dbms_output.put_line('Mass products: ');
    for prod_rec in c_product(30,90) loop 
           dbms_output.put_line(prod_rec.productName || ': ' ||prod_rec.msrp);
    END LOOP;
    
    dbms_output.put_line(chr(10)|| chr(10)||'Luxury products: ');
    for prod_rec in c_product(150,1000) loop 
           dbms_output.put_line(prod_rec.productName || ': ' ||prod_rec.msrp);
     END LOOP;
   
END;
/



Modify the procedure given in Prac4_proc2.sql
using 
cursor for loop  and 
cursor with parameter
The procedure should also display the total of each order


DECLARE

    v_total number(11,2);
    cursor order_cursor (IN_CUSTNUM NUMBER) is select 
    customerNumber, orderNumber, orderDate, requiredDate, shippedDate 
    from ORDERS where customerNumber=IN_CUSTNUM; 

    cursor orderDetail_cursor(IN_orderNo number) 
    is select productCode, quantityOrdered, priceEach 
    from ORDERDETAILS where orderNumber = IN_orderNo; 
begin

    FOR order_rec in order_cursor(282)loop
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
        DBMS_OUTPUT.PUT_LINE('TOTAL SALES AMOUNT FOR THIS OREDER IS '||v_total);

        DBMS_OUTPUT.PUT_LINE('End of Customer '||order_rec.customerNumber||'************************'); 
        dbms_output.put_line(chr(10)); 

    end loop;
  

end;
/

CREATE OR REPLACE PROCEDURE prc_order_details_with_for_cur (v_customerNoIN in number)  AS 
    v_total number(11,2);
    cursor order_cursor is select 
    customerNumber, orderNumber, orderDate, requiredDate, shippedDate 
    from ORDERS where customerNumber=v_customerNoIN ; 

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
        DBMS_OUTPUT.PUT_LINE('TOTAL SALES AMOUNT FOR THIS OREDER IS '||v_total);

        DBMS_OUTPUT.PUT_LINE('End of Customer '||order_rec.customerNumber||'************************'); 
        dbms_output.put_line(chr(10)); 

    end loop;
end;
/

exec prc_order_details_with_for_cur (282)

