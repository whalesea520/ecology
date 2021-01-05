CREATE OR REPLACE TRIGGER TRI_U_WORKFLOW_CREATELIST
AFTER UPDATE ON HRMRESOURCE REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
Declare
workflowid_1 integer;
type_1 integer;
objid integer;
level_n integer;
level2_n integer;
userid integer;
resourceid_1 integer;
loginid_1 varchar2(60);
olddepartmentid_1 integer;
oldsubcompanyid1_1 integer;
subcompanyid1_1 integer;
departmentid_1 integer;
oldseclevel_1     integer;
seclevel_1     integer;
signorder_1  integer;
countdelete   integer;
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
if departmentid_1 is not null and subcompanyid1_1 is not null  and ( subcompanyid1_1 <>oldsubcompanyid1_1 or departmentid_1 <>olddepartmentid_1 or  seclevel_1 <> oldseclevel_1 )
  then
  delete from workflow_createrlist where userid = resourceid_1 and usertype = 0  ;

      for detail_cursor IN (select workflowid,type,objid,level_n,level2_n,signorder from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid and signorder=2)
          loop
          workflowid_1 := detail_cursor.workflowid;
          type_1 := detail_cursor.type;
          objid := detail_cursor.objid;
          level_n := detail_cursor.level_n;
          level2_n := detail_cursor.level2_n;
        signorder_1 := detail_cursor.signorder;
          if type_1=1 then                    
                delete from workflow_createrlist where workflowid=workflowid_1 and userid=resourceid_1 and usertype=0;
            insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,resourceid_1,0) ;
          end if;
          if type_1=2 then  
                  delete from workflow_createrlist where workflowid=workflowid_1 and userid=resourceid_1 and usertype=0;
                    insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,resourceid_1,0) ;
          end if;
          if type_1=30 then
            delete from workflow_createrlist where workflowid=workflowid_1 and userid=resourceid_1 and usertype=0;
            insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,resourceid_1,0) ;    
          end if;   
       end loop;

     for all_cursor IN (select workflowid,type,objid,level_n,level2_n,signorder from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid)
          loop
          workflowid_1 := all_cursor.workflowid;
          type_1 := all_cursor.type;
          objid := all_cursor.objid;
          level_n := all_cursor.level_n;
          level2_n := all_cursor.level2_n;
        signorder_1 := all_cursor.signorder;
          if type_1=1 then
              if departmentid_1 is not null and departmentid_1 = objid and seclevel_1 >= level_n and seclevel_1 <= level2_n then
                  if  signorder_1 is not null and signorder_1 = 2  then                                 
                delete from workflow_createrlist where workflowid=workflowid_1 and userid=resourceid_1 and usertype=0;
                else  
                delete from workflow_createrlist where workflowid=workflowid_1 and userid=resourceid_1 and usertype=0;
                    insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,resourceid_1,0) ;                    
                  end if ;
                      end if;
          end if;
          if type_1=2 then
              SELECT count(resourceid) into userid FROM HrmRoleMembers where roleid = objid and rolelevel >= level_n and resourceid = resourceid_1 ;
                if userid > 0 then
                if  signorder_1 is not null and signorder_1 = 2 then                    
                      delete from workflow_createrlist where workflowid=workflowid_1 and userid=resourceid_1 and usertype=0;
                  else 
                    delete from workflow_createrlist where workflowid=workflowid_1 and userid=resourceid_1 and usertype=0;
                  insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,resourceid_1,0) ;                    
                  end if ;
                end if;
          end if;
          if type_1=3 then
                  if resourceid_1 = objid
                      then
                      insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,resourceid_1,0) ;
                  end if ;
          end if;
          if type_1=30 then
              if subcompanyid1_1 = objid and seclevel_1 >= level_n and seclevel_1 <= level2_n then
                  if  signorder_1 is not null and signorder_1 = 2 then
                delete from workflow_createrlist where workflowid=workflowid_1 and userid=resourceid_1 and usertype=0;
                else 
                    delete from workflow_createrlist where workflowid=workflowid_1 and userid=resourceid_1 and usertype=0;
                  insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,resourceid_1,0) ;                                        
                  end if ;
              end if;
          end if;   
       end loop;
      end if ;
 end ;
/
CREATE OR REPLACE TRIGGER TRI_U_WORKFLOW_CREATELIST_I
AFTER insert ON HRMRESOURCE REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
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
oldseclevel_1     integer;
seclevel_1     integer;
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
if subcompanyid1_1 is not null and departmentid_1 is not null
  then
  delete from workflow_createrlist where userid = resourceid_1 and usertype = 0  ;
        
    for detail_cursor IN (select workflowid,type,objid,level_n,level2_n,signorder from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid and signorder=2)
          loop
          workflowid_1 := detail_cursor.workflowid;
          type_1 := detail_cursor.type;
          objid := detail_cursor.objid;
          level_n := detail_cursor.level_n;
          level2_n := detail_cursor.level2_n;
        signorder_1 := detail_cursor.signorder;
          if type_1=1 then 
                delete from workflow_createrlist where workflowid=workflowid_1 and userid=resourceid_1 and usertype=0;
            insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,resourceid_1,0) ;
          end if;
          if type_1=2 then  
                  delete from workflow_createrlist where workflowid=workflowid_1 and userid=resourceid_1 and usertype=0;
                    insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,resourceid_1,0) ;
          end if;
          if type_1=30 then
            delete from workflow_createrlist where workflowid=workflowid_1 and userid=resourceid_1 and usertype=0;
            insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,resourceid_1,0) ;    
          end if;   
       end loop;

      for all_cursor IN (select workflowid,type,objid,level_n,level2_n,signorder from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid)
          loop
          workflowid_1 := all_cursor.workflowid;
          type_1 := all_cursor.type;
          objid := all_cursor.objid;
          level_n := all_cursor.level_n;
          level2_n := all_cursor.level2_n;
        signorder_1 := all_cursor.signorder;
          if type_1=1 then
               if departmentid_1 is not null and departmentid_1 = objid and seclevel_1 >= level_n and seclevel_1 <= level2_n then                        
                  if  signorder_1 is not null and signorder_1 = 2  then                     
                    delete from workflow_createrlist where workflowid=workflowid_1 and userid=resourceid_1 and usertype=0;
                else     
                    delete from workflow_createrlist where workflowid=workflowid_1 and userid=resourceid_1 and usertype=0;
                    insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,resourceid_1,0) ;                    
                  end if ;
                       end if;
          end if;
          if type_1=2 then
              SELECT count(resourceid) into userid FROM HrmRoleMembers where roleid = objid and rolelevel >= level_n and resourceid = resourceid_1 ;
              if userid > 0 then
                if  signorder_1 is not null and signorder_1 = 2 then                    
                      delete from workflow_createrlist where workflowid=workflowid_1 and userid=resourceid_1 and usertype=0;
                  else
                      delete from workflow_createrlist where workflowid=workflowid_1 and userid=resourceid_1 and usertype=0;
                  insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,resourceid_1,0) ;                    
                  end if ;
                  end if;
          end if;
          if type_1=3 then
                  if resourceid_1 = objid
                      then
                      insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,resourceid_1,0) ;
                  end if ;
          end if;
          if type_1=30 then
               if subcompanyid1_1 = objid and seclevel_1 >= level_n and seclevel_1 <= level2_n then
                  if  signorder_1 is not null and signorder_1 = 2 then
                delete from workflow_createrlist where workflowid=workflowid_1 and userid=resourceid_1 and usertype=0;
                else
                    delete from workflow_createrlist where workflowid=workflowid_1 and userid=resourceid_1 and usertype=0;
                  insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,resourceid_1,0) ;                                        
                  end if ;
                 end if;
          end if;   
       end loop;
      end if ;
 end ;
/
