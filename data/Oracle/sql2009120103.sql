alter table DocReceiveUnit add subcompanyid integer
/

update DocReceiveUnit set subcompanyid=(select dftsubcomid from SystemSet)
/

alter table workflow_selectitem add isAccordToSubCom char(1) default '0'
/
update workflow_selectitem set isAccordToSubCom='0'
/

alter table Workflow_DocProp add objId integer default -1
/
update Workflow_DocProp set objId=-1
/

alter table Workflow_DocProp add objType char(1) default '0'
/
update Workflow_DocProp set objType='0'
/

CREATE TABLE Workflow_SelectitemObj (
	id integer  not null,
	fieldId integer null ,
	isBill integer null ,
	selectValue integer null ,
	objId integer null ,
	objType char(1) null ,
	docPath varchar2(400) null ,
	docCategory varchar2(400) null 
)
/
create sequence Workflow_SelectitemObj_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Workflow_SelectitemObj_Tri
before insert on Workflow_SelectitemObj
for each row
begin
select Workflow_SelectitemObj_id.nextval into :new.id from dual;
end;
/

CREATE OR REPLACE TRIGGER TRI_U_WORKFLOW_CREATELIST
AFTER UPDATE or insert ON HRMRESOURCE REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
Declare
workflowid_1 integer;
type_1 integer;
objid integer;
level_n integer;
level2_n integer;
userid integer;
resourceid_1 integer;
loginid_1 varchar2(60);
subcompanyid1_1 integer;
oldsubcompanyid1_1 integer;
olddepartmentid_1 integer;
departmentid_1 integer;
oldseclevel_1	 integer;
seclevel_1	 integer;
countdelete   integer;
signorder_1  integer;
begin
oldsubcompanyid1_1 := :old.subcompanyid1;
olddepartmentid_1 := :old.departmentid;
oldseclevel_1 := :old.seclevel;
resourceid_1 := :new.id;
loginid_1 := :new.loginid;
subcompanyid1_1 := :new.subcompanyid1;
departmentid_1 := :new.departmentid;
seclevel_1 := :new.seclevel;
if departmentid_1 is null   then
    departmentid_1 := 0;
    end if;
if subcompanyid1_1 is null   then
    subcompanyid1_1 := 0;
    end if;
if olddepartmentid_1 is null   then
    olddepartmentid_1 := 0;
    end if;
if oldsubcompanyid1_1 is null   then
    oldsubcompanyid1_1 := 0;
    end if;
/* 如果部门和安全级别信息被修改(在新建的时候这两个信息肯定被修改) */
if subcompanyid1_1 is not null and oldsubcompanyid1_1 is not null and departmentid_1 is not null and olddepartmentid_1 is not null and ( subcompanyid1_1 <>oldsubcompanyid1_1 or departmentid_1 <>olddepartmentid_1 or  seclevel_1 <> oldseclevel_1 )
  then
  delete from workflow_createrlist where userid = resourceid_1 and usertype = 0  ;

  	for all_cursor IN (select workflowid,type,objid,level_n,level2_n,signorder from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid)
  		loop
  		workflowid_1 := all_cursor.workflowid;
  		type_1 := all_cursor.type;
  		objid := all_cursor.objid;
  		level_n := all_cursor.level_n;
  		level2_n := all_cursor.level2_n;
		signorder_1 := all_cursor.signorder;
  		if type_1=1
  			then
  				if departmentid_1 is not null and departmentid_1 = objid and seclevel_1 >= level_n and seclevel_1 <= level2_n
  					then
						if  signorder_1 is not null and signorder_1 = 2 then
							delete from workflow_createrlist where workflowid=workflowid_1 and userid=resourceid_1 and usertype=0;
						else
							insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,resourceid_1,0) ;
						end if;
  			 end if ;
  		end if;
  		if type_1=2
  			then
  				SELECT count(resourceid) into userid FROM HrmRoleMembers where roleid = objid and rolelevel >= level_n and resourceid = resourceid_1 ;
  			  if userid > 0
  			  	then
  			  		if  signorder_1 is not null and signorder_1 = 2 then
						delete from workflow_createrlist where workflowid=workflowid_1 and userid=resourceid_1 and usertype=0;
					else
  						insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,resourceid_1,0) ;
					end if;
  			  end if ;
  		end if;
  		if type_1=3
  			then
  				if resourceid_1 = objid
  					then
  					insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,resourceid_1,0) ;
  				end if ;
  		end if;
  		if type_1=30
  			then
  				if subcompanyid1_1 = objid and seclevel_1 >= level_n and seclevel_1 <= level2_n
				then
  					if  signorder_1 is not null and signorder_1 = 2 then
						delete from workflow_createrlist where workflowid=workflowid_1 and userid=resourceid_1 and usertype=0;
					else
  						insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,resourceid_1,0) ;
					end if;
  				end if ;
  		 end if;
  	 end loop;
  	end if ;

 end ;
/

create or replace procedure URole_workflow_createlist (roleid_1 integer, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) as 
 workflowid_1 integer ; type_1 integer ; objid_1 integer ; level_n integer ; level2_n integer ; userid_1 integer ; signorder_1  integer;
begin 
delete from workflow_createrlist  where  userid>-1 and workflowid in (select workflowid from workflow_groupdetail,workflow_nodegroup a ,workflow_flownode b  where type=2   and objid=roleid_1 and a.id=groupid  and a.nodeid=b.nodeid and b.nodetype=0) ; 
for tmp_cursor in
 ( select workflowid,type,objid,level_n,level2_n,signorder from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 
 where t1.nodetype='0' and t1.nodeid=t2.nodeid and t2.id = t3.groupid and workflowid in  (select workflowid from workflow_groupdetail,workflow_nodegroup a ,workflow_flownode b  where type=2 and  objid=roleid_1 and a.id=groupid  and a.nodeid=b.nodeid and b.nodetype=0) ) loop
workflowid_1 := tmp_cursor.workflowid ; 
type_1 := tmp_cursor.type ;
  objid_1 := tmp_cursor.objid ;
  level_n := tmp_cursor.level_n ; 
  level2_n := tmp_cursor.level2_n ;  
    signorder_1 := tmp_cursor.signorder;
if type_1 = 1 then 
	for tmp_cursor2 in ( select id from HrmResource where departmentid = objid_1 and seclevel >= level_n and seclevel <= level2_n ) loop userid_1 := tmp_cursor2.id ; 
		if  signorder_1 is not null and signorder_1 = 2 then
			delete from workflow_createrlist where workflowid=workflowid_1 and userid=userid_1 and usertype=0;
		else
			insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,0) ;
		end if;
	end loop ; 
end if ;  
if type_1 = 2 then 
for tmp_cursor2 in ( SELECT resourceid FROM HrmRoleMembers_Tri where roleid =  objid_1 and rolelevel >=level_n ) loop userid_1 := tmp_cursor2.resourceid ;
		if  signorder_1 is not null and signorder_1 = 2 then
			delete from workflow_createrlist where workflowid=workflowid_1 and userid=userid_1 and usertype=0;
		else
			insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,0) ;
		end if;
end loop ; 
end if ;  
if type_1 = 3 then 
insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,objid_1,0); 
end if ; 
if type_1 = 30 then 
for tmp_cursor2 in ( select id from HrmResource where subcompanyid1 = objid_1 and seclevel >= level_n and seclevel <= level2_n ) loop
userid_1 := tmp_cursor2.id ;
		if  signorder_1 is not null and signorder_1 = 2 then
			delete from workflow_createrlist where workflowid=workflowid_1 and userid=userid_1 and usertype=0;
		else
			insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,0) ;
		end if;
end loop ; 
end if ;
end loop ; 
end ;
/
