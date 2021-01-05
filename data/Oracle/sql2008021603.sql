CREATE TABLE workflow_urgerdetail(
    id integer PRIMARY KEY NOT NULL,
    workflowid integer,
    utype integer,
    objid integer,
    level_n integer,
    level2_n integer,
    conditions varchar2(1000),
    conditioncn varchar2(1000)
)
/

CREATE SEQUENCE urgerdetail_Id
    start with 1
    increment by 1
    nomaxvalue
    nocycle 
/

CREATE OR REPLACE TRIGGER urgerdetail_Id_Trigger
	before insert on workflow_urgerdetail
	for each row
	begin
	select urgerdetail_Id.nextval into :new.id from dual;
	end ;
/

alter table workflow_monitor_bound add isview integer default(0)
/
