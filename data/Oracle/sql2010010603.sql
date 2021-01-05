create table workflow_createplan(
	id integer not null,
	wfid integer null,
	nodeid integer null,
	changetime integer null,
	plantypeid integer null,
	creatertype integer null,
	wffieldid integer null,
	remindType integer null,
	remindBeforeStart integer null,
	remindDateBeforeStart integer null,
	remindTimeBeforeStart integer null,
	remindBeforeEnd integer null,
	remindDateBeforeEnd integer null,
	remindTimeBeforeEnd integer null
)
/
create sequence workflow_createplan_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_createplan_id_Tri
before insert on workflow_createplan
for each row
begin
select workflow_createplan_id.nextval into :new.id from dual;
end;
/

create table workflow_createplangroup(
	id integer not null,
	createplanid integer null,
	groupid integer null,
	isused integer null
)
/
create sequence workflow_createplangroup_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_cpgroup_id_Tri
before insert on workflow_createplangroup
for each row
begin
select workflow_createplangroup_id.nextval into :new.id from dual;
end;
/

create table workflow_createplandetail(
	id integer not null,
	createplanid integer null,
	wffieldid integer null,
	isdetail integer null,
	planfieldname varchar(50) null,
	groupid integer null
)
/
create sequence workflow_createplandetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_cpdetail_id_Tri
before insert on workflow_createplandetail
for each row
begin
select workflow_createplandetail_id.nextval into :new.id from dual;
end;
/
