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
	@oldseclevel_1	 int,
	@seclevel_1	 int,
	@signorder  int,
	@all_cursor cursor,
	@detail_cursor cursor

select @olddepartmentid_1 = departmentid, @oldseclevel_1 = seclevel from deleted
select @resourceid_1 = id , @loginid_1 = loginid , @departmentid_1 = departmentid, @seclevel_1 = seclevel from inserted
select @subcompanyid1_1 = subcompanyid1 from HrmDepartment where id = @departmentid_1

if (@departmentid_1 is not null and @olddepartmentid_1 is not null and (@departmentid_1 <> @olddepartmentid_1 or  @seclevel_1 <> @oldseclevel_1) )
begin 
    delete from workflow_createrlist where userid = @resourceid_1 and usertype = 0 
    
    if @loginid_1 <> '' and @loginid_1 is not null 
    begin 
        SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR				
        select workflowid,type,objid,level_n,level2_n,signorder from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid

        OPEN @all_cursor 
        FETCH NEXT FROM @all_cursor INTO @workflowid ,	@type ,@objid ,@level_n ,@level2_n,@signorder
        WHILE @@FETCH_STATUS = 0 
        begin 
            if @type=1 
            begin
                if @departmentid_1 is not null and @departmentid_1 = @objid and @seclevel_1 >= @level_n and @seclevel_1 <= @level2_n 
			if  @signorder is not null and @signorder = 2 
			begin
				delete from workflow_createrlist where workflowid=@workflowid and userid=@resourceid_1 and usertype=0
			end
			else
			begin
				insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@resourceid_1,0)
			end
            end
            else if @type=2
            begin
                SELECT @userid = count(resourceid) FROM HrmRoleMembers where roleid =  @objid and rolelevel >=@level_n and resourceid = @resourceid_1 
                if @userid > 0  
			if  @signorder is not null and @signorder = 2 
			begin
				delete from workflow_createrlist where workflowid=@workflowid and userid=@resourceid_1 and usertype=0
			end
			else
			begin
				insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@resourceid_1,0)
			end
            end
            else if @type=3
            begin
                if @resourceid_1 = @objid 
                    insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@resourceid_1,0)
            end
            else if @type=30
            begin
                if @subcompanyid1_1 = @objid and @seclevel_1 >= @level_n and @seclevel_1 <= @level2_n
			if  @signorder is not null and @signorder = 2 
			begin
				delete from workflow_createrlist where workflowid=@workflowid and userid=@resourceid_1 and usertype=0
			end
			else
			begin
				insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@resourceid_1,0)
			end
            end
            FETCH NEXT FROM @all_cursor INTO @workflowid ,	@type ,@objid ,@level_n,@level2_n,@signorder
        end 
        CLOSE @all_cursor 
        DEALLOCATE @all_cursor  
    end
end
go

alter PROCEDURE URole_workflow_createlist (@roleid_1 int , @flag integer output , @msg varchar(80) output)
AS
Declare @workflowid int,
	@type int,
 	@objid int,
	@level_n int,
        @level2_n int,
	@userid int,
	@signorder  int,
	@all_cursor cursor,
	@detail_cursor cursor


delete from workflow_createrlist  where  userid>-1 and workflowid in (select workflowid from workflow_groupdetail,workflow_nodegroup a ,workflow_flownode b  where type=2   and objid=@roleid_1 and a.id=groupid  and a.nodeid=b.nodeid and b.nodetype=0) ; 

SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR				
select workflowid,type,objid,level_n,level2_n,signorder from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 
 where t1.nodetype='0' and t1.nodeid=t2.nodeid and t2.id = t3.groupid and workflowid in  (select workflowid from workflow_groupdetail,workflow_nodegroup a ,workflow_flownode b  where type=2 and  objid=@roleid_1 and a.id=groupid  and a.nodeid=b.nodeid and b.nodetype=0)

OPEN @all_cursor 
FETCH NEXT FROM @all_cursor INTO @workflowid ,	@type ,@objid ,@level_n, @level2_n, @signorder
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
			if  @signorder is not null and @signorder = 2 
			begin
				delete from workflow_createrlist where workflowid=@workflowid and userid=@userid and usertype=0
			end
			else
			begin
				insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,0)
			end
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
			if  @signorder is not null and @signorder = 2 
			begin
				delete from workflow_createrlist where workflowid=@workflowid and userid=@userid and usertype=0
			end
			else
			begin
				insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,0)
			end
			FETCH NEXT FROM @detail_cursor INTO @userid
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor  
	end
	else if @type=3
	begin
		insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@objid,0)
	end
	else if @type=30
	begin
		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
		select id from HrmResource where subcompanyid1 = @objid and seclevel >= @level_n and seclevel <= @level2_n 

		OPEN @detail_cursor 
		FETCH NEXT FROM @detail_cursor INTO @userid
		WHILE @@FETCH_STATUS = 0 
		begin 
			if  @signorder is not null and @signorder = 2 
			begin
				delete from workflow_createrlist where workflowid=@workflowid and userid=@userid and usertype=0
			end
			else
			begin
				insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,0)
			end
			FETCH NEXT FROM @detail_cursor INTO @userid
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor
	end
	FETCH NEXT FROM @all_cursor INTO @workflowid ,	@type ,@objid ,@level_n,@level2_n, @signorder
end 
CLOSE @all_cursor 
DEALLOCATE @all_cursor  

GO
