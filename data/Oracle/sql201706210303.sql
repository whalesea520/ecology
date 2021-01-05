CREATE TABLE CRM_BusniessInfoEache
(
id number primary key,
userid varchar(255),
data clob,
modifydate varchar(255),
modifytime varchar(255),
crmname varchar(255)
)
/
CREATE SEQUENCE CRM_busCache_sequence
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
NOCACHE
/
create trigger CRM_busCache_trigger before
insert on CRM_BusniessInfoEache for each row when (new.id is null)
begin
 select CRM_busCache_sequence.nextval into:new.id from dual;
end;
/
CREATE TABLE CRM_BusniessInfoLog
(
id number primary key,
crmid varchar(255),
requesttype varchar(255),
requestdate varchar(255),
requesttime varchar(255),
requestuid varchar(255)
)
/
CREATE SEQUENCE CRM_busLog_sequence
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
NOCACHE
/
create trigger CRM_busLog_trigger before
insert on CRM_BusniessInfoLog for each row when (new.id is null)
begin
 select CRM_busLog_sequence.nextval into:new.id from dual;
end;
/