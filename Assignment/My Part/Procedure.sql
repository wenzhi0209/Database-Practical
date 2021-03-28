CREATE OR REPLACE PROCEDURE REPLY_TO_ENQUIRY(ENQUIRY_NO IN NUMBER, AGENT_NO IN NUMBER,REPLY_MSG IN VARCHAR2)  AS 
    
    v_reply_agentNo Enquiry.Agent_ID%type;
    ALREADY_REPLIED EXCEPTION;
begin
    select Agent_ID into v_reply_agentNo 
    from enquiry
    where Enquiry_ID = ENQUIRY_NO;

    if(v_reply_agentNo is null) then
      UPDATE Enquiry SET Agent_Reply=REPLY_MSG, Agent_ID=AGENT_NO
      WHERE Enquiry_ID=ENQUIRY_NO;
    else
      RAISE ALREADY_REPLIED;
    END IF;

    DBMS_OUTPUT.PUT_LINE(chr(10)||'ENQUIRY '||ENQUIRY_NO||' Succesfully Replied by '||Agent_No);
    DBMS_OUTPUT.PUT_LINE('Reply Content:');
    DBMS_OUTPUT.PUT_LINE(CHR(9)||REPLY_MSG);

    exception
      when no_data_found then
        DBMS_OUTPUT.PUT_LINE(chr(10)||'THE ENQUIRY IS NOT IN THE DATABASE');
      when ALREADY_REPLIED then 
        DBMS_OUTPUT.PUT_LINE(chr(10)||'THIS ENQUIRY ALREADY REPLIED BY '||v_reply_agentNo);
end;
/

exec REPLY_TO_ENQUIRY(1004,1003,'Hi THIS FOR TEST');


CREATE OR REPLACE PROCEDURE NEW_TRAVEL_AGENT(A_NAME IN VARCHAR2,PHONE_NO IN VARCHAR2,EMAIL IN VARCHAR2, GENDER IN CHAR, ADDRESS IN VARCHAR2, BIRTHDATE IN DATE)  AS 

begin
    Insert into Travel_Agent(AGENT_NAME,AGENT_PHONE,AGENT_EMAIL,AGENT_GENDER,AGENT_ADDRESS,DOB) 
    VALUES(A_NAME,PHONE_NO,EMAIL,GENDER,ADDRESS,BIRTHDATE);
    DBMS_OUTPUT.PUT_LINE('New Travel Agent Inserted successfully');
    --EXCEPTION HANDLE BY TRIGGER
    exception
      when OTHERS then
         DBMS_OUTPUT.PUT_LINE(chr(10)||'Creation Failed, Invalid Information');
         Agent_ID_Adjustment;

end;
/
exec NEW_TRAVEL_AGENT('Wen Zhi','0127085598','wenzhi7209@hotmail.com','M','sri pelangi condo, jalan genting kelang,setapak',TO_DATE('2001-01-06','YYYY-MM-DD'))





--UPDATE PACKAGE_SCHEDULE AGENT
--AGENT MUST AVAILABLE CHECK ON TIME WITHOUT CLASING
--AGENT MUST EXITS
--SCHEDULE STATUS SHOULD BE deactivate else show message
Create or REPLACE PROCEDURE PACKSCHED_CHANGE_AGENT(PackSched_ID IN NUMBER, NEW_AGENT_ID IN NUMBER) AS 

  v_start_date Package_Schedule.Start_Date%type;
  v_end_date Package_Schedule.End_Date%type;
  V_Status Package_Schedule.Available_Status%type;
  v_exist_agent_ID Package_Schedule.Agent_ID%type;
  v_package_ID Package_Schedule.Package_ID%type;

  v_exist_agentName Travel_Agent.Agent_Name%type;
  v_new_agentName Travel_Agent.Agent_Name%type;
  v_package_Name travel_package.Package_Name%type;

  cursor new_agent_schedule is 
  select Start_Date,End_Date
  from Package_Schedule where Agent_ID=NEW_AGENT_ID;

  SCHED_CRASHED exception;
  Invalid_Schedule exception;
  Permision_Ask exception;
  Same_Agent exception;

begin

  select Start_Date, End_Date, Available_Status, Agent_ID, Package_ID
  Into v_start_date,v_end_date,V_Status,v_exist_agent_ID,v_package_ID
  from Package_Schedule where Package_Schedule_ID=PackSched_ID;

  select Agent_Name into v_new_agentName from Travel_Agent where Agent_ID=NEW_AGENT_ID;
  select Agent_Name into v_exist_agentName from Travel_Agent where Agent_ID=v_exist_agent_ID;
  select Package_Name into v_package_Name from travel_package where Package_ID=v_package_ID;

  if(v_exist_agent_ID=NEW_AGENT_ID) then
    raise Same_Agent;
  end if;

  FOR SCHED_REC IN new_agent_schedule loop
    IF(SCHED_REC.Start_Date Between v_start_date AND v_end_date) THEN
      RAISE SCHED_CRASHED;
    elsif(SCHED_REC.End_Date Between v_start_date AND v_end_date) then
      RAISE SCHED_CRASHED;
    END IF;      
  end loop;

  IF(V_Status!='deactivate') then
    Raise Permision_Ask;
  END IF;

  DBMS_OUTPUT.PUT_LINE('AGENT OF '||PackSched_ID||' from '||v_exist_agentName||'('||v_exist_agent_ID||') changed to '||v_new_agentName||'('||NEW_AGENT_ID||')');
  DBMS_OUTPUT.PUT_LINE('Basic Info of '||PackSched_ID);
  DBMS_OUTPUT.PUT_LINE('Package for thi schedule: '||v_package_Name);
  DBMS_OUTPUT.PUT_LINE('Start Date '||v_start_date);
  DBMS_OUTPUT.PUT_LINE('End Date '||v_end_date);
  DBMS_OUTPUT.PUT_LINE('Status '||V_Status);

exception
  when no_data_found then
    DBMS_OUTPUT.PUT_LINE(chr(10)||'Agent or Package is not existing in database.');
  when SCHED_CRASHED then 
    DBMS_OUTPUT.PUT_LINE(chr(10)||'Schedule of new AGENT crashed with this Package Schedule');
  when Permision_Ask then 
    DBMS_OUTPUT.PUT_LINE(chr(10)||'Need Permision,Cannot Simply Change the Agent when Package Schedule is Activate');
  when Same_Agent then 
    DBMS_OUTPUT.PUT_LINE(chr(10)||'Hello! Change to Same Agent is fun?');
end;
/
--crashed
exec PACKSCHED_CHANGE_AGENT(311,1021)
--Same
exec PACKSCHED_CHANGE_AGENT(311,1007)
--ACTIVATE
exec PACKSCHED_CHANGE_AGENT(308,1007)
--valid
exec PACKSCHED_CHANGE_AGENT(311,1009)




CREATE OR REPLACE PROCEDURE SET_PACKAGE_SCHEDULE(AGENT_NO IN NUMBER, Package_NO IN NUMBER, FromDate IN Date, toDate In Date, Available_Status In Number:=0, Schedule_Remark In VARCHAR2:=' ')  AS 
    
  V_Status VARCHAR2(10);
  v_next_ID INT;
  V_SEAT_AVAILABLE INT;
  v_agent_name Travel_Agent.Agent_Name%type;
  v_package_Name travel_package.Package_Name%type;

  Date_CRASHED exception;
  Invalid_Schedule exception;

  cursor agent_schedule is 
  select Start_Date,End_Date
  from Package_Schedule where Agent_ID=AGENT_NO;

begin
  --set id
  select max(Package_Schedule_ID) INTO v_next_ID
  from Package_Schedule;
  v_next_ID:=v_next_ID+1;

  --get seat
  select Seat into V_SEAT_AVAILABLE from travel_package where Package_ID=Package_No;

  --change status
  if(Available_Status=1)then
    V_Status:='active';
  ELSE
    V_Status:='deactivate';
  END IF;

  --check schedule
  FOR SCHED_REC IN agent_schedule loop
    IF(SCHED_REC.Start_Date Between FromDate AND toDate) THEN
      RAISE Date_CRASHED;
    elsif(SCHED_REC.End_Date Between FromDate AND toDate) then
      RAISE Date_CRASHED;
    END IF;      
  end loop;

  --check schedule provided
  IF(FromDate > toDate) then
      RAISE Invalid_Schedule;
  END IF;


  --get info to display
  select Agent_Name into v_agent_name from Travel_Agent where Agent_ID=AGENT_NO;
  select Package_Name into v_package_Name from travel_package where Package_ID=Package_NO;


  insert into Package_Schedule(Package_Schedule_ID, Start_Date, End_Date, Schedule_Remark, Seat_Available, Available_Status, Agent_ID, Package_ID)
  values(v_next_ID,FromDate,toDate,Schedule_Remark,V_SEAT_AVAILABLE,V_Status,AGENT_NO,Package_NO);

  DBMS_OUTPUT.PUT_LINE(CHR(10)||'Package Schedule ID: '||v_next_ID||' created on '||sysdate);
  DBMS_OUTPUT.PUT_LINE('Package Schedule Assigned Succefully to '||AGENT_NO||'-'||v_agent_name);
  DBMS_OUTPUT.PUT_LINE('Package_No : '||Package_NO||'-'||v_package_Name);
  DBMS_OUTPUT.PUT_LINE('From Date: '||FromDate||' To Date: '||toDate);
  DBMS_OUTPUT.PUT_LINE('Available_Status SET '||V_Status);
  DBMS_OUTPUT.PUT_LINE('Remark on Schedule: '||Schedule_Remark);

  exception
    when no_data_found then
      DBMS_OUTPUT.PUT_LINE(chr(10)||'THE ENQUIRY IS NOT IN THE DATABASE');
    when Date_CRASHED then 
      DBMS_OUTPUT.PUT_LINE(chr(10)||'SCHEDULE ADDING FAILED, CRASHED WITH OTHER PACKAGE_SCHEDULE');
    when Invalid_Schedule then
      DBMS_OUTPUT.PUT_LINE(chr(10)||'SCHEDULE ADDING FAILED, Please Check on Start Date and End Date');
end;
/
--crashed
exec SET_PACKAGE_SCHEDULE(1021,200,TO_DATE('8-8-2021','DD-MM-YYYY'),TO_DATE('10-8-2021','DD-MM-YYYY'))
--schedule invalid
exec SET_PACKAGE_SCHEDULE(1021,200,TO_DATE('10-9-2021','DD-MM-YYYY'),TO_DATE('8-9-2021','DD-MM-YYYY'))
--Valid
exec SET_PACKAGE_SCHEDULE(1021,200,TO_DATE('10-9-2021','DD-MM-YYYY'),TO_DATE('12-9-2021','DD-MM-YYYY'))

--For test change agent 
exec SET_PACKAGE_SCHEDULE(1007,202,TO_DATE('8-8-2021','DD-MM-YYYY'),TO_DATE('10-8-2021','DD-MM-YYYY'))

--1017
--for report
exec SET_PACKAGE_SCHEDULE(1017,203,TO_DATE('1-4-2021','DD-MM-YYYY'),TO_DATE('5-4-2021','DD-MM-YYYY'))
exec SET_PACKAGE_SCHEDULE(1017,204,TO_DATE('16-4-2021','DD-MM-YYYY'),TO_DATE('20-4-2021','DD-MM-YYYY'))
exec SET_PACKAGE_SCHEDULE(1017,202,TO_DATE('22-4-2021','DD-MM-YYYY'),TO_DATE('27-4-2021','DD-MM-YYYY'))

exec SET_PACKAGE_SCHEDULE(1017,202,TO_DATE('11-5-2021','DD-MM-YYYY'),TO_DATE('16-5-2021','DD-MM-YYYY'))
exec SET_PACKAGE_SCHEDULE(1017,202,TO_DATE('20-5-2021','DD-MM-YYYY'),TO_DATE('25-5-2021','DD-MM-YYYY'))

--1017 DONE SCHEDULE 
exec SET_PACKAGE_SCHEDULE(1017,203,TO_DATE('1-2-2021','DD-MM-YYYY'),TO_DATE('5-2-2021','DD-MM-YYYY'))
exec SET_PACKAGE_SCHEDULE(1017,201,TO_DATE('1-3-2021','DD-MM-YYYY'),TO_DATE('7-3-2021','DD-MM-YYYY'))