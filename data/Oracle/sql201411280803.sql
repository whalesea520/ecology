CREATE TABLE HrmUserGroupStatictics(
id int  NOT NULL PRIMARY KEY ,
userid int NULL,
groupid varchar (100),
clickCnt int NULL)
/
create sequence hrm_groupS_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
CREATE OR REPLACE TRIGGER hrm_groupS_Trigger before insert on HrmUserGroupStatictics for each row begin select hrm_groupS_id.nextval into :new.id from dual; end;
/