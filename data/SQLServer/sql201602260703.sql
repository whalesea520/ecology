drop TRIGGER Tri_U_Workflow_CreateShare
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
		@bhxj int,
		@jobfield	  varchar(4000),
	    @jobobj	  varchar(4000),
	    @v_strs_last varchar(4000),
	    @PointerPrev       int,
	    @PointerCurr       int,
	    @v_str       varchar(500),
		@detail_cursor cursor,
		@detail_del_cursor cursor,
		@detail_insert_cursor CURSOR
		
		
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
	set @detail_insert_cursor = cursor FORWARD_ONLY static for select type, objid, level_n, level2_n, signorder, groupid, id,bhxj,jobfield,jobobj from inserted 
	 
	OPEN @detail_insert_cursor 
	fetch next from @detail_insert_cursor INTO @type, @objid, @level_n, @level2_n, @signorder, @groupid, @gid,@bhxj,@jobfield,@jobobj
	while @@FETCH_STATUS = 0 
	begin 
		
		if EXISTS(select 1 from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid and t3.id=@gid)
		begin
			select @workflowid = workflowid from workflow_flownode t1,workflow_nodegroup t2 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = @groupid
			
			if @type=1 or @type=3 or @type=4 or @type=30
			begin
				insert into ShareInnerWfCreate(gid, workflowid, type, content, min_seclevel, max_seclevel, isBelong, usertype,bhxj) 
				values(@gid, @workflowid, @type, @objid, @level_n, @level2_n, @signorder, 0,@bhxj)
			end
			else if @type=2
			begin
				set @objid = CONVERT(int, CONVERT(varchar(32), @objid) +  CONVERT(varchar(32), @level_n))
				insert into ShareInnerWfCreate(gid, workflowid, type, content, min_seclevel, max_seclevel, isBelong, usertype,bhxj) 
				values(@gid, @workflowid, @type, @objid, -1, -1, @signorder, 0,@bhxj)
			end
		    else if @type = 58
	      	begin
		      	if @jobfield IS null 
		      	begin
			      	insert into ShareInnerWfCreate (gid,workflowid,type,content,min_seclevel,max_seclevel,isBelong,usertype,bhxj)
				        VALUES (@gid, @workflowid, @type, @jobobj, @level_n, @level2_n, @signorder, 0,@bhxj);
		      	end
		      	else IF @jobfield IS NOT null
		      	    BEGIN
		      	    SET @v_strs_last = @jobfield
				    Set @PointerPrev=1 
				    while (@PointerPrev < LEN(@v_strs_last)) 
				    Begin 
				        Set @PointerCurr=CharIndex(',',@v_strs_last,@PointerPrev) 
				        if(@PointerCurr>0) 
				        Begin 
				            set @v_str=SUBSTRING(@v_strs_last,@PointerPrev,@PointerCurr-@PointerPrev)
				            insert into ShareInnerWfCreate (gid,workflowid,type,content,min_seclevel,max_seclevel,isBelong,usertype,bhxj)
					            VALUES (@gid, @workflowid, @type, @jobobj, @level_n, @v_str, @signorder, 0,@bhxj);
				            SET @PointerPrev = @PointerCurr+1 
				        End 
				        else 
				            Break 
				    End 
				        set @v_str=SUBSTRING(@v_strs_last,@PointerPrev,LEN(@v_strs_last)-@PointerPrev+1)
				        insert into ShareInnerWfCreate (gid,workflowid,type,content,min_seclevel,max_seclevel,isBelong,usertype,bhxj)
				            VALUES (@gid, @workflowid, @type, @jobobj, @level_n, @v_str, @signorder, 0,@bhxj);
			  		
				    end
	      	end
			else if @type=20 or @type=21 or @type=22 or @type=25 
			begin
				insert into ShareInnerWfCreate(gid, workflowid, type, content, min_seclevel, max_seclevel, isBelong, usertype,bhxj) 
				values(@gid, @workflowid, @type, @objid, @level_n, @level2_n, @signorder, 1,@bhxj)
			end
		end
		FETCH NEXT FROM @detail_insert_cursor INTO @type, @objid, @level_n, @level2_n, @signorder, @groupid, @gid,@bhxj,@jobfield,@jobobj
	end 
	CLOSE @detail_insert_cursor 
	DEALLOCATE @detail_insert_cursor
end
GO