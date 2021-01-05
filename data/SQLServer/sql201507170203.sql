create table mode_customResource
(
id int identity(1,1) primary key,
appid int,
resourceName varchar(256),
customSearchId int,
titleFieldId int,
startDateFieldId int,
endDateFieldId int,
startTimeFieldId int,
endTimeFieldId int,
contentFieldId int,
resourceFieldId int,
resourceShowFieldid int,
description text,
dsporder int
)
go