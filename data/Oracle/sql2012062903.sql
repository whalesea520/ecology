create table ShareInnerWfCreate (
	id integer,
	gid integer not null,
	workflowid integer not null,
	type integer not null,
	content integer,
	min_seclevel integer,
	max_seclevel integer,
	isBelong integer,
	usertype integer
)
/
create sequence SEQ_ShareInnerWfCreate minvalue 1 nomaxvalue start with 1 increment by 1 nocycle nocache
/
CREATE OR REPLACE TRIGGER Tri_U_ShareInnerWfCreate
BEFORE INSERT ON ShareInnerWfCreate FOR EACH ROW WHEN (new.id is null) 
begin
	select SEQ_ShareInnerWfCreate.nextval into:new.id from dual; 
end;
/ 
drop table workflow_createrlist
/
drop TRIGGER Tri_U_workflow_createlist
/
drop TRIGGER Tri_U_workflow_createlist_I
/
drop trigger Tri_UCRM_workflow_createlist
/
drop PROCEDURE URole_workflow_createlist
/
drop PROCEDURE workflow_createrlist_Insert
/
drop PROCEDURE Workflow_createlist_select
/
drop PROCEDURE Workflow_select_foragent
/
drop PROCEDURE workflow_createrlist_Delete
/
CREATE OR REPLACE PROCEDURE ShareForWorkflow 
AS
	workflowid integer;
	groupid integer;
	gid integer;
	type_1 integer;
	objid integer;
	level_n integer;
	level2_n integer;
	signorder integer;
	groupid_old integer;
begin  
	delete from ShareInnerWfCreate;
	
	for all_cursor IN (select t1.workflowid as workflowid,t3.type as type, t3.objid as objid,t3.level_n as level_n, t3.level2_n as level2_n,t3.signorder as signorder, t2.id as groupid, t3.id from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid)
  	loop 
		workflowid := all_cursor.workflowid;
		type_1 := all_cursor.type;
		objid := all_cursor.objid;
		level_n := all_cursor.level_n;
		level2_n := all_cursor.level2_n;
		signorder := 0;
		IF (all_cursor.signorder <> '') THEN
			signorder := all_cursor.signorder;
		END IF;
		groupid := all_cursor.groupid;
		gid := all_cursor.id;
  		
  		if (type_1=1 or type_1=3 or type_1=4 or type_1=30) then
			insert into ShareInnerWfCreate(gid, workflowid, type, content, min_seclevel, max_seclevel, isBelong, usertype) 
			values(gid, workflowid, type_1, objid, level_n, level2_n, signorder, 0);
		end if;
	    if type_1=2 then 
			objid := objid || '' || level_n;
			insert into ShareInnerWfCreate(gid, workflowid, type, content, min_seclevel, max_seclevel, isBelong, usertype) 
			values(gid, workflowid, type_1, objid, -1, -1, signorder, 0);
	    end if;
	    if (type_1=20 or type_1=21 or type_1=22 or type_1=25 ) then
			insert into ShareInnerWfCreate(gid, workflowid, type, content, min_seclevel, max_seclevel, isBelong, usertype) 
			values(gid, workflowid, type_1, objid, level_n, level2_n, signorder, 1);
	    end if;
	end loop;
	COMMIT;
 end;
/
call ShareForWorkflow()
/
CREATE OR REPLACE TRIGGER Tri_U_Workflow_CreateShare
    after insert or update or delete
    on workflow_groupdetail 
    for each row
Declare
	workflowid integer;
	groupid integer;
	gid integer;
	type_1 integer;
	objid integer;
	level_n integer;
	level2_n integer;
	signorder  integer;
	gid_old integer;
	groupid_old INTEGER;
	count_1 integer;
begin
	groupid := :new.groupid;
	gid := :new.id;
	type_1 := :new.type;
	objid := :new.objid;
	level_n := :new.level_n;
	level2_n := :new.level2_n;
	signorder := 0;
	IF (:new.signorder <> '') THEN
		signorder := :new.signorder;
	END IF;
	gid_old := :old.id;
	groupid_old := :old.groupid;
	
	IF (updating or deleting) THEN
		if (gid_old IS NOT NULL) then 
			delete from ShareInnerWfCreate where gid = gid_old;
		end IF;
	END IF;
	IF (inserting OR updating ) THEN
		select workflowid into workflowid from workflow_flownode t1,workflow_nodegroup t2 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = groupid;
		
		IF (workflowid IS NOT NULL AND workflowid <> 0) THEN 
			if (type_1=1 or type_1=3 or type_1=4 or type_1=30) then
				insert into ShareInnerWfCreate(gid, workflowid, type, content, min_seclevel, max_seclevel, isBelong, usertype) 
				values(gid, workflowid, type_1, objid, level_n, level2_n, signorder, 0);
			end if;
			if (type_1=2) then
				objid := objid || '' || level_n;
				insert into ShareInnerWfCreate(gid, workflowid, type, content, min_seclevel, max_seclevel, isBelong, usertype) 
				values(gid, workflowid, type_1, objid, -1, -1, signorder, 0);
			end if;
			if (type_1=20 or type_1=21 or type_1=22 or type_1=25 ) then
				insert into ShareInnerWfCreate(gid, workflowid, type, content, min_seclevel, max_seclevel, isBelong, usertype) 
				values(gid, workflowid, type_1, objid, level_n, level2_n, signorder, 1);
			end if;
		END IF;
	END IF;
	exception
	    when NO_DATA_FOUND then
	    	workflowid := 0;
end;
/