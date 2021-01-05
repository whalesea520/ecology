
alter table workflow_nodelink add startDirection integer
/
alter table workflow_nodelink add endDirection integer
/
alter table workflow_nodelink add points VARCHAR(255)
/










CREATE TABLE workflow_groupinfo
(
	id int,
	workflowid int,
	groupname varchar2(255),
	direction int,
	x number(15,2),
	y number(15,2),
	width number(15,2),
	height number(15,2)
)
/
CREATE SEQUENCE workflow_groupinfo_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger workflow_groupinfo_Tri
  before insert on workflow_groupinfo
  for each row
begin
  select workflow_groupinfo_seq.nextval into :new.id from dual;
end;
/
