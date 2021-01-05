CREATE TABLE WorkFlow_UserRef(
	keyid int NOT NULL,
	name varchar(50) NULL,
	pwd varchar(50) NULL,
	userids varchar(500) NULL,
	usertype int NULL
)
/
create sequence WORKFLOW_USERREF_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create or replace trigger workflow_userref_Trigger before insert on workflow_userref for each row 
begin select workflow_userref_id.nextval into :new.keyid from dual; end;
/