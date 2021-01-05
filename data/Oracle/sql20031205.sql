CREATE or REPLACE TRIGGER Tri_URole_workflow_createlist
after insert or update or delete ON HrmRoleMembers
for each row
Declare 
    workflowid_1 integer ;
	type_1 integer ;
 	objid_1 integer ;
	level_1 integer ;
	userid_1 integer ;
begin
    delete from workflow_createrlist ;
    for tmp_cursor in ( select workflowid,type,objid,level from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid=t2.nodeid and t2.id = t3.groupid )
    loop
        workflowid_1 := tmp_cursor.workflowid ;
        type_1 := tmp_cursor.type ;
        objid_1 := tmp_cursor.objid ;
        level_1 := tmp_cursor.level ;
        
        if type_1 = 1 then
            for tmp_cursor2 in ( select id from HrmResource where departmentid = objid_1 and seclevel >= level_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'0') ;
            end loop ;
        end if ;
        
        if type_1 = 2 then
            for tmp_cursor2 in ( SELECT resourceid as id FROM HrmRoleMembers_Tri where roleid =  objid_1 and rolelevel >=level_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'0') ;
            end loop ;
        end if ;
        
        if type_1 = 3 then
            insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,objid_1,'0');
        end if ;
        
        if type_1 = 4 then
            insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,-1,level_1);
        end if ;
        
        if type_1 = 20 then
            for tmp_cursor2 in ( select id  from CRM_CustomerInfo where  seclevel >= level_1 and type = objid_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'1') ;
            end loop ;
        end if ;
        
        if type_1 = 21 then
            for tmp_cursor2 in ( select id  from CRM_CustomerInfo where  seclevel >= level_1 and status = objid_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'1') ;
            end loop ;
        end if ;
        
        if type_1 = 22 then
            for tmp_cursor2 in ( select id  from CRM_CustomerInfo where  seclevel >= level_1 and department = objid_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'1') ;
            end loop ;
        end if ;
        
        if type_1 = 25 then
            insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,-2,level_1);
        end if ;

	if type_1 = 30 then
            for tmp_cursor2 in ( select id from HrmResource where subcompanyid1 = objid_1 and seclevel >= level_1 ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,'0') ;
            end loop ;
        end if ;


    end loop ;
end ;
/




CREATE or REPLACE TRIGGER Tri_UCRM_workflow_createlist
after update or delete ON CRM_CustomerInfo
for each row
Declare 
    workflowid_1 integer ;
	type_1 integer ;
 	objid_1 integer ;
	level_1 integer ;
	userid_1 integer ;

    crmid_1 integer;            /* 修改或者删除的crm */
    oldseclevel_1	 integer;   /* 修改前的安全级别 */
    seclevel_1	 integer;       /* 修改后的安全级别 */
    crmtype_1 integer;          /* 修改前的用户类型 */
    oldcrmtype_1 integer;       /* 修改后的用户类型 */
    PortalStatus_1 integer;     /* 修改前的门户状态 */
    oldPortalStatus_1 integer;  /* 修改后的门户状态 */
    department_1  integer ;     /* 修改前的部门状态 */
    olddepartment_1  integer ;     /* 修改后的部门状态 */
    status_1  integer ;             /* 修改前的状态 */
    oldstatus_1  integer ;     /* 修改后的状态 */
    
begin
        
/* 从刚修改的行中查找修改的crmid 等 */

    crmid_1 := :old.id ;
    oldseclevel_1 := :old.seclevel ; 
    oldcrmtype_1 := :old.type ;
    oldPortalStatus_1 := :old.PortalStatus ;
    olddepartment_1 := :old.department ;
    oldstatus_1 := :old.status ;
    seclevel_1 := :new.seclevel ; 
    crmtype_1 := :new.type ;
    PortalStatus_1 := :new.PortalStatus ;
    department_1 := :new.department ;
    status_1 := :new.status ;

    if ( oldseclevel_1 <> seclevel_1 or  oldPortalStatus_1 <> PortalStatus_1 or oldcrmtype_1 <> crmtype_1 or olddepartment_1 <> department_1 or oldstatus_1 <> status_1 )  then
    
        delete from workflow_createrlist where userid = crmid_1 and usertype = '1' ;

        if ( PortalStatus_1 = 2 ) then 
            for tmp_cursor in ( select workflowid,type,objid,level from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid=t2.nodeid and t2.id = t3.groupid )
            loop
                workflowid_1 := tmp_cursor.workflowid ;
                type_1 := tmp_cursor.type ;
                objid_1 := tmp_cursor.objid ;
                level_1 := tmp_cursor.level ;

              
                if type_1 = 20 then
                    if( crmtype_1 = objid_1 and seclevel_1 >= level_1 ) then
                        insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,crmid_1,'1') ;
                    end if ;
                end if ;
                
                if type_1 = 21 then
                    if ( seclevel_1 >= level_1 and status_1 = objid_1 ) then
                        insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,crmid_1,'1') ;
                    end if ;
                end if ;
                
                if type_1 = 22 then
                    if ( seclevel_1 >= level_1 and department_1 = objid_1 ) then
                        insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,crmid_1,'1') ;
                    end if ;
                end if ;
                
            end loop ;

        end if ;
    end if ;
end ;
/

