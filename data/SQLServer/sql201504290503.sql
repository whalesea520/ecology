CREATE TABLE FullSearch_Robot (
id int NOT NULL IDENTITY(1,1) ,
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
go
INSERT INTO FullSearch_Robot VALUES ('����', '���� weather ������� ����Ԥ��', NULL, '2015-04-01', '/fullsearch/robot/weather.jsp', 600, 100, '1', 0);
GO
INSERT INTO FullSearch_Robot VALUES ('�żٰ���', '�ż� holiday', '', '2015-04-01', '/fullsearch/robot/HolidayCalendar.jsp', 720, 300, '1', 0);
GO