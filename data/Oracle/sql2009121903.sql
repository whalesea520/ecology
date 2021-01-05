CREATE TABLE Workflow_RequestSign (
	id integer  not null,
	requestId integer null ,
	nodeId integer null ,
	userId integer null ,
	loginType integer null ,
	signNum integer null ,
	signDate char(10) null ,
	signTime char(8) null
)
/
create sequence Workflow_RequestSign_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Workflow_RequestSign_Tri
before insert on Workflow_RequestSign
for each row
begin
select Workflow_RequestSign_id.nextval into :new.id from dual;
end;
/
