
column Package_Name format a50;
column Start_Date format a12;
column End_Date format a12;
column Available_Status format a20;

Select Package_Name, Start_Date, End_Date, Available_Status
From Package_Schedule PS
Inner Join Travel_Package TP On TP.Package_ID=PS.Package_ID
Where (Agent_ID=&Agent_ID) AND 
(Start_Date>=to_date('&From_Date','dd/mm/yyyy') AND Start_Date<=to_date('&To_Date','dd/mm/yyyy'));

1021 --Agent ID
1-1-2021 --Start Date
1-1-2022 --To Date

SET LINESIZE 200
SET RECSEP WRAPPED

SET UNDERLINE .

column Agent_Name format a30;

Select A.AGENT_ID,AGENT_NAME,COUNT(Package_Schedule_ID) AS NUMPACK
From Travel_Agent A 
LEFT JOIN Package_Schedule PS ON A.Agent_ID=PS.Agent_ID 
WHERE (extract(year from Start_Date)>=&From_Year AND extract(year from Start_Date)<=&To_Year) 
GROUP BY AGENT_NAME,A.Agent_ID
ORDER BY 3 DESC;

--from year 2020
--to year 2021





SET UNDERLINE =
Select Count(cust_Rating) as Number_of_Cust_Rating ,avg(Cust_Rating) AS AVERAGE_CUST_RATING
FROM Enquiry E INNER JOIN Tourism_Customer C ON E.Cust_ID = C.Cust_ID
Where ((Extract(Year from sysdate) - Extract(Year from C.DOB)) Between &From_Age AND &To_Age)
AND(Extract(Year from E.Enquiry_Date)=&YEAR);



