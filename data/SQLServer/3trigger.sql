
create TRIGGER [Tri_U_CptCapitalAssortment] ON CptCapitalAssortment WITH ENCRYPTION
FOR UPDATE
AS
Declare @groupid int,
	    @supassortmentid int,
	    @oldmark	 varchar(60),
	    @newmark	 varchar(60),
		@supmark	 varchar(60),
		@tempstr	 varchar(60)
if update(assortmentmark)
begin
	select distinct @groupid=id,@oldmark=assortmentmark from deleted 
	select distinct @newmark=assortmentmark,@supassortmentid=supassortmentid from CptCapitalAssortment where id = @groupid
		
	while 1>0
	begin 
		if @supassortmentid=0
		begin
			break
		end
		select @supmark = assortmentmark,@supassortmentid=supassortmentid from CptCapitalAssortment where id = @supassortmentid
		set @newmark=@supmark+@newmark
		set @oldmark=@supmark+@oldmark
	end
	
	set @tempstr = '%|'+convert(varchar(20),@groupid)+'|%'
	update CptCapital set mark = stuff(mark,1,len(@oldmark),@newmark)
	where (capitalgroupid=@groupid or capitalgroupid in (select id from CptCapitalAssortment where supassortmentstr like @tempstr)) and  counttype is null
	update CptCapital set mark = stuff(mark,3,len(@oldmark),@newmark)
	where (capitalgroupid=@groupid or capitalgroupid in (select id from CptCapitalAssortment where supassortmentstr like @tempstr )) and ( counttype = '1' or counttype = '2') 
end

go

CREATE TRIGGER [Tri_Update_bill_HrmTime] ON Prj_TaskProcess WITH ENCRYPTION
FOR UPDATE
AS
Declare @prjid int,
 	@taskid int,
 	@subject varchar(80),
 	@version	int,
 	@isactived	int,
 	@begindate	char(10),
 	@enddate	char(10),
 	@resourceid	int,
 	@tmpcount	int,
 	@tmpbegindate   char(10),
 	@tmpenddate char(10),
 	@tmpresourceid  int,
	@all_cursor cursor,
	@detail_cursor cursor
if update(isactived)
begin
	select distinct @prjid=prjid from deleted 
	delete from bill_hrmtime where requestid=@prjid and basictype=1 and detailtype=1
	select @subject=name from prj_projectinfo where id=@prjid
	
	SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
	select distinct hrmid from inserted where isactived=2 and (begindate !='x' or enddate !='-') and isdelete<>1
	OPEN @all_cursor 
	FETCH NEXT FROM @all_cursor INTO @resourceid
	WHILE @@FETCH_STATUS = 0
	begin
	    set @tmpbegindate=''
	    set @tmpenddate=''
		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR
		select prjid,begindate,enddate from inserted 
	    where isactived=2 and (begindate !='x' or enddate !='-') and isdelete<>1 and hrmid=@resourceid
		OPEN @detail_cursor 
	    FETCH NEXT FROM @detail_cursor INTO @prjid,@begindate,@enddate
		WHILE @@FETCH_STATUS = 0
		begin
		    if @begindate='x'   set @begindate=@enddate
		    if @enddate='-'   set @enddate=@begindate
		    if  @tmpbegindate=''    set @tmpbegindate=@begindate
		    else if  @begindate<@tmpbegindate    set @tmpbegindate=@begindate
		    if  @tmpenddate=''  set @tmpenddate=@enddate
		    else if  @enddate>@tmpenddate    set @tmpenddate=@enddate
		    
		    FETCH NEXT FROM @detail_cursor INTO @prjid,@begindate,@enddate
		end
		CLOSE @detail_cursor
	    DEALLOCATE @detail_cursor 
	    
	    insert into bill_hrmtime (resourceid,basictype,detailtype,requestid,name,begindate,enddate,status,accepterid)
		values (@resourceid,1,1,@prjid,@subject,@tmpbegindate,@tmpenddate,'0',convert(varchar(2000),@resourceid))    
		FETCH NEXT FROM @all_cursor INTO @resourceid
	end 
	CLOSE @all_cursor
	DEALLOCATE @all_cursor 
end
go

CREATE TRIGGER [Tri_U_bill_HrmTimeByMeet1] ON Meeting WITH ENCRYPTION
FOR UPDATE
AS
Declare 
 	@name varchar(80),
 	@isapproved	int,
 	@begindate	char(10),
 	@begintime  char(8),
 	@enddate	char(10),
 	@endtime    char(8),
 	@resourceid	int,
 	@meetingid	int,
 	@caller     int,
 	@contacter int,
	@all_cursor cursor,
	@detail_cursor cursor,
	@tmpcount int
if update(isapproved)
begin
	select distinct @meetingid=id from deleted 
	
	
	SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
	select id,name,caller,contacter,begindate,begintime,enddate,endtime from inserted 
	where isapproved=2 
	OPEN @all_cursor 
	FETCH NEXT FROM @all_cursor INTO @meetingid,@name,@caller,@contacter,@begindate,@begintime,@enddate,@endtime
	WHILE @@FETCH_STATUS = 0
	begin
		if @enddate=''   set @enddate=@begindate
		select @tmpcount=count(*) from bill_hrmtime where resourceid=@caller and basictype=5 and detailtype=1 and requestid=@meetingid
    	if @tmpcount=0
    		insert into bill_hrmtime (resourceid,requestid,basictype,detailtype,name,begindate,begintime,enddate,endtime,status,accepterid)
        	values (@caller,@meetingid,5,1,@name,@begindate,@begintime,@enddate,@endtime,'0',convert(varchar(255),@caller))
    	select @tmpcount=count(*) from bill_hrmtime where resourceid=@contacter and basictype=5 and detailtype=1 and requestid=@meetingid
    	if @tmpcount=0
        	insert into bill_hrmtime (resourceid,requestid,basictype,detailtype,name,begindate,begintime,enddate,endtime,status,accepterid)
        	values (@contacter,@meetingid,5,1,@name,@begindate,@begintime,@enddate,@endtime,'0',convert(varchar(255),@contacter))	
    	
		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR 
		select memberid from Meeting_Member2 where meetingid=@meetingid and membertype=1
		OPEN @detail_cursor 
		FETCH NEXT FROM @detail_cursor INTO @resourceid 
		WHILE @@FETCH_STATUS = 0
		begin
    		select @tmpcount=count(*) from bill_hrmtime where resourceid=@resourceid and basictype=5 and detailtype=1 and requestid=@meetingid
    	    if @tmpcount=0
        		insert into bill_hrmtime (resourceid,requestid,basictype,detailtype,name,begindate,begintime,enddate,endtime,status,accepterid)
        		values (@resourceid,@meetingid,5,1,@name,@begindate,@begintime,@enddate,@endtime,'0',convert(varchar(2000),@resourceid))
    		FETCH NEXT FROM @detail_cursor INTO @resourceid 
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor 
		FETCH NEXT FROM @all_cursor INTO @meetingid,@name,@caller,@contacter,@begindate,@begintime,@enddate,@endtime
	end 
	CLOSE @all_cursor
	DEALLOCATE @all_cursor 
end
go

CREATE TRIGGER [Tri_U_bill_HrmTimeByMeet2] ON Meeting_Member2 WITH ENCRYPTION
FOR UPDATE
AS
Declare 
    @recordid   int,
 	@name varchar(80),
 	@isapproved	int,
 	@begindate	char(10),
 	@begintime  char(8),
 	@enddate	char(10),
 	@endtime    char(8),
 	@resourceid	int,
 	@meetingid	int,
 	@othermember varchar(255),
 	@dotindex   int,
 	@tmpposition int,
 	@oldposition int,
 	@tmpresourceid  varchar(10),
 	@tmpcount   int,
	@all_cursor cursor,
	@detail_cursor cursor
if update(othermember)
begin
	select distinct @recordid=id,@meetingid=meetingid,@othermember=othermember from inserted 
	delete from bill_hrmtime where requestid=@meetingid and billid=@recordid and basictype=5 and detailtype=1
	
	SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
	select meetingid from inserted where othermember!='' 
	OPEN @all_cursor 
	FETCH NEXT FROM @all_cursor INTO @meetingid
	WHILE @@FETCH_STATUS = 0
	begin
	    select @name=name,@begindate=begindate,@begintime=begintime,@enddate=enddate,@endtime=endtime 
	    from meeting where id=@meetingid
		if @enddate=''   set @enddate=@begindate
		set @tmpposition = 1
		while @tmpposition != 0
		begin
		    set @oldposition=@tmpposition
		    set @tmpposition=charindex(',',@othermember+',',@tmpposition)
		    if  @tmpposition!=0
		    begin
    		    set @tmpresourceid=substring(@othermember+',',@oldposition,@tmpposition-@oldposition)
    		    set @resourceid=convert(int,@tmpresourceid)
    		    set @tmpposition=@tmpposition + 1
    		    select @tmpcount=count(*) from bill_hrmtime where resourceid=@resourceid and basictype=5 and detailtype=1 and requestid=@meetingid
    		    if @tmpcount=0
                	insert into bill_hrmtime (billid,resourceid,requestid,basictype,detailtype,name,begindate,begintime,enddate,endtime,status,accepterid)
                	values (@recordid,@resourceid,@meetingid,5,1,@name,@begindate,@begintime,@enddate,@endtime,'0',convert(varchar(2000),@resourceid))
    		end
		end 
		FETCH NEXT FROM @all_cursor INTO @meetingid
	end 
	CLOSE @all_cursor
	DEALLOCATE @all_cursor 
end
go


CREATE TRIGGER [Tri_U_workflow_createlist] ON [HrmResource] WITH ENCRYPTION
FOR INSERT, UPDATE, DELETE 
AS
Declare @workflowid int,
	@type int,
 	@objid int,
	@level_n int,
	@userid int,
	@all_cursor cursor,
	@detail_cursor cursor

delete from workflow_createrlist

SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR				
select workflowid,type,objid,level_n from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid

OPEN @all_cursor 
FETCH NEXT FROM @all_cursor INTO @workflowid ,	@type ,@objid ,@level_n
WHILE @@FETCH_STATUS = 0 
begin 
	if @type=1 
	begin
		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
		select id from HrmResource where departmentid = @objid and seclevel >= @level_n

		OPEN @detail_cursor 
		FETCH NEXT FROM @detail_cursor INTO @userid
		WHILE @@FETCH_STATUS = 0 
		begin 
			insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'0')
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
			insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'0')
			FETCH NEXT FROM @detail_cursor INTO @userid
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor  
	end
	else if @type=3
	begin
		insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@objid,'0')
	end
	else if @type=4
	begin
		insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,'-1',@level_n) 
	end
	else if @type=20
	begin
		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR	
		select id  from CRM_CustomerInfo where  seclevel >= @level_n and type = @objid			

		OPEN @detail_cursor 
		FETCH NEXT FROM @detail_cursor INTO @userid
		WHILE @@FETCH_STATUS = 0 
		begin 
			insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'1')
			FETCH NEXT FROM @detail_cursor INTO @userid
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor  
	end
	else if @type=21
	begin
		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR	
		select id  from CRM_CustomerInfo where  seclevel >= @level_n and status = @objid			

		OPEN @detail_cursor 
		FETCH NEXT FROM @detail_cursor INTO @userid
		WHILE @@FETCH_STATUS = 0 
		begin 
			insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'1')
			FETCH NEXT FROM @detail_cursor INTO @userid
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor  
	end
	else if @type=22
	begin
		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR	
		select id  from CRM_CustomerInfo where  seclevel >= @level_n and department = @objid			

		OPEN @detail_cursor 
		FETCH NEXT FROM @detail_cursor INTO @userid
		WHILE @@FETCH_STATUS = 0 
		begin 
			insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'1')
			FETCH NEXT FROM @detail_cursor INTO @userid
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor  
	end
	else if @type=25
	begin
		insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,'-2',@level_n) 
	end
	else if @type=30
	begin
		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
		select id from HrmResource where subcompanyid1 = @objid and seclevel >= @level_n

		OPEN @detail_cursor 
		FETCH NEXT FROM @detail_cursor INTO @userid
		WHILE @@FETCH_STATUS = 0 
		begin 
			insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'0')
			FETCH NEXT FROM @detail_cursor INTO @userid
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor
	end
	FETCH NEXT FROM @all_cursor INTO @workflowid ,	@type ,@objid ,@level_n
end 
CLOSE @all_cursor 
DEALLOCATE @all_cursor  

go

CREATE TRIGGER [Tri_URole_workflow_createlist] ON [HrmRoleMembers] WITH ENCRYPTION
FOR INSERT, UPDATE, DELETE 
AS
Declare @workflowid int,
	@type int,
 	@objid int,
	@level_n int,
	@userid int,
	@all_cursor cursor,
	@detail_cursor cursor

delete from workflow_createrlist

SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR				
select workflowid,type,objid,level_n from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid

OPEN @all_cursor 
FETCH NEXT FROM @all_cursor INTO @workflowid ,	@type ,@objid ,@level_n
WHILE @@FETCH_STATUS = 0 
begin 
	if @type=1 
	begin
		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
		select id from HrmResource where departmentid = @objid and seclevel >= @level_n

		OPEN @detail_cursor 
		FETCH NEXT FROM @detail_cursor INTO @userid
		WHILE @@FETCH_STATUS = 0 
		begin 
			insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'0')
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
			insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'0')
			FETCH NEXT FROM @detail_cursor INTO @userid
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor  
	end
	else if @type=3
	begin
		insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@objid,'0')
	end
	else if @type=4
	begin
		insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,'-1',@level_n) 
	end
	else if @type=20
	begin
		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR	
		select id  from CRM_CustomerInfo where  seclevel >= @level_n and type = @objid			

		OPEN @detail_cursor 
		FETCH NEXT FROM @detail_cursor INTO @userid
		WHILE @@FETCH_STATUS = 0 
		begin 
			insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'1')
			FETCH NEXT FROM @detail_cursor INTO @userid
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor  
	end
	else if @type=21
	begin
		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR	
		select id  from CRM_CustomerInfo where  seclevel >= @level_n and status = @objid			

		OPEN @detail_cursor 
		FETCH NEXT FROM @detail_cursor INTO @userid
		WHILE @@FETCH_STATUS = 0 
		begin 
			insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'1')
			FETCH NEXT FROM @detail_cursor INTO @userid
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor  
	end
	else if @type=22
	begin
		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR	
		select id  from CRM_CustomerInfo where  seclevel >= @level_n and department = @objid			

		OPEN @detail_cursor 
		FETCH NEXT FROM @detail_cursor INTO @userid
		WHILE @@FETCH_STATUS = 0 
		begin 
			insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'1')
			FETCH NEXT FROM @detail_cursor INTO @userid
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor  
	end
	else if @type=25
	begin
		insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,'-2',@level_n) 
	end
	else if @type=30
	begin
		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
		select id from HrmResource where subcompanyid1 = @objid and seclevel >= @level_n

		OPEN @detail_cursor 
		FETCH NEXT FROM @detail_cursor INTO @userid
		WHILE @@FETCH_STATUS = 0 
		begin 
			insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'0')
			FETCH NEXT FROM @detail_cursor INTO @userid
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor
	end
	FETCH NEXT FROM @all_cursor INTO @workflowid ,	@type ,@objid ,@level_n
end 
CLOSE @all_cursor 
DEALLOCATE @all_cursor  

go

CREATE TRIGGER [Tri_UCRM_workflow_createlist] ON [CRM_CustomerInfo] WITH ENCRYPTION
FOR INSERT, UPDATE, DELETE 
AS
Declare @workflowid int,
	@type int,
 	@objid int,
	@level_n int,
	@userid int,
	@all_cursor cursor,
	@detail_cursor cursor

delete from workflow_createrlist

SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR				
select workflowid,type,objid,level_n from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid

OPEN @all_cursor 
FETCH NEXT FROM @all_cursor INTO @workflowid ,	@type ,@objid ,@level_n
WHILE @@FETCH_STATUS = 0 
begin 
	if @type=1 
	begin
		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
		select id from HrmResource where departmentid = @objid and seclevel >= @level_n

		OPEN @detail_cursor 
		FETCH NEXT FROM @detail_cursor INTO @userid
		WHILE @@FETCH_STATUS = 0 
		begin 
			insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'0')
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
			insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'0')
			FETCH NEXT FROM @detail_cursor INTO @userid
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor  
	end
	else if @type=3
	begin
		insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@objid,'0')
	end
	else if @type=4
	begin
		insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,'-1',@level_n) 
	end
	else if @type=20
	begin
		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR	
		select id  from CRM_CustomerInfo where  seclevel >= @level_n and type = @objid			

		OPEN @detail_cursor 
		FETCH NEXT FROM @detail_cursor INTO @userid
		WHILE @@FETCH_STATUS = 0 
		begin 
			insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'1')
			FETCH NEXT FROM @detail_cursor INTO @userid
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor  
	end
	else if @type=21
	begin
		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR	
		select id  from CRM_CustomerInfo where  seclevel >= @level_n and status = @objid			

		OPEN @detail_cursor 
		FETCH NEXT FROM @detail_cursor INTO @userid
		WHILE @@FETCH_STATUS = 0 
		begin 
			insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'1')
			FETCH NEXT FROM @detail_cursor INTO @userid
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor  
	end
	else if @type=22
	begin
		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR	
		select id  from CRM_CustomerInfo where  seclevel >= @level_n and department = @objid			

		OPEN @detail_cursor 
		FETCH NEXT FROM @detail_cursor INTO @userid
		WHILE @@FETCH_STATUS = 0 
		begin 
			insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'1')
			FETCH NEXT FROM @detail_cursor INTO @userid
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor  
	end
	else if @type=25
	begin
		insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,'-2',@level_n) 
	end
	else if @type=30
	begin
		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
		select id from HrmResource where subcompanyid1 = @objid and seclevel >= @level_n

		OPEN @detail_cursor 
		FETCH NEXT FROM @detail_cursor INTO @userid
		WHILE @@FETCH_STATUS = 0 
		begin 
			insert into workflow_createrlist(workflowid,userid,usertype) values(@workflowid,@userid,'0')
			FETCH NEXT FROM @detail_cursor INTO @userid
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor
	end
	FETCH NEXT FROM @all_cursor INTO @workflowid ,	@type ,@objid ,@level_n
end 
CLOSE @all_cursor 
DEALLOCATE @all_cursor  

go

