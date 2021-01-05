CREATE TABLE workflow_reqbrowextrainfo (
	id integer,
	requestid integer,
	fieldid VARCHAR2(255),
	type integer,
	typeid integer,
	ids LONG,
	md5 VARCHAR2(255)
)
/
create sequence workflow_reqbrowextrainfo_sq
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_reqbrowextrainfo_Tri
before insert on workflow_reqbrowextrainfo
for each row
begin
select workflow_reqbrowextrainfo_sq.nextval into :new.id from dual;
end;
/