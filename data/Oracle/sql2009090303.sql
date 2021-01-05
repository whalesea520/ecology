drop trigger Tri_URole_workflow_createlist
/
create or replace procedure URole_workflow_createlist (roleid_1 integer, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) as 
 workflowid_1 integer ; type_1 integer ; objid_1 integer ; level_n integer ; level2_n integer ; userid_1 integer ; 
begin 
delete from workflow_createrlist  where  userid>-1 and workflowid in (select workflowid from workflow_groupdetail,workflow_nodegroup a ,workflow_flownode b  where type=2   and objid=roleid_1 and a.id=groupid  and a.nodeid=b.nodeid and b.nodetype=0) ; 
for tmp_cursor in
 ( select workflowid,type,objid,level_n,level2_n from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 
 where t1.nodetype='0' and t1.nodeid=t2.nodeid and t2.id = t3.groupid and workflowid in  (select workflowid from workflow_groupdetail,workflow_nodegroup a ,workflow_flownode b  where type=2 and  objid=roleid_1 and a.id=groupid  and a.nodeid=b.nodeid and b.nodetype=0) ) loop
workflowid_1 := tmp_cursor.workflowid ; 
type_1 := tmp_cursor.type ;
  objid_1 := tmp_cursor.objid ;
  level_n := tmp_cursor.level_n ; 
  level2_n := tmp_cursor.level2_n ;  
    
if type_1 = 1 then 
for tmp_cursor2 in ( select id from HrmResource where departmentid = objid_1 and seclevel >= level_n and seclevel <= level2_n ) loop userid_1 := tmp_cursor2.id ; 
insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,0) ; 
end loop ; 
end if ;  
if type_1 = 2 then 
for tmp_cursor2 in ( SELECT resourceid FROM HrmRoleMembers_Tri where roleid =  objid_1 and rolelevel >=level_n ) loop userid_1 := tmp_cursor2.resourceid ;
insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,0) ; 
end loop ; 
end if ;  
if type_1 = 3 then 
insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,objid_1,0); 
end if ; 
if type_1 = 30 then 
for tmp_cursor2 in ( select id from HrmResource where subcompanyid1 = objid_1 and seclevel >= level_n and seclevel <= level2_n ) loop
userid_1 := tmp_cursor2.id ;
insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,0) ; 
end loop ; 
end if ;
end loop ; 
end ;
/