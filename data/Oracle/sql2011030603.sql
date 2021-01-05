CREATE TABLE workflow_mgms (
        id integer NOT NULL ,      
        requestId integer  NULL ,             
        userid integer NULL ,                     
        receivedate varchar2(10) NULL,           
        receivetime varchar2(10) NULL,             
        sendTime varchar2(20)  NULL,              
	transactionid varchar2(250) NULL,
	previoustrsid varchar2(250) NULL,
	status varchar2(1) NULL,
	processtrsid varchar2(250) NULL
)
/
create sequence workflow_mgms_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_mgms_Tri
before insert on workflow_mgms
for each row
begin
select workflow_mgms_id.nextval into :new.id from dual;
end;
/

CREATE TABLE workflow_mgmsworkflows (
        workflowid integer NOT NULL
)
/

CREATE TABLE workflow_mgmsusers (
        userid integer NOT NULL
)
/
