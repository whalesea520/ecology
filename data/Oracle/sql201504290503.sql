CREATE TABLE FullSearch_Robot (
id int NOT NULL primary key ,
title varchar(255),
keywords varchar(2000) ,
url varchar(2000),
createdate varchar(10),
iframeUrl varchar(2000) ,
width int  ,
height int  ,
showDiv char(1),
state int  
)
/
create sequence FullSearch_Robot_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger FullSearch_Robot_Tr before insert on FullSearch_Robot for each row 
begin select FullSearch_Robot_ID.nextval into :new.id from dual; end;
/
INSERT INTO FullSearch_Robot(title,keywords,url,createdate,iframeUrl,width,height,showDiv,state) VALUES ('天气', '天气 weather 最近天气 天气预报', NULL, '2015-04-01', '/fullsearch/robot/weather.jsp', 600, 100, '1', 0)
/
INSERT INTO FullSearch_Robot(title,keywords,url,createdate,iframeUrl,width,height,showDiv,state) VALUES ('放假安排', '放假 holiday', '', '2015-04-01', '/fullsearch/robot/HolidayCalendar.jsp', 720, 300, '1', 0)
/