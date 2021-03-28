column tour_desc format a50
column destination format a30

INSERT INTO TOUR VALUES(100, 'Johor','This trip will be destinated at Johor, one of the famous city in Malaysia.');
INSERT INTO TOUR VALUES(101, 'Kuala Lumpur','This trip will be destinated at Kuala Lumpur, capital city of Malaysia.');
INSERT INTO TOUR VALUES(102, 'Pulau Penang','This trip will be destinated at Pulau Penang, enjoyed the sea side scenery and mouth-watering food.');
INSERT INTO TOUR VALUES(103, 'Nagoya','This trip will be destinated at Nagoya, famous city in Japan.');
INSERT INTO TOUR VALUES(104, 'Bangkok','This trip will be destinated at Bangkok, highest popularity and capital city of Thailand.');

INSERT INTO Travel_package VALUES(200, 'Stunning seaside and amazing feast in Penang', 890.00, 40, 102, 1002);
INSERT INTO Travel_package VALUES(201, 'Relaxing in Nagoya', 7750.00, 35, 103, 1000);
INSERT INTO Travel_package VALUES(202, 'A week in Johor', 1360.00, 25, 100, 1002);
INSERT INTO Travel_package VALUES(203, 'Lost in KL', 650.00, 30, 101, 1005);
INSERT INTO Travel_package VALUES(204, 'Crazy Shopping in Bangkok', 3500.00, 45, 104, 1004);

alter table driver drop driver_age;
alter table driver drop license;
alter table driver add dob date not null;
alter table driver add license_expiring Date not null;
alter table driver modify driver_name varchar2(20);



INSERT INTO package_schedule VALUES(300, TO_DATE( '2021-10-12','YYYY-MM-DD'), TO_DATE( '2021-10-16','YYYY-MM-DD'), '', 40, 'active', 1002, 200);
INSERT INTO package_schedule VALUES(301, TO_DATE( '2022-02-01','YYYY-MM-DD'), TO_DATE( '2022-02-06','YYYY-MM-DD'), 'May cost more(depend how you spend!)', 45, 'active', 1011, 204);
INSERT INTO package_schedule VALUES(302, TO_DATE( '2022-01-23','YYYY-MM-DD'), TO_DATE( '2022-01-30','YYYY-MM-DD'), '', 35, 'active', 1004, 201);
INSERT INTO package_schedule VALUES(303, TO_DATE( '2021-11-08','YYYY-MM-DD'), TO_DATE( '2021-11-10','YYYY-MM-DD'), 'Fee may reduced!(depend where you lived)', 30, 'active', 1021, 203);
INSERT INTO package_schedule VALUES(304, TO_DATE( '2021-05-05','YYYY-MM-DD'), TO_DATE( '2021-05-08','YYYY-MM-DD'), '', 25, 'active', 1017, 202);
INSERT INTO package_schedule VALUES(305, TO_DATE( '2022-02-01','YYYY-MM-DD'), TO_DATE( '2022-02-06','YYYY-MM-DD'), 'Extra package!', 45, 'active', 1005, 204);
INSERT INTO package_schedule VALUES(306, TO_DATE( '2021-06-23','YYYY-MM-DD'), TO_DATE( '2021-06-27','YYYY-MM-DD'), '', 40, 'active', 1009, 200);
INSERT INTO package_schedule VALUES(307, TO_DATE( '2021-11-08','YYYY-MM-DD'), TO_DATE( '2021-11-10','YYYY-MM-DD'), 'Extra package!', 30, 'active', 1025, 203);
INSERT INTO package_schedule VALUES(308, TO_DATE( '2021-09-05','YYYY-MM-DD'), TO_DATE( '2021-09-07','YYYY-MM-DD'), '', 30, 'active', 1013, 203);
INSERT INTO package_schedule VALUES(309, TO_DATE( '2021-08-05','YYYY-MM-DD'), TO_DATE( '2021-08-09','YYYY-MM-DD'), '', 40, 'active', 1021, 200);

insert into Driver values(1000,'Sam Hong', TO_DATE( '1995-10-12','YYYY-MM-DD'), TO_DATE( '2021-10-23','YYYY-MM-DD'), TO_DATE( '2015-10-10','YYYY-MM-DD'));
insert into Driver values(1001,'Kelvin Chong', TO_DATE('1994-09-10','YYYY-MM-DD'), TO_DATE('2021-03-20','YYYY-MM-DD'),TO_DATE('2016-05-10','YYYY-MM-DD'));
insert into Driver values(1002,'Nelson Tan',TO_DATE( '1993-09-09','YYYY-MM-DD'), TO_DATE('2021-01-21','YYYY-MM-DD'),TO_DATE( '2012-03-04','YYYY-MM-DD'));
insert into Driver values(1003,'William Chen',TO_DATE( '1992-01-02','YYYY-MM-DD'), TO_DATE('2021-02-01','YYYY-MM-DD'),TO_DATE( '2011-02-11','YYYY-MM-DD'));
insert into Driver values(1004,'James Bond', TO_DATE('1989-09-08','YYYY-MM-DD'),TO_DATE('2022-01-23','YYYY-MM-DD'),TO_DATE( '2009-09-21','YYYY-MM-DD'));
insert into Driver values(1005,'Bijan Razak', TO_DATE('1980-05-04','YYYY-MM-DD'), TO_DATE('2022-02-03','YYYY-MM-DD'),TO_DATE( '2009-01-21','YYYY-MM-DD'));
insert into Driver values(1006,'Mahadew Muhd',TO_DATE( '1972-07-02','YYYY-MM-DD'),TO_DATE( '2021-11-30','YYYY-MM-DD'),TO_DATE( '2007-07-20','YYYY-MM-DD'));
insert into Driver values(1007,'Carter Tree',TO_DATE( '1970-10-10','YYYY-MM-DD'), TO_DATE('2021-12-23','YYYY-MM-DD'),TO_DATE( '2010-09-21','YYYY-MM-DD'));
insert into Driver values(1008,'Julian Will',TO_DATE( '1969-06-09','YYYY-MM-DD'),TO_DATE( '2023-01-23','YYYY-MM-DD'),TO_DATE( '2005-01-22','YYYY-MM-DD'));
insert into Driver values(1009,'Bill Gatez',TO_DATE( '1975-07-05','YYYY-MM-DD'),TO_DATE( '2022-08-23','YYYY-MM-DD'),TO_DATE( '2008-03-20','YYYY-MM-DD'));

Insert into Tourism_Vehicle values(1000,  'Volvo B8RLE', 'ADB 1234',1000);
Insert into Tourism_Vehicle values(1001,  'Scania K310UD',  'WWE 5524',1001);
Insert into Tourism_Vehicle values(1002, 'Leyland Olypian', 'EDM 7778',1002);
Insert into Tourism_Vehicle values(1003,  'Volvo B8RLE', 'WWW 8888', 1003);
Insert into Tourism_Vehicle values(1004,  'Scania K310UD', 'AMC 9090',1004);
Insert into Tourism_Vehicle values(1005,  'Leyland Olypian', 'AZZ 9212',1005);
Insert into Tourism_Vehicle values(1006,  'Volvo B8RLE', 'YOU 1314',1006);
Insert into Tourism_Vehicle values(1007,   'Leyland Olypian', 'WWC 6578',1007);
Insert into Tourism_Vehicle values(1008,   'Scania K310UD', 'AUT 7774',1008);
Insert into Tourism_Vehicle values(1009,   'Volvo B8RLE', 'AES 7788',1009);

Insert into Bus_Schedule values	(1000,  TO_DATE('2021-2-10','YYYY-MM-DD'),TO_DATE('2021-2-10','YYYY-MM-DD'),1000);
Insert into Bus_Schedule values	(	1001	, TO_DATE('2021-2-10','YYYY-MM-DD'),	 TO_DATE('2021-2-10','YYYY-MM-DD'),	1001	);
Insert into Bus_Schedule values	(	1002	, TO_DATE('2021-2-10','YYYY-MM-DD'),	TO_DATE('2021-2-10','YYYY-MM-DD'),	1002	);
Insert into Bus_Schedule values	(	1003	,TO_DATE('2021-2-11','YYYY-MM-DD'),	TO_DATE( '2021-2-11','YYYY-MM-DD'),	1003	);
Insert into Bus_Schedule values	(	1004	,TO_DATE('2021-2-11','YYYY-MM-DD'),	TO_DATE( '2021-2-11','YYYY-MM-DD'),	1004	);
Insert into Bus_Schedule values	(	1005	,TO_DATE('2021-2-12','YYYY-MM-DD'),	TO_DATE( '2021-2-12','YYYY-MM-DD'),	1005	);
Insert into Bus_Schedule values	(	1006	,TO_DATE('2021-2-12','YYYY-MM-DD'),	 TO_DATE('2021-2-12','YYYY-MM-DD'),	1006	);
Insert into Bus_Schedule values	(	1007	,TO_DATE('2021-2-13','YYYY-MM-DD'),	TO_DATE( '2021-2-13','YYYY-MM-DD'),	1007	);
Insert into Bus_Schedule values	(	1008	,TO_DATE('2021-2-14','YYYY-MM-DD'),	TO_DATE( '2021-2-14','YYYY-MM-DD'),	1008	);
Insert into Bus_Schedule values	(	1009	,TO_DATE('2021-2-15','YYYY-MM-DD'),	TO_DATE( '2021-2-15','YYYY-MM-DD'),	1009	);
Insert into Bus_Schedule values	(	1010	,TO_DATE('2021-2-18','YYYY-MM-DD'),	TO_DATE( '2021-2-18','YYYY-MM-DD'),	1000	);
Insert into Bus_Schedule values	(	1011	,TO_DATE('2021-2-19','YYYY-MM-DD'),	 TO_DATE('2021-2-19','YYYY-MM-DD'),	1001	);
Insert into Bus_Schedule values	(	1012	,TO_DATE('2021-2-20','YYYY-MM-DD'),	TO_DATE( '2021-2-20','YYYY-MM-DD'),	1002	);
Insert into Bus_Schedule values	(	1013	,TO_DATE('2021-2-21','YYYY-MM-DD'),	 TO_DATE('2021-2-21','YYYY-MM-DD'),	1003	);
Insert into Bus_Schedule values	(	1014	,TO_DATE('2021-2-22','YYYY-MM-DD'),	TO_DATE( '2021-2-22','YYYY-MM-DD'),	1004	);
Insert into Bus_Schedule values	(	1015	,TO_DATE('2021-2-23','YYYY-MM-DD'),	TO_DATE( '2021-2-23','YYYY-MM-DD'),	1005	);
Insert into Bus_Schedule values	(	1016	,TO_DATE('2021-2-25','YYYY-MM-DD'),	TO_DATE( '2021-2-25','YYYY-MM-DD'),	1006	);
Insert into Bus_Schedule values	(	1017	,TO_DATE('2021-2-27','YYYY-MM-DD'),	TO_DATE( '2021-2-27','YYYY-MM-DD'),	1007	);
Insert into Bus_Schedule values	(	1018	,TO_DATE('2021-2-28','YYYY-MM-DD'),	 TO_DATE('2021-2-28','YYYY-MM-DD'),	1008	);
Insert into Bus_Schedule values	(	1019	,TO_DATE('2021-2-18','YYYY-MM-DD'),	TO_DATE( '2021-2-21','YYYY-MM-DD'),	1009	);
Insert into Bus_Schedule values	(	1020	,TO_DATE('2021-2-18','YYYY-MM-DD'),	 TO_DATE('2021-2-21','YYYY-MM-DD'),	1000	);
Insert into Bus_Schedule values	(	1021	,TO_DATE('2021-2-18','YYYY-MM-DD'),	 TO_DATE('2021-2-21','YYYY-MM-DD'),	1001	);
Insert into Bus_Schedule values	(	1022	,TO_DATE('2021-2-18','YYYY-MM-DD'),	TO_DATE( '2021-2-21','YYYY-MM-DD'),	1002	);
Insert into Bus_Schedule values	(	1023	,TO_DATE('2021-2-18','YYYY-MM-DD'),	TO_DATE( '2021-2-21','YYYY-MM-DD'),	1003	);
Insert into Bus_Schedule values	(	1024	,TO_DATE('2021-2-18','YYYY-MM-DD'),	 TO_DATE('2021-2-21','YYYY-MM-DD'),	1004	);
Insert into Bus_Schedule values	(	1025	,TO_DATE('2021-2-18','YYYY-MM-DD'),	TO_DATE( '2021-2-21','YYYY-MM-DD'),	1005	);
Insert into Bus_Schedule values	(	1026	,TO_DATE('2021-2-18','YYYY-MM-DD'),	 TO_DATE('2021-2-21','YYYY-MM-DD'),	1006	);
Insert into Bus_Schedule values	(	1027	,TO_DATE('2021-2-18','YYYY-MM-DD'),	TO_DATE( '2021-2-21','YYYY-MM-DD'),	1007	);
Insert into Bus_Schedule values	(	1028	,TO_DATE('2021-2-18','YYYY-MM-DD'),	TO_DATE( '2021-2-21','YYYY-MM-DD'),	1008	);
Insert into Bus_Schedule values	(	1029	,TO_DATE('2021-2-18','YYYY-MM-DD'),	TO_DATE( '2021-2-21','YYYY-MM-DD'),	1009	);
Insert into Bus_Schedule values	(	1030	,TO_DATE('2021-2-18','YYYY-MM-DD'),	TO_DATE( '2021-2-21','YYYY-MM-DD'),	1000	);
Insert into Bus_Schedule values	(	1031	,TO_DATE('2021-2-18','YYYY-MM-DD'),	 TO_DATE('2021-2-21','YYYY-MM-DD'),	1001	);
Insert into Bus_Schedule values	(	1032	,TO_DATE('2021-2-18','YYYY-MM-DD'),	TO_DATE( '2021-2-21','YYYY-MM-DD'),	1002	);
Insert into Bus_Schedule values	(	1033	,TO_DATE('2021-2-18','YYYY-MM-DD'),	TO_DATE( '2021-2-21','YYYY-MM-DD'),	1003	);
Insert into Bus_Schedule values	(	1034	,TO_DATE('2021-2-18','YYYY-MM-DD'),	 TO_DATE('2021-2-21','YYYY-MM-DD'),	1004	);
Insert into Bus_Schedule values	(	1035	,TO_DATE('2021-2-18','YYYY-MM-DD'),	TO_DATE( '2021-2-21','YYYY-MM-DD'),	1005	);
Insert into Bus_Schedule values	(	1036	,TO_DATE('2021-2-18','YYYY-MM-DD'),	 TO_DATE('2021-2-21','YYYY-MM-DD'),	1006	);
Insert into Bus_Schedule values	(	1037	,TO_DATE('2021-2-18','YYYY-MM-DD'),	 TO_DATE('2021-2-21','YYYY-MM-DD'),	1007	);
Insert into Bus_Schedule values	(	1038	,TO_DATE('2021-2-18','YYYY-MM-DD'),	TO_DATE( '2021-2-21','YYYY-MM-DD'),	1008	);
Insert into Bus_Schedule values	(	1039	,TO_DATE('2021-2-18','YYYY-MM-DD'),	 TO_DATE('2021-2-21','YYYY-MM-DD'),	1009	);
Insert into Bus_Schedule values	(	1040	,TO_DATE('2021-2-18','YYYY-MM-DD'),	 TO_DATE('2021-2-21','YYYY-MM-DD'),	1009	);

