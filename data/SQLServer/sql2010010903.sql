delete from workflow_createrlist where usertype=1 and userid<>-1
GO
create PROCEDURE updatecuscreatewf as
declare
	@workflowid int,
	@type int,
	@objid int,
	@customerid int,
	@usertype1 int,
	@usertype2 int

	declare groupdetail_cursor cursor for
	select f.workflowid,g.type,g.objid,g.level_n,g.level2_n from workflow_groupdetail g left join workflow_nodegroup n on n.id=g.groupid left join workflow_flownode f on f.nodeid=n.nodeid where g.type in (20,21,22,23,24,25) and f.nodetype='0' 
	open groupdetail_cursor 
		fetch next from groupdetail_cursor into @workflowid , @type, @objid, @usertype1, @usertype2
	while @@fetch_status=0
		begin 
			if @type=20
			begin
				insert into workflow_createrlist (workflowid, userid, usertype, usertype2)
				select @workflowid, id, 1, 0 from CRM_CustomerInfo where seclevel >= @usertype1 and seclevel <= @usertype2 and type = @objid
			end
			else if @type=21
			begin
				insert into workflow_createrlist (workflowid, userid, usertype, usertype2)
				select @workflowid, id, 1, 0 from CRM_CustomerInfo where  seclevel >= @usertype1 and seclevel <= @usertype2 and status = @objid
			end
			else if @type=22
			begin
				insert into workflow_createrlist (workflowid, userid, usertype, usertype2)
				select @workflowid, id, 1, 0 from CRM_CustomerInfo where  seclevel >= @usertype1 and seclevel <= @usertype2 and department = @objid
			end
			else if @type=25
			begin
				insert into workflow_createrlist (workflowid, userid, usertype, usertype2)
				values (@workflowid, -2, @usertype1, @usertype2)
			end
		fetch next from groupdetail_cursor into @workflowid , @type, @objid, @usertype1, @usertype2
		end 
	close groupdetail_cursor deallocate groupdetail_cursor


GO
execute updatecuscreatewf
GO
drop PROCEDURE updatecuscreatewf 
GO


