
drop TRIGGER Tri_URole_workflow_createlist
go
create PROCEDURE URole_workflow_createlist (@roleid_1 int , @flag integer output , @msg varchar(80) output)
AS
Declare @workflowid int,
	@type int,
 	@objid int,
	@level_n int,
        @level2_n int,
	@userid int,
	@all_cursor cursor,
	@detail_cursor cursor


delete from workflow_createrlist  where  userid>-1 and workflowid in (select workflowid from workflow_groupdetail,workflow_nodegroup a ,workflow_flownode b  where type=2   and objid=@roleid_1 and a.id=groupid  and a.nodeid=b.nodeid and b.nodetype=0) ; 

SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR				
select workflowid,type,objid,level_n,level2_n from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 
 where t1.nodetype='0' and t1.nodeid=t2.nodeid and t2.id = t3.groupid and workflowid in  (select workflowid from workflow_groupdetail,workflow_nodegroup a ,workflow_flownode b  where type=2 and  objid=@roleid_1 and a.id=groupid  and a.nodeid=b.nodeid and b.nodetype=0)

OPEN @all_cursor 
FETCH NEXT FROM @all_cursor INTO @workflowid ,	@type ,@objid ,@level_n, @level2_n
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
			insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,0)
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
			insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,0)
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
			insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,0)
			FETCH NEXT FROM @detail_cursor INTO @userid
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor
	end
	FETCH NEXT FROM @all_cursor INTO @workflowid ,	@type ,@objid ,@level_n,@level2_n
end 
CLOSE @all_cursor 
DEALLOCATE @all_cursor  

go