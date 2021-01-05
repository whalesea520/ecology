alter TRIGGER Tri_URole_workflow_createlist ON HrmRoleMembers WITH ENCRYPTION
FOR INSERT, UPDATE, DELETE 
AS
Declare @workflowid int,
        @type int,
        @objid int,
        @level_n int,
        @level2_n int,
        @userid int,
        @all_cursor cursor,
        @detail_cursor cursor,
        @current_date char(10),
        @current_time char(8),
        @agenter_id int,
        @begin_date char(10),
        @begin_time char(8),
        @end_date char(10),
        @end_time char(8),
        @agent_cursor cursor,
        @isbeAgent int

select @current_date=subString(convert(char,getDate(),120),1,10)
select @current_time=subString(convert(char,getDate(),120),12,19)
delete from workflow_createrlist where userid <> -1 and userid <> -2 and usertype = 0 

SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
select workflowid,type,objid,level_n,level2_n from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid

OPEN @all_cursor 
FETCH NEXT FROM @all_cursor INTO @workflowid ,  @type ,@objid ,@level_n, @level2_n
WHILE @@FETCH_STATUS = 0 
begin 
    if @type=1 
    begin
        SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR
        select id from HrmResource where departmentid = @objid and seclevel >= @level_n and seclevel <= @level2_n

        OPEN @detail_cursor 
        FETCH NEXT FROM @detail_cursor INTO @userid
        WHILE @@FETCH_STATUS = 0 
        begin 
            SET @isbeAgent=0
            SET @agent_cursor = CURSOR FORWARD_ONLY STATIC FOR
            select agenterId ,beginDate ,beginTime ,endDate ,endTime from Workflow_Agent where workflowId=@workflowid and beagenterId=@userid and isCreateAgenter=1
            OPEN @agent_cursor
            FETCH NEXT FROM @agent_cursor INTO @agenter_id ,@begin_date ,@begin_time ,@end_date ,@end_time
            if @@FETCH_STATUS = 0
            begin
                SET @isbeAgent=1;
                if (@begin_date<>'') begin
                    if (@current_date<@begin_date)
                        SET @isbeAgent=0
                    else begin
                        if (@current_date=@begin_date and @begin_time<>'') begin
                            if(@current_time<@begin_time) 
                                SET @isbeAgent=0
                        end
                    end
                end
                if (@end_date<>'') begin
                    if (@current_date>@end_date) 
                        SET @isbeAgent=0
                    else begin
                        if (@current_date=@end_date and @end_time<>'') begin
                            if(@current_time>@end_time) 
                                SET @isbeAgent=0
                        end
                    end
                end
            end
            CLOSE @agent_cursor
            DEALLOCATE @agent_cursor

            if @isbeAgent=1
                insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@agenter_id,0,1)

            insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@userid,0,0)
            FETCH NEXT FROM @detail_cursor INTO @userid
        end 
        CLOSE @detail_cursor
        DEALLOCATE @detail_cursor  
    end
    else if @type=2
    begin
        SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR
        SELECT resourceid as id FROM HrmRoleMembers where roleid =  @objid and rolelevel >=@level_n

        OPEN @detail_cursor 
        FETCH NEXT FROM @detail_cursor INTO @userid
        WHILE @@FETCH_STATUS = 0 
        begin 
            SET @isbeAgent=0
            SET @agent_cursor = CURSOR FORWARD_ONLY STATIC FOR
            select agenterId ,beginDate ,beginTime ,endDate ,endTime from Workflow_Agent where workflowId=@workflowid and beagenterId=@userid and isCreateAgenter=1
            OPEN @agent_cursor
            FETCH NEXT FROM @agent_cursor INTO @agenter_id ,@begin_date ,@begin_time ,@end_date ,@end_time
            if @@FETCH_STATUS = 0
            begin
                SET @isbeAgent=1;
                if (@begin_date<>'') begin
                    if (@current_date<@begin_date)
                        SET @isbeAgent=0
                    else begin
                        if (@current_date=@begin_date and @begin_time<>'') begin
                            if(@current_time<@begin_time) 
                                SET @isbeAgent=0
                        end
                    end
                end
                if (@end_date<>'') begin
                    if (@current_date>@end_date) 
                        SET @isbeAgent=0
                    else begin
                        if (@current_date=@end_date and @end_time<>'') begin
                            if(@current_time>@end_time) 
                                SET @isbeAgent=0
                        end
                    end
                end
            end
            CLOSE @agent_cursor
            DEALLOCATE @agent_cursor

            if @isbeAgent=1
                insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@agenter_id,0,1)

            insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@userid,0,0)
            FETCH NEXT FROM @detail_cursor INTO @userid
        end 
        CLOSE @detail_cursor
        DEALLOCATE @detail_cursor  
    end
    else if @type=3
    begin
            SET @isbeAgent=0
            SET @agent_cursor = CURSOR FORWARD_ONLY STATIC FOR
            select agenterId ,beginDate ,beginTime ,endDate ,endTime from Workflow_Agent where workflowId=@workflowid and beagenterId=@objid and isCreateAgenter=1
            OPEN @agent_cursor
            FETCH NEXT FROM @agent_cursor INTO @agenter_id ,@begin_date ,@begin_time ,@end_date ,@end_time
            if @@FETCH_STATUS = 0
            begin
                SET @isbeAgent=1;
                if (@begin_date<>'') begin
                    if (@current_date<@begin_date)
                        SET @isbeAgent=0
                    else begin
                        if (@current_date=@begin_date and @begin_time<>'') begin
                            if(@current_time<@begin_time) 
                                SET @isbeAgent=0
                        end
                    end
                end
                if (@end_date<>'') begin
                    if (@current_date>@end_date) 
                        SET @isbeAgent=0
                    else begin
                        if (@current_date=@end_date and @end_time<>'') begin
                            if(@current_time>@end_time) 
                                SET @isbeAgent=0
                        end
                    end
                end
            end
            CLOSE @agent_cursor
            DEALLOCATE @agent_cursor

            if @isbeAgent=1
                insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@agenter_id,0,1)

        insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@userid,0,0)
    end
    else if @type=30
    begin
        SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR
        select id from HrmResource where subcompanyid1 = @objid and seclevel >= @level_n and seclevel <= @level2_n

        OPEN @detail_cursor 
        FETCH NEXT FROM @detail_cursor INTO @userid
        WHILE @@FETCH_STATUS = 0 
        begin 
            SET @isbeAgent=0
            SET @agent_cursor = CURSOR FORWARD_ONLY STATIC FOR
            select agenterId ,beginDate ,beginTime ,endDate ,endTime from Workflow_Agent where workflowId=@workflowid and beagenterId=@userid and isCreateAgenter=1
            OPEN @agent_cursor
            FETCH NEXT FROM @agent_cursor INTO @agenter_id ,@begin_date ,@begin_time ,@end_date ,@end_time
            if @@FETCH_STATUS = 0
            begin
                SET @isbeAgent=1;
                if (@begin_date<>'') begin
                    if (@current_date<@begin_date)
                        SET @isbeAgent=0
                    else begin
                        if (@current_date=@begin_date and @begin_time<>'') begin
                            if(@current_time<@begin_time) 
                                SET @isbeAgent=0
                        end
                    end
                end
                if (@end_date<>'') begin
                    if (@current_date>@end_date) 
                        SET @isbeAgent=0
                    else begin
                        if (@current_date=@end_date and @end_time<>'') begin
                            if(@current_time>@end_time) 
                                SET @isbeAgent=0
                        end
                    end
                end
            end
            CLOSE @agent_cursor
            DEALLOCATE @agent_cursor

            if @isbeAgent=1
                insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@agenter_id,0,1)

            insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@userid,0,0)
            FETCH NEXT FROM @detail_cursor INTO @userid
        end 
        CLOSE @detail_cursor
        DEALLOCATE @detail_cursor
    end
    FETCH NEXT FROM @all_cursor INTO @workflowid ,  @type ,@objid ,@level_n,@level2_n
end 
CLOSE @all_cursor
DEALLOCATE @all_cursor

go