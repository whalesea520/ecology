create table mode_customResource
(
id int,
appid int,
resourceName varchar2(256),
customSearchId int,
titleFieldId int,
startDateFieldId int,
endDateFieldId int,
startTimeFieldId int,
endTimeFieldId int,
contentFieldId int,
resourceFieldId int,
resourceShowFieldid int,
description varchar2(4000),
dsporder int
)
/

create sequence seq_modeResource
start with 1 
INCREMENT BY 1
NOCYCLE
/

create trigger tri_modeResource
before insert on mode_customResource 
for each row 
begin
select seq_modeResource.nextval into :new.id from dual;
end;
/