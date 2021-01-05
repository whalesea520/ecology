alter table mode_workflowtomodeset add (maintableopttype varchar2(1),maintableupdatecondition varchar2(256))
/
create table mode_workflowtomodesetopt(
	id int not null,
	mainid int,
	detailtablename varchar2(256),
	opttype varchar2(1),
	updatecondition varchar2(256)
)
/
create sequence mode_workflowtomodesetopt_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_workflowtomodesetopt_Tri
before insert on mode_workflowtomodesetopt
for each row
begin
select mode_workflowtomodesetopt_id.nextval into :new.id from dual;
end;
/