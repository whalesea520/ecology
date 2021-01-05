ALTER TABLE workflow_createrlist
drop column isAgenter 
GO

ALTER PROCEDURE workflow_createrlist_Insert 
(@workflowid_1  int,
 @userid_2  int,
 @usertype_3    int, 
 @usertype_4    int,        /* 当为所有人和所有客户的时候，为最大安全级别，否则为0 */
 @flag integer output , 
 @msg varchar(80) output )
AS INSERT INTO workflow_createrlist 
( workflowid, userid, usertype, usertype2 ) 
VALUES 
( @workflowid_1, @userid_2, @usertype_3, @usertype_4 )
GO

ALTER PROCEDURE Workflow_createlist_select 
 @userid int,
 @usertype int,
 @flag integer output,
 @msg varchar(80) output
AS 
select distinct a.workflowid 
from workflow_createrlist a
where a.userid =@userid and a.usertype =@usertype 

GO


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
        select workflowid,type,objid,level_n,level2_n from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid

        OPEN @all_cursor 
        FETCH NEXT FROM @all_cursor INTO @workflowid ,	@type ,@objid ,@level_n ,@level2_n
        WHILE @@FETCH_STATUS = 0 
        begin 
            if @type=1 
            begin
                if @departmentid_1 is not null and @departmentid_1 = @objid and @seclevel_1 >= @level_n and @seclevel_1 <= @level2_n 
                    insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@resourceid_1,0)
            end
            else if @type=2
            begin
                SELECT @userid = count(resourceid) FROM HrmRoleMembers where roleid =  @objid and rolelevel >=@level_n and resourceid = @resourceid_1 
                if @userid > 0  
                    insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@resourceid_1,0)
            end
            else if @type=3
            begin
                if @resourceid_1 = @objid 
                    insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@resourceid_1,0)
            end
            else if @type=30
            begin
                if @subcompanyid1_1 = @objid and @seclevel_1 >= @level_n and @seclevel_1 <= @level2_n
                insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@resourceid_1,0)
            end
            FETCH NEXT FROM @all_cursor INTO @workflowid ,	@type ,@objid ,@level_n,@level2_n
        end 
        CLOSE @all_cursor 
        DEALLOCATE @all_cursor  
    end
end
go


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
	@detail_cursor cursor

delete from workflow_createrlist where userid <> -1 and userid <> -2 and usertype = 0 

SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR				
select workflowid,type,objid,level_n,level2_n from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid

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
