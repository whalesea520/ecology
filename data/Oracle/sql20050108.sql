CREATE or REPLACE TRIGGER Tri_URole_workflow_createlist
after insert or update or delete ON HrmRoleMembers
for each row
Declare workflowid_1 integer;
        type_1 integer;
        objid_1 integer;
        level_n_1 integer;
        level2_n_1 integer;
        userid_1 integer;
        current_date char(10);
        current_time char(8);
        agenter_id integer;
        begin_date char(10);
        begin_time char(8);
        end_date char(10);
        end_time char(8);
        isbeAgent integer;

begin
    select subStr(to_char(sysdate,'hh24:mm:ss'),1,8) into current_time from dual;
    select subStr(to_char(sysdate,'yyyy-mm-dd'),1,10) into  current_date from dual;
    
    delete from workflow_createrlist where userid <> -1 and userid <> -2 and usertype = 0 ;
    
    for all_cursor in(select workflowid,type,objid,level_n,level2_n from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid)
    loop
        workflowid_1 := all_cursor.workflowid ;
        type_1 := all_cursor.type ;
        objid_1 := all_cursor.objid ;
        level_n_1 := all_cursor.level_n ;
        level2_n_1 := all_cursor.level2_n ;
        if type_1=1
        then
            for detail_cursor in(select id from HrmResource where departmentid = objid_1 and seclevel >= level_n_1 and seclevel <= level2_n_1)
            loop
                userid_1 := detail_cursor.id ;
                isbeAgent:=0;
                for agent_cursor in(select agenterId ,beginDate ,beginTime ,endDate ,endTime from Workflow_Agent where workflowId=workflowid_1 and beagenterId=userid_1 and isCreateAgenter=1)
                loop
                    agenter_id := agent_cursor.agenterId ;
                    begin_date := agent_cursor.beginDate ;
                    begin_time := agent_cursor.beginTime ;
                    end_date := agent_cursor.endDate ;
                    end_time := agent_cursor.endTime ;
                    isbeAgent:=1;
                    if (begin_date is not null) then
                        if (current_date<begin_date) then
                           isbeAgent:=0;
                        end if;
                        if (current_date=begin_date and begin_time is not null) then
                                if(current_time<begin_time) then
                                   isbeAgent:=0;
                                end if;
                        end if;
                    end if;
                    if (end_date is not null) then
                        if (current_date>end_date) then
                            isbeAgent:=0;
                        end if;
                        if (current_date=end_date and end_time is not null) then
                                if(current_time>end_time) then 
                                  isbeAgent:=0;
                                end if;
                        end if;
                    end if;
                end loop;

                if isbeAgent=1 then
                    insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,agenter_id,0,1);
                end if;

                insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,userid_1,0,0);
            end loop ;
        end if;

        if type_1=2
        then
            for detail_cursor in(SELECT resourceid as id FROM HrmRoleMembers_Tri where roleid =  objid_1 and rolelevel >=level_n_1)
            loop
                userid_1 :=detail_cursor.id;
                isbeAgent :=0;
                for agent_cursor in (select agenterId ,beginDate ,beginTime ,endDate ,endTime from Workflow_Agent where workflowId=workflowid_1 and beagenterId=userid_1 and isCreateAgenter=1)
                loop
                    agenter_id :=agent_cursor.agenterId;
                    begin_date :=agent_cursor.beginDate;
                    begin_time :=agent_cursor.beginTime;
                    end_date :=agent_cursor.endDate;
                    end_time :=agent_cursor.endTime;
                    isbeAgent:=1;
                    if (begin_date is not null) then
                        if (current_date<begin_date)then
                            isbeAgent:=0;
                        end if;
                        if (current_date=begin_date and begin_time is not null) then
                                if(current_time<begin_time) then
                                    isbeAgent:=0;
                                 end if;
                        end if;
                    end if;
                    if (end_date is not null) then
                        if (current_date>end_date) then
                           isbeAgent:=0;
                        end if;
                        if (current_date=end_date and end_time is not null) then
                            if(current_time>end_time) then
                                    isbeAgent:=0;
                            end if;
                        end if;
                    end if;
                end loop;
                if isbeAgent=1 then
                    insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,agenter_id,0,1);
                end if;
                insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,userid_1,0,0);
            end loop;
        end if;

        if type_1=3
        then
            isbeAgent:=0;
            for agent_cursor in(select agenterId ,beginDate ,beginTime ,endDate ,endTime from Workflow_Agent where workflowId=workflowid_1 and beagenterId=objid_1 and isCreateAgenter=1)
            loop
                agenter_id :=agent_cursor.agenterId;
                begin_date :=agent_cursor.beginDate;
                begin_time :=agent_cursor.beginTime;
                end_date :=agent_cursor.endDate;
                end_time :=agent_cursor.endTime;
                isbeAgent:=1;
                if (begin_date is not null) then
                    if (current_date<begin_date)then
                        isbeAgent:=0;
                    end if;
                    if (current_date=begin_date and begin_time is not null) then
                        if(current_time<begin_time) then
                           isbeAgent:=0;
                        end if;
                    end if;
                end if;
                if (end_date is not null) then
                    if (current_date>end_date) then
                        isbeAgent:=0;
                    end if;
                    if (current_date=end_date and end_time is not null) then
                         if(current_time>end_time) then
                             isbeAgent:=0;
                         end if;
                    end if;
                 end if;
            end loop;

                if isbeAgent=1 then
                    insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,agenter_id,0,1);
                end if;
            insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,userid_1,0,0);
        end if;

        if type_1=30
        then
            for detail_cursor in(select id from HrmResource where subcompanyid1 = objid_1 and seclevel >= level_n_1 and seclevel <= level2_n_1)
            loop
                userid_1 :=detail_cursor.id;
                isbeAgent:=0;
                for agent_cursor in(select agenterId ,beginDate ,beginTime ,endDate ,endTime from Workflow_Agent where workflowId=workflowid_1 and beagenterId=userid_1 and isCreateAgenter=1)
                loop
                    agenter_id :=agent_cursor.agenterId;
                    begin_date :=agent_cursor.beginDate;
                    begin_time :=agent_cursor.beginTime;
                    end_date :=agent_cursor.endDate;
                    end_time :=agent_cursor.endTime;
                    isbeAgent:=1;
                    if (begin_date is not null) then
                        if (current_date<begin_date) then
                            isbeAgent:=0;
                        end if;
                        if (current_date=begin_date and begin_time is not null) then
                            if(current_time<begin_time) then
                                   isbeAgent:=0;
                            end if;
                        end if;
                    end if;
                    if (end_date is not null) then
                        if (current_date>end_date) then
                           isbeAgent:=0;
                        end if;
                        if (current_date=end_date and end_time is not null) then
                            if(current_time>end_time) then
                                isbeAgent:=0;
                            end if;
                        end if;
                    end if;
                end loop;

                if isbeAgent=1 then
                    insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,agenter_id,0,1);
                end if;
                insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,userid_1,0,0);
            end loop;
        end if;
    end loop;
end;
/
