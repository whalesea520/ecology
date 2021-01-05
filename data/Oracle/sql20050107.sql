CREATE or REPLACE TRIGGER Tri_U_workflow_createlist 
after  update  ON  HrmResource
FOR each row
Declare workflowid_1 integer;
        type_1 integer;
        objid_1 integer;
        level_n_1 integer;
        level2_n_1 integer;
        userid_1 integer;
        resourceid_1 integer;
        loginid_1 varchar2(60);
        subcompanyid1_1 integer;
        olddepartmentid_1 integer;
        departmentid_1 integer;
        oldseclevel_1	 integer;
        seclevel_1	 integer;
        current_date_1 char(10);
        current_time_1 char(8);
        agenter_id_1 integer;
        begin_date_1 char(10);
        begin_time_1 char(8);
        end_date_1 char(10);
        end_time_1 char(8);
        isbeAgent_1 integer;

begin

olddepartmentid_1 := :old.departmentid;
oldseclevel_1 := :old.seclevel;
resourceid_1 := :new.id;
loginid_1 := :new.loginid;
departmentid_1 := :new.departmentid;
seclevel_1 := :new.seclevel;

select subcompanyid1 into subcompanyid1_1 from HrmDepartment where id = departmentid_1;
select subStr(to_char(sysdate,'hh24:mm:ss'),1,8) into current_time_1 from dual;
select subStr(to_char(sysdate,'yyyy-mm-dd'),1,10) into  current_date_1 from dual;

/* 如果部门和安全级别信息被修改(在新建的时候这两个信息肯定被修改) */
  

if ( departmentid_1 <>olddepartmentid_1 or  seclevel_1 <> oldseclevel_1 ) then  

    delete from workflow_createrlist where userid = resourceid_1 and usertype = 0 ;

    if (loginid_1 is not null) then

        for all_cursor IN (select workflowid,type,objid,level_n,level2_n from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid)
        loop
            workflowid_1 := all_cursor.workflowid;
            type_1 := all_cursor.type;
            objid_1 := all_cursor.objid;
            level_n_1 := all_cursor.level_n;
            level2_n_1 := all_cursor.level2_n;

            isbeAgent_1 :=0;
            for agent_cursor in (select agenterId ,beginDate ,beginTime ,endDate ,endTime from Workflow_Agent where workflowId=workflowid_1 and beagenterId=resourceid_1 and isCreateAgenter=1)
            loop
                agenter_id_1 := agent_cursor.agenterId;
                begin_date_1 := agent_cursor.beginDate;
                begin_time_1 := agent_cursor.beginTime;
                end_date_1 := agent_cursor.endDate;
                end_time_1 := agent_cursor.endTime;
                isbeAgent_1 := 1;
                    if (begin_date_1 is not null) then
                        if (current_date_1<begin_date_1)then
                            isbeAgent_1 :=0;
                        end if ; 
                        if (current_date_1=begin_date_1 and begin_time_1 is not null) then
                                if(current_time_1<begin_time_1) then
                                   isbeAgent_1 :=0;
                                end if;
                        end if;
                    end if;
                    
                    if (end_date_1 is not null) then
                        if (current_date_1>end_date_1)then 
                            isbeAgent_1 :=0;
                        end if;
                        if (current_date_1=end_date_1 and end_time_1 is not null) then
                            if(current_time_1>end_time_1) then
                               isbeAgent_1 :=0;
                            end if;
                        end if;
                    end if;
            end loop;
            
            if type_1=1
            then
                if departmentid_1 = objid_1 and seclevel_1 >= level_n_1 and seclevel_1 <= level2_n_1 then
                    insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,resourceid_1,0,0);
                end if;
                if isbeAgent_1=1 then
                        insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,agenter_id_1,0,1);
                end if;
            end if;
            if type_1=2
            then
                SELECT count(resourceid) into userid_1  FROM HrmRoleMembers where roleid = objid_1 and rolelevel >=level_n_1 and resourceid = resourceid_1;
                if userid_1 > 0  then
                    insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,resourceid_1,0,0);
                    if isbeAgent_1=1 then
                        insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,agenter_id_1,0,1);
                    end if;
                end if;
            end if;
            if type_1=3
            then
                if resourceid_1 = objid_1 then
                    insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,resourceid_1,0,0);
                    if isbeAgent_1=1 then
                        insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,agenter_id_1,0,1);
                    end if;
                end if;
            end if;
            if type_1=30
            then
                if subcompanyid1_1 = objid_1 and seclevel_1 >= level_n_1 and seclevel_1 <= level2_n_1 then
                    insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,resourceid_1,0,0);
                    if isbeAgent_1=1 then
                        insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,agenter_id_1,0,1);
                    end if;
                end if;
            end if;
        end loop; 
    end if ;
end if;
end ;
/
