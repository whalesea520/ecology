create table workflowtomodelog
(
  id INTEGER primary key,
  typename varchar2(32),
  modeid INTEGER,
  billid INTEGER,
  mainid INTEGER,
  workflowid INTEGER
)
/
Create Sequence workflowtomodelog_set_Sequence Start With 1 Increment By 1 Nocycle Nocache
/
create or replace trigger workflowtomodelog_id_trigger
before insert
on workflowtomodelog
for each row
declare
newid number(18,0);
begin
select workflowtomodelog_set_Sequence.nextval into newid from dual;
:new.id:=newid;
end;
/
alter table mode_workflowtomodeset add formtype varchar(30)
/
