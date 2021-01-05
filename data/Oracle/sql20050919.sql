ALTER TABLE workflow_createrlist drop column isAgenter 
/
drop trigger TRI_U_WORKFLOW_CREATELIST
/
CREATE OR REPLACE TRIGGER TRI_U_WORKFLOW_CREATELIST
AFTER UPDATE ON HRMRESOURCE REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
Declare 
workflowid integer;
type_1 integer;
objid integer;
level_n integer;
level2_n integer;
userid integer;
resourceid_1 integer;
loginid_1 varchar2(60);
subcompanyid1_1 integer;
olddepartmentid_1 integer;
departmentid_1 integer;
oldseclevel_1	 integer;
seclevel_1	 integer;
countdelete   integer;
begin  
olddepartmentid_1 := :old.departmentid;
oldseclevel_1 := :old.seclevel;
resourceid_1 := :new.id;
loginid_1 := :new.loginid;
departmentid_1 := :new.departmentid;
seclevel_1 := :new.seclevel;
if(departmentid_1 is not null) 
	then
	select subcompanyid1 into subcompanyid1_1 from HrmDepartment where id = departmentid_1 ;
end if;   /* 如果部门和安全级别信息被修改(在新建的时候这两个信息肯定被修改) */
if departmentid_1 is not null and olddepartmentid_1 is not null and ( departmentid_1 <>olddepartmentid_1 or  seclevel_1 <> oldseclevel_1 )
  then  
  delete from workflow_createrlist where userid = resourceid_1 and usertype = 0  ;
  if loginid_1 is not null  
  	then
  	for all_cursor IN (select workflowid,type,objid,level_n,level2_n from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid)
  		loop 
  		workflowid := all_cursor.workflowid;
  		type_1 := all_cursor.type;
  		objid := all_cursor.objid;
  		level_n := all_cursor.level_n;
  		level2_n := all_cursor.level2_n;
  		if type_1=1 
  			then
  				if departmentid_1 is not null and departmentid_1 = objid and seclevel_1 >= level_n and seclevel_1 <= level2_n 
  					then
  					insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,resourceid_1,0) ;
  			 end if ;
  		end if; 
  		if type_1=2 
  			then 
  				SELECT count(resourceid) into userid FROM HrmRoleMembers where roleid = objid and rolelevel >= level_n and resourceid = resourceid_1 ;
  			  if userid > 0  
  			  	then 
  			  	insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,resourceid_1,0) ;
  			  end if ;
  		end if; 
  		if type_1=3 
  			then 
  				if resourceid_1 = objid 
  					then 
  					insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,resourceid_1,0) ;
  				end if ; 
  		end if; 
  		if type_1=30 
  			then 
  				if subcompanyid1_1 = objid and seclevel_1 >= level_n and seclevel_1 <= level2_n 
  					then 
  					insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid,resourceid_1,0) ;
  				end if ;
  		 end if; 
  	 end loop;
  	end if ; 
  end if; 
 end ;
/
drop trigger Tri_URole_workflow_createlist
/

CREATE or REPLACE TRIGGER Tri_URole_workflow_createlist
after insert or update or delete ON HrmRoleMembers
for each row
Declare 
    workflowid_1 integer ;
	type_1 integer ;
 	objid_1 integer ;
	level_n integer ;
    level2_n integer ;
	userid_1 integer ;
begin
    delete from workflow_createrlist where userid <> -1 and userid <> -2 and usertype = 0  ;
    for tmp_cursor in ( select workflowid,type,objid,level_n,level2_n from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid=t2.nodeid and t2.id = t3.groupid )
    loop
        workflowid_1 := tmp_cursor.workflowid ;
        type_1 := tmp_cursor.type ;
        objid_1 := tmp_cursor.objid ;
        level_n := tmp_cursor.level_n ;
        level2_n := tmp_cursor.level2_n ;
        
        if type_1 = 1 then
            for tmp_cursor2 in ( select id from HrmResource where departmentid = objid_1 and seclevel >= level_n and seclevel <= level2_n ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,0) ;
            end loop ;
        end if ;
        
        if type_1 = 2 then
            for tmp_cursor2 in ( SELECT resourceid FROM HrmRoleMembers_Tri where roleid =  objid_1 and rolelevel >=level_n ) 
            loop 
                userid_1 := tmp_cursor2.resourceid ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,0) ;
            end loop ;
        end if ;
        
        if type_1 = 3 then
            insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,objid_1,0);
        end if ;
        
	    if type_1 = 30 then
            for tmp_cursor2 in ( select id from HrmResource where subcompanyid1 = objid_1 and seclevel >= level_n and seclevel <= level2_n ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,0) ;
            end loop ;
        end if ;
    end loop ;
end ;
/

CREATE OR REPLACE PROCEDURE workflow_createlist_select
(userid_1 INTEGER,
usertype_1 INTEGER,
flag OUT INTEGER, msg OUT VARCHAR2,
thecursor IN OUT cursor_define.weavercursor)
AS
BEGIN
   OPEN thecursor FOR SELECT DISTINCT a.workflowid 
   FROM workflow_createrlist a 
   WHERE a.userid = userid_1 
   AND a.usertype = usertype_1 ;
END;
/

CREATE OR REPLACE PROCEDURE workflow_createrlist_Insert 
(workflowid_1  integer,
 userid_2  integer,
 usertype_3    integer,
 usertype_4    integer,        /* 当为所有人和所有客户的时候，为最大安全级别，否则为0 */
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
INSERT INTO workflow_createrlist 
(   workflowid,
    userid,
    usertype,
    usertype2)
 VALUES 
(   workflowid_1,
    userid_2,
    usertype_3,
    usertype_4 );
end;
/