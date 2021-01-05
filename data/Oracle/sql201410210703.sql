DELETE FROM HrmListValidate WHERE tab_type = 2
/
CREATE TABLE HrmResourceBaseTab
(
id int NOT NULL PRIMARY KEY,
groupname varchar (60) NULL,
grouplabel int NULL,
dsporder decimal (10, 2) NULL,
isopen char (1) NULL,
ismand char (1) NULL,
isused char (1) NULL,
issystem char (1) NULL,
linkurl varchar (2000) NULL
)
/
create sequence HrmResourceBaseTab_id
minvalue 1
maxvalue 999999999999999999999999999
start with 134545
increment by 1
cache 20
/
CREATE OR REPLACE TRIGGER HrmResourceBaseTab_Trigger before insert on HrmResourceBaseTab for each row begin select HrmResourceBaseTab_id.nextval into :new.id from dual;end;
/