--SUMMARY REPORT FOR AGENT WORKLOAD IN SPECIFIC YEAR
create view AGENT_INFO as 
SELECT Agent_ID,Agent_Name,Agent_Gender,DoB
from Travel_Agent
ORDER BY AGENT_ID
WITH READ ONLY CONSTRAINT AGENT_WORKLOAD_INFO_read_only;
    

Create or replace procedure RPT_Agent_Workload(YEAR IN number) as

    NumEnquiry number;
    Total_Num_Package number;

    cursor agent_cursor is 
    select Agent_ID,Agent_Name,Agent_Gender,DoB
    from AGENT_INFO
    order by Agent_ID asc;

    cursor Package_cursor(ID NUMBER) is
    select Package_Name,Count(Package_Name) AS NumPackage
    from Package_Schedule PS, travel_package TP
    WHERE PS.Package_ID=TP.Package_ID And PS.Agent_ID=ID AND (extract(year from Start_Date)=YEAR)
    group by Package_Name;

begin
    DBMS_OUTPUT.PUT_LINE(LPAD('*',80,'*'));
    DBMS_OUTPUT.PUT_LINE('SUMMARY REPORT OF AGENT WORKLOAD IN YEAR '||YEAR);
    DBMS_OUTPUT.PUT_LINE(LPAD('*',80,'*'));
    dbms_output.put_line(chr(10)); 
    FOR agent_rec in agent_cursor loop
        DBMS_OUTPUT.PUT_LINE(LPAD('=',80,'='));
        DBMS_OUTPUT.PUT_LINE(RPAD('Agent ID',12,' ')||RPAD('Name',30,' ')||RPAD('Gender',10,' ')||RPAD('Age',10,' ')); 
        DBMS_OUTPUT.PUT_LINE(RPAD(agent_rec.Agent_ID,12,' ')||RPAD(agent_rec.Agent_Name,30,' ')||RPAD(agent_rec.Agent_Gender,10,' ')||RPAD(Calculate_Age(agent_rec.DoB),10,' ')); 
        DBMS_OUTPUT.PUT_LINE(LPAD('-',80,'-'));
        DBMS_OUTPUT.put_line('Package handled in Year '||year);
        Total_Num_Package:=0;
        FOR package_rec in Package_cursor(agent_rec.Agent_ID) loop
            DBMS_OUTPUT.PUT_LINE(chr(9)||'Package Name : '||RPAD(package_rec.Package_Name,50,' ')||' - '||package_rec.NumPackage); 
            Total_Num_Package:=Total_Num_Package+package_rec.NumPackage;
        end loop;
        DBMS_OUTPUT.PUT_LINE(LPAD('-',80,'-'));
        DBMS_OUTPUT.PUT_LINE('Total Number of Package Handled in Year '||year||': '||Total_Num_Package);

        select Count(Enquiry_ID) INTO NumEnquiry
        from Enquiry E
        WHERE E.Agent_ID=agent_rec.Agent_ID AND (extract(year from Enquiry_Date)=YEAR);
        DBMS_OUTPUT.PUT_LINE('Total Number of Enquiry Reply in Year '||year||': '||NumEnquiry);

        DBMS_OUTPUT.PUT_LINE(LPAD('=',80,'='));
        dbms_output.put_line(chr(10)); 
    end loop;
    dbms_output.put_line(chr(10)); 
    DBMS_OUTPUT.PUT_LINE(LPAD('*',80,'*'));
    DBMS_OUTPUT.PUT_LINE('END OF REPORT');
    DBMS_OUTPUT.PUT_LINE('REPORT GENERATED IN '|| sysdate);
    DBMS_OUTPUT.PUT_LINE(LPAD('*',80,'*'));
end;
/

EXEC RPT_AGENT_WORKLOAD(2019);















set linesize 80
--DETAILED REPORT ON LOW CUST RATING(<=2) ENQUIRY IN SPECIFIC YEAR

CREATE OR REPLACE PROCEDURE RPT_LOW_RATING_ENQUIRY (YEAR IN NUMBER) as

    V_Cust_Name Tourism_Customer.Cust_Name%type;
    V_Cust_Gender Tourism_Customer.Cust_Gender%type;
    V_Agent_Name TRAVEL_AGENT.Agent_Name%type;
	Agent_ID INT;
    v_total_enq int;
    v_bad_enq int;
    percentage number(4,2);
    
    CURSOR ENQUIRY_CURSOR IS 
    SELECT Enquiry_ID,Enquiry_Desc,Agent_Reply,Cust_Experience,Cust_ID,Agent_ID
    FROM ENQUIRY
    WHERE Cust_Rating <=2 AND (extract(year from Enquiry_Date)=YEAR);

begin
    dbms_output.put_line(chr(10)); 
    DBMS_OUTPUT.PUT_LINE(LPAD('*',80,'*'));
    DBMS_OUTPUT.PUT_LINE('Detailed Report of Low Rating Enquiry In '||year||'');
    DBMS_OUTPUT.PUT_LINE(LPAD('*',80,'*'));

    dbms_output.put_line(chr(10)); 
    select count(Enquiry_ID) into v_total_enq from enquiry Where (extract(year from Enquiry_Date)=YEAR);
    select count(Enquiry_ID) into v_bad_enq from enquiry Where Cust_Rating <=2 AND (extract(year from Enquiry_Date)=YEAR);
    dbms_output.put_line('Total number of enquiry in '||YEAR||': '||v_total_enq); 
    dbms_output.put_line('Total number of BAD enquiry in '||YEAR||': '||v_bad_enq); 
    percentage:=(v_bad_enq/v_total_enq)*100;
    dbms_output.put_line('Percentage of BAD enquiry in '||YEAR||': '||percentage||'%'); 

    dbms_output.put_line(chr(10)); 
    DBMS_OUTPUT.PUT_LINE('List of Bad Enquiry:');
    DBMS_OUTPUT.PUT_LINE(LPAD('=',80,'='));
    for enquiry_rec in ENQUIRY_CURSOR loop 
        DBMS_OUTPUT.PUT_LINE(RPAD('-',80,'-'));
        DBMS_OUTPUT.PUT_LINE('Enquiry_ID : '||enquiry_rec.Enquiry_ID);

        DBMS_OUTPUT.PUT_LINE('Enquiry Description:');
        DBMS_OUTPUT.PUT_LINE(enquiry_rec.Enquiry_Desc);

        dbms_output.put_line(chr(10)); 
        DBMS_OUTPUT.PUT_LINE('Agent Reply Message:');
        DBMS_OUTPUT.PUT_LINE(enquiry_rec.Agent_Reply);
        
        dbms_output.put_line(chr(10)); 
        DBMS_OUTPUT.PUT_LINE('Customer Enquiry Experiece:');
        DBMS_OUTPUT.PUT_LINE(enquiry_rec.Cust_Experience);

        dbms_output.put_line(chr(10)); 
        SELECT Cust_Name,Cust_Gender INTO V_Cust_Name,V_Cust_Gender
        FROM Tourism_Customer WHERE Cust_ID=enquiry_rec.Cust_ID;
        DBMS_OUTPUT.PUT_LINE('Enquiry From :'||V_Cust_Name||' Gender: '||V_Cust_Gender);
        SELECT AGENT_NAME INTO V_Agent_Name
        FROM TRAVEL_AGENT WHERE Agent_ID=enquiry_rec.AGENT_ID;
        DBMS_OUTPUT.PUT_LINE('Replied by :'||V_Agent_Name);
        DBMS_OUTPUT.PUT_LINE(RPAD('-',80,'-'));
        DBMS_OUTPUT.PUT_LINE(RPAD('+',80,'+'));
    end loop;
    DBMS_OUTPUT.PUT_LINE(LPAD('=',80,'='));
    dbms_output.put_line(chr(10)); 
    DBMS_OUTPUT.PUT_LINE('***************************************');
    DBMS_OUTPUT.PUT_LINE('END OF REPORT');
    DBMS_OUTPUT.PUT_LINE('REPORT GENERATED IN '|| sysdate);
    DBMS_OUTPUT.PUT_LINE('***************************************');

end;
/

exec RPT_LOW_RATING_ENQUIRY(2020);








-- On demand report show the package handled in privious month and package schedule arragenment in next 2 month
set linesize 100
CREATE OR REPLACE PROCEDURE RPT_Recent_Schedule(Agent_No in number) AS
    v_total int;
    v_agentID int;
    V_Agent_Name TRAVEL_AGENT.Agent_Name%type;
    v_package_Name Travel_Package.package_name%type;
    v_curmonth int;
    v_month int;
    v_total_2_m int;

    CURSOR P_SCHED_CUR(A_ID NUMBER) IS
    select Package_ID,Start_Date,End_Date,Available_Status
    from Package_Schedule
    where Agent_ID=A_ID 
    and (extract(month from Start_Date)between extract(month from sysdate)+1 and extract(month from sysdate)+2)
    ORDER by Start_Date asc;
   

begin

    
    Select Agent_Name into V_Agent_Name
    from Travel_Agent
    where AGENT_ID=AGENT_NO;

    DBMS_OUTPUT.PUT_LINE('On Demand Report of Recent Schedule for '||Agent_No||' from '||sysdate);
    DBMS_OUTPUT.PUT_LINE(RPAD('-',100,'-'));
    v_curmonth:=0;
    v_total_2_m:=0;
    DBMS_OUTPUT.PUT_LINE(RPAD('PACKAGE_NAME',50,' ')||RPAD('Start Date',14,' ')||RPAD('End Date',14,' ')||RPAD('Status',14,' '));
    DBMS_OUTPUT.PUT_LINE(RPAD('-',100,'-'));

    FOR P_SCHED_RED IN P_SCHED_CUR(AGENT_NO) loop
        v_month:=extract(month from P_SCHED_RED.Start_Date);
        if(v_curmonth!=v_month) THEN
            v_curmonth:=v_month;
            dbms_output.put_line(chr(10)); 
            DBMS_OUTPUT.PUT_LINE('********: Schedule in '||to_char(P_SCHED_RED.Start_Date,'MONTH'));
        END IF;

        Select package_name into v_package_Name 
        from travel_package
        where package_id=P_SCHED_RED.Package_ID;
        
        DBMS_OUTPUT.PUT_LINE(RPAD(v_package_Name,50,' ')||RPAD(P_SCHED_RED.Start_Date,14,' ')||RPAD(P_SCHED_RED.End_Date,14,' ')||RPAD(P_SCHED_RED.Available_Status,14,' '));
        v_total_2_m:=v_total_2_m+1;
    end loop;

    dbms_output.put_line(chr(10));
    dbms_output.put_line('Total number of schedule for next 2 month : '||v_total_2_m);
    SELECT COUNT(Package_Schedule_ID) into v_total 
    FROM PACKAGE_SCHEDULE
    WHERE AGENT_ID=AGENT_NO AND (Extract(YEAR FROM Start_Date)=Extract(YEAR FROM SYSDATE))
    AND (Start_Date<SYSDATE) AND(Available_Status='deactivate');
    dbms_output.put_line('Total number of schedule Agent '||AGENT_NO||' done in '||Extract(YEAR FROM SYSDATE)||': '||v_total);



    dbms_output.put_line(chr(10)); 
    DBMS_OUTPUT.PUT_LINE('***************************************');
    DBMS_OUTPUT.PUT_LINE('END OF REPORT');
    DBMS_OUTPUT.PUT_LINE('REPORT GENERATED IN '|| sysdate);
    DBMS_OUTPUT.PUT_LINE('***************************************');
    exception
    when no_data_found then
      DBMS_OUTPUT.PUT_LINE('The Agent_ID is not found in database');
end;
/

exec RPT_Recent_Schedule(1017);
 


