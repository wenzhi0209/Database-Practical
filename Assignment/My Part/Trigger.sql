
CREATE OR REPLACE FUNCTION Calculate_Age(Dob in date) 
Return Number AS age number;
  
begin
   age := extract(year from sysdate)-extract(year from Dob);
   return age;
end;
/

Create or replace function Latest_Agent_ID
return number as 
   id number;
   v_count number;
begin
   SELECT max(Agent_ID),count(Agent_ID) into id,v_count
   FROM TRAVEL_AGENT;
   IF (v_count=0) THEN
      id:=1000;
   END IF;
   return id;
end;
/

Create or replace procedure Agent_ID_Adjustment AS id number;
begin
   id:=Latest_Agent_ID;
   if(id!=1000) then
      id:= id+1;
   end if;
   EXECUTE IMMEDIATE 'alter table Travel_Agent modify Agent_ID generated always as identity restart start with '||id;
   DBMS_OUTPUT.put_line('NEXT Agent_ID is '||id);
end;
/

Create or replace function Latest_Enquiry_ID
return number as 
   id number;
   v_count number;
begin
   SELECT max(Enquiry_ID),count(Enquiry_ID) into id,v_count
   FROM Enquiry;
   IF (v_count=0) THEN
      id:=1000;
   END IF;
   return id;
end;
/

Create or replace procedure Enquiry_ID_Adjustment AS id number;
begin
   id:=Latest_Enquiry_ID;
   if(id!=1000) then
      id:= id+1;
   end if;
   EXECUTE IMMEDIATE 'alter table Enquiry modify Enquiry_ID generated always as identity restart start with '||id;
   DBMS_OUTPUT.put_line('NEXT Enquiry_ID is '||id);
end;
/



SET SERVEROUTPUT ON;

--Trigger
CREATE OR REPLACE TRIGGER trg_Validate_Agent_Info
  Before UPDATE or Insert ON Travel_Agent 
  FOR EACH ROW
 
  DECLARE
      v_age number(5);
      b_email BOOLEAN;
      b_phone BOOLEAN;
      b_gender Boolean;
 
  begin
      v_age := Calculate_Age(:new.DoB);
      b_email:= REGEXP_LIKE (:new.Agent_Email,'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$');
      b_phone:= REGEXP_LIKE (:new.Agent_Phone,'^[0-9]*$');
      b_gender:=REGEXP_LIKE (:new.Agent_Gender,'^[MF]$');
 
      if (v_age >= 18) then
            if b_email then
                  if b_phone then
                     if (b_gender!=TRUE) then   
                        RAISE_APPLICATION_ERROR(-20003, 'Invalid Gender. Insert/Update Failed.Remember Exec Agent_ID_Adjustment');
                     end if;
                  else
                     RAISE_APPLICATION_ERROR(-20002, 'Invalid Phone number. Insert/Update Failed.Remember Exec Agent_ID_Adjustment');
                  end if;
            else
               RAISE_APPLICATION_ERROR(-20001, 'Invalid email address. Insert/Update Failed. Remember Exec Agent_ID_Adjustment');
            end if;
      else
         RAISE_APPLICATION_ERROR(-20000, 'Not yet 18 years old. Insert/Update Failed.Remember Exec Agent_ID_Adjustment'); 
      end if;
      DBMS_OUTPUT.PUT_LINE('INSERT / UPDATE SUCCESSFULLY AGENT_ID = '||:NEW.AGENT_ID);
end;
/


SELECT AGENT_ID FROM TRAVEL_AGENT;
--WRONG GENDER
Insert into Travel_Agent(AGENT_NAME,AGENT_PHONE,AGENT_EMAIL,AGENT_GENDER,AGENT_ADDRESS,DOB) 
VALUES('Alfreds Futterkiste','01117601411','Alfreds@gmail.com','G','Jalan Pjs 11/2, Taman Subang Indah,Petaling Jaya,Selangor',TO_DATE('2000-01-06','YYYY-MM-DD'));
--WRONG PHONENO
Insert into Travel_Agent(AGENT_NAME,AGENT_PHONE,AGENT_EMAIL,AGENT_GENDER,AGENT_ADDRESS,DOB) 
VALUES('Alfreds Futterkiste','01117601411AA','Alfreds@gmail.com','M','Jalan Pjs 11/2, Taman Subang Indah,Petaling Jaya,Selangor',TO_DATE('2000-01-06','YYYY-MM-DD'));
--WRONG EMAIL
Insert into Travel_Agent(AGENT_NAME,AGENT_PHONE,AGENT_EMAIL,AGENT_GENDER,AGENT_ADDRESS,DOB) 
VALUES('Alfreds Futterkiste','01117601411','Alfredsgmail.com','M','Jalan Pjs 11/2, Taman Subang Indah,Petaling Jaya,Selangor',TO_DATE('2000-01-06','YYYY-MM-DD'));
--AGE BELOW 18
Insert into Travel_Agent(AGENT_NAME,AGENT_PHONE,AGENT_EMAIL,AGENT_GENDER,AGENT_ADDRESS,DOB) 
VALUES('Alfreds Futterkiste','01117601411','Alfreds@gmail.com','M','Jalan Pjs 11/2, Taman Subang Indah,Petaling Jaya,Selangor',TO_DATE('2008-01-06','YYYY-MM-DD'));




create table Enquiry_Reply_Audit ( 
    Enquiry_ID INT,
    OLD_REPLY VARCHAR2(1000) DEFAULT NULL, 
    NEW_REPLY VARCHAR2(1000) DEFAULT NULL, 
    date_change date,
    Agent_ID INT
);

--Trigger 2
CREATE OR REPLACE TRIGGER trg_Agent_Reply_Enquiry
   AFTER UPDATE OF Agent_Reply ON ENQUIRY
   FOR EACH ROW
DECLARE
   NUMCHANGE NUMBER(3);
BEGIN
   select count(Enquiry_ID) INTO NUMCHANGE
   FROM Enquiry_Reply_Audit
   WHERE to_char(date_change,'DD-MON-YY') = to_char(SYSDATE,'DD-MON-YY') AND Enquiry_ID=:NEW.Enquiry_ID;

   IF(NUMCHANGE=0) THEN
      DBMS_OUTPUT.PUT_LINE('This is first times update on Enquiry('||:NEW.Enquiry_ID||') at '||to_char(SYSDATE,'DD-MON-YY'));
   ELSE
      NUMCHANGE:=NUMCHANGE+1;
      DBMS_OUTPUT.PUT_LINE('This is '||NUMCHANGE||' times update on Enquiry('||:NEW.Enquiry_ID||') at '||to_char(SYSDATE,'DD-MON-YY'));
   END IF;
   insert into Enquiry_Reply_Audit values (:NEW.Enquiry_ID,:OLD.Agent_Reply,:NEW.Agent_Reply,SYSDATE,:NEW.Agent_ID);
   DBMS_OUTPUT.PUT_LINE('Enquiry Reply Audit Record Created');
end;
/

COLUMN OLD_REPLY FORMAT A30
COLUMN NEW_REPLY FORMAT A30
select * from Enquiry_Reply_Audit;

insert into Enquiry (Enquiry_Desc, Enquiry_Date, Agent_Reply, Cust_Rating, Cust_Experience, Cust_ID, Agent_ID ) 
values ('Do I need an international drivers licence to hire a car?', 
TO_DATE('2021-03-30','YYYY-MM-DD'), null,null, null,0009, null);

update ENQUIRY set Agent_Reply='Yes, You will need it or else you call texi better',Agent_ID=1002
where enquiry_id=1004;

update ENQUIRY set Agent_Reply=NULL,Agent_ID=NULL
where enquiry_id=1004;


select enquiry_id from enquiry where cust_id=0009;
select AGENT_ID from enquiry where ENQUIRY_id=1004;
         
