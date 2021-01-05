create table ShareInnerWfCreate (
	id int identity,
	gid int not null,
	workflowid int not null,
	type int not null,
	content int,
	min_seclevel int,
	max_seclevel int,
	isBelong int,
	usertype int
)
GO
create clustered index  ShareInnerWfCreate_index ON ShareInnerWfCreate(type, content) with fillfactor=30
GO
if exists(select * from sysobjects where name='Tri_U_workflow_createlist') begin drop TRIGGER Tri_U_workflow_createlist end
GO
if exists(select * from sysobjects where name='Tri_U_workflow_createlist_I') begin drop TRIGGER Tri_U_workflow_createlist_I end
GO
if exists(select * from sysobjects where name='Tri_URole_workflow_createlist') begin drop TRIGGER Tri_URole_workflow_createlist end
GO
if exists(select * from sysobjects where name='Tri_UCRM_workflow_createlist') begin drop TRIGGER Tri_UCRM_workflow_createlist end
GO
if exists(select * from sysobjects where name='URole_workflow_createlist') begin drop PROCEDURE URole_workflow_createlist end
GO
if exists(select * from sysobjects where name='workflow_createrlist_Insert') begin drop PROCEDURE workflow_createrlist_Insert end
GO
if exists(select * from sysobjects where name='Workflow_createlist_select') begin drop PROCEDURE Workflow_createlist_select end
GO
if exists(select * from sysobjects where name='Workflow_select_foragent') begin drop PROCEDURE Workflow_select_foragent end
GO
if exists(select * from sysobjects where name='workflow_createrlist_Delete') begin drop PROCEDURE workflow_createrlist_Delete end
GO
create procedure ShareForWorkflow AS 
Declare 
	@workflowid int,
	@groupid int,
	@gid int,
	@type int,
	@objid int,
	@level_n int,
	@level2_n int,
	@signorder  int,
	@groupid_old int,
	@detail_cursor cursor
	delete from ShareInnerWfCreate
	SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
	select workflowid,type,objid,level_n,level2_n,signorder, t2.id, t3.id from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid
	OPEN @detail_cursor 
	fetch next from @detail_cursor INTO @workflowid, @type, @objid, @level_n, @level2_n, @signorder, @groupid, @gid
	while @@FETCH_STATUS = 0 
	begin 
		if @type=1 or @type=3 or @type=4 or @type=30
	    begin
			insert into ShareInnerWfCreate(gid, workflowid, type, content, min_seclevel, max_seclevel, isBelong, usertype) 
			values(@gid, @workflowid, @type, @objid, @level_n, @level2_n, @signorder, 0)
		end
	    else if @type=2
	    begin
			set @objid = CONVERT(int, CONVERT(varchar(32), @objid) +  CONVERT(varchar(32), @level_n))
			insert into ShareInnerWfCreate(gid, workflowid, type, content, min_seclevel, max_seclevel, isBelong, usertype) 
			values(@gid, @workflowid, @type, @objid, -1, -1, @signorder, 0)
	    end
	    
	    else if @type=20 or @type=21 or @type=22 or @type=25 
	    begin
			insert into ShareInnerWfCreate(gid, workflowid, type, content, min_seclevel, max_seclevel, isBelong, usertype) 
			values(@gid, @workflowid, @type, @objid, @level_n, @level2_n, @signorder, 1)
	    end
		FETCH NEXT FROM @detail_cursor INTO @workflowid, @type, @objid, @level_n, @level2_n, @signorder, @groupid, @gid
	end 
	CLOSE @detail_cursor 
	DEALLOCATE @detail_cursor
GO
exec ShareForWorkflow
go
create trigger Tri_U_Workflow_CreateShare on workflow_groupdetail with ENCRYPTION
for insert, update, delete
as
Declare @workflowid int, 
		@groupid int,
		@gid int,
		@type int,
	 	@objid int,
		@level_n int,
	    @level2_n int,
		@signorder  int,
		@gid_old int,
		@detail_cursor cursor,
		@detail_del_cursor cursor,
		@detail_insert_cursor cursor
set @detail_del_cursor = cursor FORWARD_ONLY static for select id from deleted
OPEN @detail_del_cursor 
fetch next from @detail_del_cursor INTO @gid_old
while @@FETCH_STATUS = 0 
begin 
	delete from ShareInnerWfCreate where gid = @gid_old
    FETCH NEXT FROM @detail_del_cursor INTO @gid_old
end 
CLOSE @detail_del_cursor 
DEALLOCATE @detail_del_cursor
if EXISTS(SELECT 1 FROM inserted)  
begin
	set @detail_insert_cursor = cursor FORWARD_ONLY static for select type, objid, level_n, level2_n, signorder, groupid, id from inserted
	OPEN @detail_insert_cursor 
	fetch next from @detail_insert_cursor INTO @type, @objid, @level_n, @level2_n, @signorder, @groupid, @gid
	while @@FETCH_STATUS = 0 
	begin 
		if EXISTS(select 1 from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid and t3.id=@gid)
		begin
			select @workflowid = workflowid from workflow_flownode t1,workflow_nodegroup t2 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = @groupid
			
			if @type=1 or @type=3 or @type=4 or @type=30
			begin
				insert into ShareInnerWfCreate(gid, workflowid, type, content, min_seclevel, max_seclevel, isBelong, usertype) 
				values(@gid, @workflowid, @type, @objid, @level_n, @level2_n, @signorder, 0)
			end
			else if @type=2
			begin
				set @objid = CONVERT(int, CONVERT(varchar(32), @objid) +  CONVERT(varchar(32), @level_n))
				insert into ShareInnerWfCreate(gid, workflowid, type, content, min_seclevel, max_seclevel, isBelong, usertype) 
				values(@gid, @workflowid, @type, @objid, -1, -1, @signorder, 0)
			end
		    
			else if @type=20 or @type=21 or @type=22 or @type=25 
			begin
				insert into ShareInnerWfCreate(gid, workflowid, type, content, min_seclevel, max_seclevel, isBelong, usertype) 
				values(@gid, @workflowid, @type, @objid, @level_n, @level2_n, @signorder, 1)
			end
		end
		FETCH NEXT FROM @detail_insert_cursor INTO @type, @objid, @level_n, @level2_n, @signorder, @groupid, @gid
	end 
	CLOSE @detail_insert_cursor 
	DEALLOCATE @detail_insert_cursor
end
go