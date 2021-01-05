CREATE TABLE mode_batchimp_log (
	id int,
	modeid int,
	operatetype int,
	ipaddress varchar2(50),
	operator int,
	optdatetime varchar2(50),
	addrow int,
	updaterow int,
	delrow int,
	adddetailrow int,
	deldetailrow int
)
/
create sequence mode_batchimp_log_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_batchimp_log_Tri
before insert on mode_batchimp_log
for each row
begin
select mode_batchimp_log_id.nextval into :new.id from dual;
end;
/