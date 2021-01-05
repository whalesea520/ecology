CREATE TABLE HrmSysMaintenanceLog
(
id INT NOT NULL PRIMARY KEY,
relatedid int NOT NULL,
relatedname varchar (440) NULL,
operatetype varchar (2) NOT NULL,
operatedesc VARCHAR2(4000)  NULL,
operateitem varchar (10) NULL,
operateuserid int NOT NULL,
operatedate char (10)  NOT NULL,
operatetime char (8)  NOT NULL,
clientaddress char (15)  NULL,
istemplate int NULL,
operatesmalltype int NULL,
operateusertype int NULL
)
/
create sequence HrmSysMaintenanceLog_id
minvalue 1
maxvalue 999999999999999999999999999
start with 134545
increment by 1
cache 20
/
CREATE OR REPLACE TRIGGER HrmSysMaintenanceLog_Trigger before insert on HrmSysMaintenanceLog for each row begin select HrmSysMaintenanceLog_id.nextval into :new.id from dual;end;
/