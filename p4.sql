CREATE OR REPLACE FUNCTION NUMBEROFORDERS (V_CUSTNO IN NUMBER)
    RETURN NUMBER AS V_COUNT NUMBER

    begin
      select COUNT(*)
        into V_COUNT
        from ORDERS
       where customerNumber=V_CUSTNO
    end;