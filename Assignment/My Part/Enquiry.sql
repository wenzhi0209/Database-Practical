set linesize 200;
column Enquiry_Desc format a30;
column Agent_Reply format a30;
column Cust_Experience format a30;


--In auto increment if you wanna to delete whole table data you should reset the idenetity.
--trigger can automate do the adjusting on it
--For enquiry
delete from Enquiry;
ALTER table Enquiry modify Enquiry_ID generated always as identity restart start with 1000;


Drop table Enquiry();

CREATE TABLE Enquiry (
	Enquiry_ID INT GENERATED BY DEFAULT ON NULL AS IDENTITY START WITH 1000 INCREMENT BY 1,
	Enquiry_Desc VARCHAR2(1000) NOT NULL,
	Enquiry_Date Date NOT NULL,
	Agent_Reply VARCHAR2(1000),	
	Cust_Rating INT DEFAULT null,
	Cust_Experience VARCHAR2(1000),
	Cust_ID INT NOT NULL,
	Agent_ID INT,
	PRIMARY KEY (Enquiry_ID),
	CONSTRAINT FK_Travel_Agent FOREIGN KEY (Agent_ID) REFERENCES Travel_Agent(Agent_ID),
	CONSTRAINT FK_Customer_ID FOREIGN KEY (Cust_ID) REFERENCES Tourism_Customer(Cust_ID),
	CONSTRAINT C_cust_Rating check(Cust_Rating between 0 and 5)
);

SELECT *
  FROM user_cons_columns
 WHERE table_name = 'enquiry';

insert into Enquiry (Enquiry_Desc, Enquiry_Date, Agent_Reply, Cust_Rating, Cust_Experience, Cust_ID, Agent_ID ) 
values ('How do I book?'
,TO_DATE( '2020-06-04','YYYY-MM-DD'), 
'To proceed with a booking please click on the red "CLICK HERE TO BOOK NOW" button at the bottom of your quote and submit a booking form. Once we receive this your request will be actioned.'
, 5, null, 0001, 1001);

insert into Enquiry (Enquiry_Desc, Enquiry_Date, Agent_Reply, Cust_Rating, Cust_Experience, Cust_ID, Agent_ID ) 
values ('Are the jellyfish dangerous?'
, TO_DATE('2020-06-02','YYYY-MM-DD'),
'Most jellyfish in Australia are harmless gelatinous creatures with umbrella like bodies and flowing tentacles.'
, 1, 
'Not true information, I was in the hospital for a week because of it ！！！'
, 0002, 1003);

insert into Enquiry (Enquiry_Desc, Enquiry_Date, Agent_Reply, Cust_Rating, Cust_Experience, Cust_ID, Agent_ID ) 
values ('What if I have special requests?'
, TO_DATE('2021-01-11','YYYY-MM-DD'), 
'The booking form gives you the opportunity to let us know your special requests. All requests are passed onto the property and these will be accommodated by the property where ever possible.'
, 2, null, 0003, 1004);


insert into Enquiry (Enquiry_Desc, Enquiry_Date, Agent_Reply, Cust_Rating, Cust_Experience, Cust_ID, Agent_ID ) 
values ('What if I dont hear from you after I have made the booking request?',
TO_DATE('2020-04-28','YYYY-MM-DD'),
'We respond to all booking requests. Its possible our emails may be filtered out by some Spam programs, so please check your Junk folders just in case. If you do not receive a response from us please contact your Consultant by email or by phone 07 3804 8411 or for urgent queries email res@travelonline.com.'
, 5, 'Nice', 0007, 1005);

insert into Enquiry (Enquiry_Desc, Enquiry_Date, Agent_Reply, Cust_Rating, Cust_Experience, Cust_ID, Agent_ID ) 
values ('Do I need an international drivers licence to hire a car?', 
TO_DATE('2021-03-30','YYYY-MM-DD'), null,null, null,0009, null);

insert into Enquiry (Enquiry_Desc, Enquiry_Date, Agent_Reply, Cust_Rating, Cust_Experience, Cust_ID, Agent_ID ) values 
('When will my credit card be charged?', 
TO_DATE('2021-03-04','YYYY-MM-DD'), null, null, null, 0011, null);

insert into Enquiry (Enquiry_Desc, Enquiry_Date, Agent_Reply, Cust_Rating, Cust_Experience, Cust_ID, Agent_ID ) 
values ('I do not like entering my credit card details online',
TO_DATE('2020-09-04','YYYY-MM-DD'), null, null, null, 0023, null);


insert into Enquiry (Enquiry_Desc, Enquiry_Date, Agent_Reply, Cust_Rating, Cust_Experience, Cust_ID, Agent_ID ) 
values ('What if I do not have a credit card?'
, 
TO_DATE('2020-04-01','YYYY-MM-DD'),
'Contact your consultant via email and you will be advised on other payment options. We offer multiple payment options such as PayPal and Direct Deposit.'
, 3, 
'It should be provide more payment option such as online FPX payment'
, 0024, 1013);

insert into Enquiry (Enquiry_Desc, Enquiry_Date, Agent_Reply, Cust_Rating, Cust_Experience, Cust_ID, Agent_ID ) 
values ('What is a Stay/Pay?',
TO_DATE('2020-03-05','YYYY-MM-DD'), 'A Stay/Pay deal is where you pay for a certain number of nights and receive some nights free of charge.Example: Stay 4 Nights/Pay 3 Nights - The total stay is 4 nights but you only pay for 3 nights - 1 night is free.'
, null, null, 0036, 1014);

insert into Enquiry (Enquiry_Desc, Enquiry_Date, Agent_Reply, Cust_Rating, Cust_Experience, Cust_ID, Agent_ID ) 
values ('What will the weather be like?'
, TO_DATE('2021-01-02','YYYY-MM-DD'), 
'Obviously the weather can be variable no matter when or where your travel. Climate information can give you a good guide to average temperatures and rainfall data. We strongly recommend you research the climate of the destination you are travelling to and we also recommend you purchase Travel Insurance, just in case inclement weather impacts your travel plans.'
, null, null, 0030, 1015);


insert into Enquiry (Enquiry_Desc, Enquiry_Date, Agent_Reply, Cust_Rating, Cust_Experience, Cust_ID, Agent_ID ) 
values ('How long does it take to drive from Sydney to Cairns?'
, TO_DATE('2020-11-24','YYYY-MM-DD'),
 'Visitors to Australia are always surprised at the size of Australia and the time and distance it takes to travel between places. Sydney to Cairns is 2447km or about 36 hours continuous driving with limited toilet stops.'
 , 5,null, 0045, 1016);


insert into Enquiry (Enquiry_Desc, Enquiry_Date, Agent_Reply, Cust_Rating, Cust_Experience, Cust_ID, Agent_ID ) 
values ('Do you charge Merchant Fees?'
,TO_DATE('2020-05-22','YYYY-MM-DD'), 
'We charge Merchant Fees on deposit and final payments of 1.37% for Credit Card payments and 1.10% for PayPal payments. To avoid Merchant Fees on your final payments you can pay through BPay using your credit card, debit card, savings, cheque or transaction account. You can also pay using direct deposit to avoid the Merchant Fees.'
, 2, null, 0015, 1017);


insert into Enquiry (Enquiry_Desc, Enquiry_Date, Agent_Reply, Cust_Rating, Cust_Experience, Cust_ID, Agent_ID ) 
values ('DOES IT COST MONEY TO GET A QUOTE?'
, TO_DATE('2021-01-22','YYYY-MM-DD'), 
'No, there is no fee for our vacation planning services as the travel vendors involved recognize our value and compensate us from the gross amount paid (what you would have paid even without our assistance).'
, 5, null, 0018, 1018);

insert into Enquiry (Enquiry_Desc, Enquiry_Date, Agent_Reply, Cust_Rating, Cust_Experience, Cust_ID, Agent_ID ) 
values ('DO I NEED TRAVEL INSURANCE?'
, TO_DATE('2020-04-08','YYYY-MM-DD'),
 'Travel insurance is available and recommended to protect your travel investment. Many trips, such as tours and cruises, involve non-refundable funds paid months in advance. Travel insurance protects you from losing this investment.'
, 4, null, 0013, 1019);


insert into Enquiry (Enquiry_Desc, Enquiry_Date, Agent_Reply, Cust_Rating, Cust_Experience, Cust_ID, Agent_ID ) 
values ('HOW DO I CANCEL A TRIP?'
,TO_DATE('2020-08-17','YYYY-MM-DD'), 
'Call us right away. If it is after normal business hours, please contact the next involved travel supplier (airline, hotel, tour operator, cruise line) to cancel any reservations you will not be able to use.'
, 3,'Too many step and process in cancel my trip', 0046, 1001);

insert into Enquiry (Enquiry_Desc, Enquiry_Date, Agent_Reply, Cust_Rating, Cust_Experience, Cust_ID, Agent_ID ) 
values ('WHY SHOULD I BOOK WITH YOU INSTEAD OF AN ONLINE BOOKING SITE, OR DIRECT WITH A RESORT?'
,TO_DATE('2020-12-19','YYYY-MM-DD'), 'With us, you get exceptional personal assistance before, during, and after your vacation. ', 4, 'okay', 0044, 1003);


insert into Enquiry (Enquiry_Desc, Enquiry_Date, Agent_Reply, Cust_Rating, Cust_Experience, Cust_ID, Agent_ID ) 
values ('I am traveling with a group of friends. Can our hotel rooms be adjoining?'
,TO_DATE('2020-01-06','YYYY-MM-DD'), 
'Please indicate on your reservation from whom you are traveling with and we will request that the hotel assigns your rooms next to each other. Although adjacent rooms will be requested, the hotels are not always able to accommodate. We will ensure your rooms are near each other if not connected.'
, 4, 'Thank you'
, 0022, 1004);

insert into Enquiry (Enquiry_Desc, Enquiry_Date, Agent_Reply, Cust_Rating, Cust_Experience, Cust_ID, Agent_ID ) 
values ('What Are the Best Travel Destinations, and How Do I Know If They are Safe?'
, TO_DATE('2020-11-28','YYYY-MM-DD'), 
'There is no single right answer to this question. It really depends on factors like your personal travel style and when you plan to travel. '
, 1, 
'Answer is useless for me, seems like simply copy answer from somewhere.'
, 0019, 1005);

insert into Enquiry (Enquiry_Desc, Enquiry_Date, Agent_Reply, Cust_Rating, Cust_Experience, Cust_ID, Agent_ID ) 
values ('I am a single traveler. Is it possible to have a roommate?'
,TO_DATE( '2021-01-09','YYYY-MM-DD'),
 'Being a single traveler should not keep you from going on an adventure! We do not automatically pair up single travelers as roommates, but if you register for a tour as a single and want a roommate, let us know. We will make note of your request and if someone else inquires about wanting a roommate on the same tour, with your permission, we will give each of you the other person contact information.'
, 5,
null
, 0014, 1006);

insert into Enquiry (Enquiry_Desc, Enquiry_Date, Agent_Reply, Cust_Rating, Cust_Experience, Cust_ID, Agent_ID ) 
values ('Is gratuity included in the price of the tour?'
, TO_DATE('2020-10-13','YYYY-MM-DD'), 
'All necessary tipping to the bellman for luggage handling and waiters for included meals have been included and will be handled by your Tour Director on your behalf.'
, 3, null
, 0029, 1007);





