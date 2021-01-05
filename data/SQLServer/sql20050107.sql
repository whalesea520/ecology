alter TRIGGER Tri_U_workflow_createlist ON HrmResource WITH ENCRYPTION
FOR UPDATE
AS
Declare @workflowid int,
        @type int,
        @objid int,
        @level_n int,
        @level2_n int,
        @userid int,
        @resourceid_1 int,
        @loginid_1 varchar(60),
        @olddepartmentid_1 int,
        @subcompanyid1_1 int,
        @departmentid_1 int,
        @oldseclevel_1   int,
        @seclevel_1  int,
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

select @olddepartmentid_1 = departmentid, @oldseclevel_1 = seclevel from deleted
select @resourceid_1 = id , @loginid_1 = loginid , @departmentid_1 = departmentid, @seclevel_1 = seclevel from inserted
select @subcompanyid1_1 = subcompanyid1 from HrmDepartment where id = @departmentid_1
select @current_date=subString(convert(char,getDate(),120),1,10)
select @current_time=subString(convert(char,getDate(),120),12,19)

if ( @departmentid_1 <> @olddepartmentid_1 or  @seclevel_1 <> @oldseclevel_1 )
begin 
    delete from workflow_createrlist where userid = @resourceid_1 and usertype = 0
    
    if @loginid_1 <> '' and @loginid_1 is not null
    begin 
        SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
        select workflowid,type,objid,level_n,level2_n from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid

        OPEN @all_cursor 
        FETCH NEXT FROM @all_cursor INTO @workflowid ,  @type ,@objid ,@level_n ,@level2_n
        WHILE @@FETCH_STATUS = 0
        begin 

            SET @isbeAgent=0
            SET @agent_cursor = CURSOR FORWARD_ONLY STATIC FOR
            select agenterId ,beginDate ,beginTime ,endDate ,endTime from Workflow_Agent where workflowId=@workflowid and beagenterId=@resourceid_1 and isCreateAgenter=1
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


            if @type=1 
            begin
                if @departmentid_1 = @objid and @seclevel_1 >= @level_n and @seclevel_1 <= @level2_n begin
                    insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@resourceid_1,0,0)
                    if @isbeAgent=1
                        insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@agenter_id,0,1)
                end
            end
            else if @type=2
            begin
                SELECT @userid = count(resourceid) FROM HrmRoleMembers where roleid =  @objid and rolelevel >=@level_n and resourceid = @resourceid_1
                if @userid > 0  begin
                    insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@resourceid_1,0,0)
                    if @isbeAgent=1
                        insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@agenter_id,0,1)
                end
            end
            else if @type=3
            begin
                if @resourceid_1 = @objid begin
                    insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@resourceid_1,0,0)
                    if @isbeAgent=1
                        insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@agenter_id,0,1)
                end
            end
            else if @type=30
            begin
                if @subcompanyid1_1 = @objid and @seclevel_1 >= @level_n and @seclevel_1 <= @level2_n begin
                    insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@resourceid_1,0,0)
                    if @isbeAgent=1
                        insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(@workflowid,@agenter_id,0,1)
                end
            end
            FETCH NEXT FROM @all_cursor INTO @workflowid ,  @type ,@objid ,@level_n,@level2_n
        end 
        CLOSE @all_cursor
        DEALLOCATE @all_cursor
    end
end
go