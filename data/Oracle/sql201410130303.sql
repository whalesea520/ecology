CREATE TABLE  CommunicateLog (
id int NOT NULL  PRIMARY key,
relatedid int NOT NULL ,
relatedname varchar(440) NULL ,
operatetype varchar(2) NOT NULL ,
operatedesc VARCHAR(2000) NULL ,
operateitem varchar(20) NULL ,
operateuserid int NOT NULL ,
operatedate char(10) NOT NULL ,
operatetime char(8) NOT NULL ,
clientaddress char(15) NULL ,
istemplate int NULL ,
operatesmalltype int NULL ,
operateusertype int NULL 
)
/
create sequence CommunicateLog_id
minvalue 1
start with 1
increment by 1
/
create or replace trigger CommunicateLog_id_tri
before insert on CommunicateLog for each row
begin
select CommunicateLog_id.nextval into :new.id from dual;
end;
/


create or replace trigger CommunicateLog_trigger
  after insert on CommunicateLog
  for each row 
DECLARE 
 
 SysMaintenanceLog_proc(
:new.relatedid,
:new.relatedname,
:new.operateuserid,
:new.operateusertype,
:new.operatetype,
:new.operatedesc,
:new.operateitem,
:new.operatedate,
:new.operatetime,
:new.operatesmalltype,
:new.clientaddress,
0 );
end;
/