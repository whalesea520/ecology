create table SAPData_Auth_setting(
	id integer not null,
	name varchar2(100),
	browserids varchar2(1000),
	resourcetype char(1),
	resourceids varchar2(1000),
	roleids varchar2(1000),
	wfids varchar2(1000)
)
/

create sequence SAPData_Auth_setting_Id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger SAPData_Auth_setting_Trigger
before insert on SAPData_Auth_setting
for each row
begin
select SAPData_Auth_setting_Id.nextval into :new.id from dual;
end;
/

create table SAPData_Auth_setting_detail(
	settingid integer not null,
	filtertype char(1),
	browserid varchar2(60),
	sapcode varchar2(200)
)
/