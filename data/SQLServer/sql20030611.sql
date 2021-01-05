

/*  以下是关于陈英杰外部用户接口的的脚本*/
   

create table ycuser
(id int not null,
 loginid varchar(60) null,
 logintype int default(1))
go



insert into ycuser (id,loginid,logintype) values(1,'gmanager',1)
go
insert into ycuser (id,loginid,logintype) values(2,'sysadmin',1)
go

create procedure Ycuser_Insert
(@id_1 int,
 @loginid_2 varchar(60),
 @logintype_3 int,
 @flag int output, @msg varchar(60) output)
as
declare @numcount int
select   @numcount = count(*)  from ycuser where id= @id_1
if @numcount =0 
begin
insert into ycuser
(id,
 loginid,
 logintype)
values
(@id_1,
 @loginid_2,
 @logintype_3)
end
go

create procedure Ycuser_Update
(@id_1 int,
 @loginid_2 varchar(60),
 @logintype_3 int,
 @flag int output, @msg varchar(60) output)
as update ycuser set 
 loginid = @loginid_2,
 logintype = @logintype_3
where 
 id = @id_1
go

create procedure Ycuser_Delete
(@id_1 int,
 @flag int output, @msg varchar(60) output)
as delete ycuser
where 
 id = @id_1
go

insert into HtmlLabelIndex (id,indexdesc) values (7181,'外部系统用户')
go
insert into HtmlLabelInfo (indexid,labelname,languageid) values (7181,'外部系统用户',7)
go
insert into HtmlLabelInfo (indexid,labelname,languageid) values (7181,'OtherSystemUser',8)
go

insert into SystemLogItem (itemid,lableid,itemdesc) values(84,7181,'外部系统用户')
go

alter procedure Ycuser_Insert
(@id_1 int,
 @loginid_2 varchar(60),
 @logintype_3 int,
 @flag int output, @msg varchar(60) output)
as
declare @numcount int
select   @numcount = count(*)  from ycuser where id= @id_1 
if @numcount =0 
begin
declare @count int
select   @count = count(*)  from ycuser where  loginid = @loginid_2
if @count =0 
begin
insert into ycuser
(id,
 loginid,
 logintype)
values
(@id_1,
 @loginid_2,
 @logintype_3)
end
else
begin
select 1
end
end
go

alter procedure Ycuser_Update
(@id_1 int,
 @loginid_2 varchar(60),
 @logintype_3 int,
 @flag int output, @msg varchar(60) output)
as 
declare @numcount int
select   @numcount = count(*)  from ycuser where loginid = @loginid_2 and id <> @id_1
if @numcount =0 
begin
update ycuser set 
 loginid = @loginid_2,
 logintype = @logintype_3
where 
 id = @id_1
end
else
begin
select 1
end
go


/*以下是关于王家煌外部用户接口的的脚本*/


alter TRIGGER [Tri_U_CptCapitalAssortment] ON CptCapitalAssortment WITH ENCRYPTION
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

alter TRIGGER [Tri_Update_bill_HrmTime] ON Prj_TaskProcess WITH ENCRYPTION
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

alter TRIGGER [Tri_U_bill_HrmTimeByMeet1] ON Meeting WITH ENCRYPTION
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

alter TRIGGER [Tri_U_bill_HrmTimeByMeet2] ON Meeting_Member2 WITH ENCRYPTION
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


alter TRIGGER [Tri_U_workflow_createlist] ON [HrmResource] WITH ENCRYPTION
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

alter TRIGGER [Tri_URole_workflow_createlist] ON [HrmRoleMembers] WITH ENCRYPTION
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

alter TRIGGER [Tri_UCRM_workflow_createlist] ON [CRM_CustomerInfo] WITH ENCRYPTION
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




/*以下是关于谭小鹏ecology产品开发项目目录权限以及多级目录、增加删除功能的脚本——相关文档《ecology产品开发项目录权限补充提交测试报告》*/


/*  subcategoryid代表上级分目录，如果该字段为-1则表示它的上级目录是主目录
    seccategoryids代表该分目录下的所有子目录的id列表，系统在增加子目录和删除子目录的同时也会自动修改这个字段的值 */
ALTER TABLE DocSubCategory WITH NOCHECK ADD
    subcategoryid int DEFAULT -1 NOT NULL,
    seccategoryids varchar(500) NULL
go



ALTER TABLE DocSecCategoryShare Alter column
    sharetype int NULL
go



/*  自动根据子目录的分目录字段查找分目录下的所有子目录并设置seccategoryids字段的值，
本过程用于旧系统升级后设置seccategoryids字段的初始值 */
CREATE PROCEDURE Doc_SetSecIdsFromOldTable as 
declare @subid_1 int
declare @secid_1 int
declare @secids_1 varchar(500)
declare subcategory_cur cursor for
select id from DocSubCategory

open subcategory_cur
fetch next from subcategory_cur into @subid_1

while @@fetch_status = 0 begin
    declare seccategory_cur cursor for
    select id from DocSecCategory where subcategoryid = @subid_1
    
    set @secids_1 = ''
    
    open seccategory_cur
    fetch next from seccategory_cur into @secid_1
    
    while @@fetch_status = 0 begin
        set @secids_1 = @secids_1 + convert(varchar, @secid_1) + ','
        fetch next from seccategory_cur into @secid_1
    end
    
    close seccategory_cur
    deallocate seccategory_cur
    
    if @secids_1 <> '' begin
        set @secids_1 = substring(@secids_1, 1, len(@secids_1)-1)
    end
    
    update DocSubCategory set seccategoryids = @secids_1 where id = @subid_1
    
    fetch next from subcategory_cur into @subid_1
end

close subcategory_cur
deallocate subcategory_cur
GO

/*  取得分目录或子目录的所有上级分目录id，名称，按照层次关系自顶向下排 */
CREATE PROCEDURE Doc_GetOrderedFatherSubid(@mainid_1 int, @categorytype_1 int, @flag integer output , @msg varchar(80) output) as 
declare @fatherid_1 int, @fatherid1_1 int
declare @fathername_1 varchar(200)
declare @orderid_1 int

create table #temp(orderid int, subcategoryid int, subcategoryname varchar(200))
set @orderid_1 = 0

if @categorytype_1 = 1 begin
    select @fatherid_1=subcategoryid from DocSubCategory where id = @mainid_1
end
else if @categorytype_1 = 2 begin
    select @fatherid_1=subcategoryid from DocSecCategory where id = @mainid_1
    if @fatherid_1 is null set @fatherid_1 = -1
    if @fatherid_1 = 0 set @fatherid_1 = -1
end
else begin
    set @fatherid_1 = -1
end 

while @fatherid_1 <> -1 begin
    select @fatherid1_1=subcategoryid,@fathername_1=categoryname from DocSubCategory where id = @fatherid_1
    insert into #temp values(@orderid_1, @fatherid_1, @fathername_1)
    set @fatherid_1 = @fatherid1_1
    set @orderid_1 = @orderid_1 + 1
end
select orderid, subcategoryid, subcategoryname from #temp order by orderid desc
GO

/* 将一个子目录的id加到它所有上级分目录的seccategoryids列表中去 */
CREATE PROCEDURE Doc_AddSecidToFather(@secid_1 int, @flag integer output , @msg varchar(80) output) as 
declare @fatherid_1 int, @fatherid1_1 int
declare @secid_ch_1 varchar(10)
declare @secids_1 varchar(500)

set @secid_ch_1 = convert(varchar, @secid_1)
select @fatherid_1=subcategoryid from DocSecCategory where id = @secid_1
if @fatherid_1 is null set @fatherid_1 = -1
if @fatherid_1 = 0 set @fatherid_1 = -1 

while @fatherid_1 <> -1 begin
    select @fatherid1_1=subcategoryid, @secids_1=seccategoryids from DocSubCategory where id = @fatherid_1
    if (@secids_1 is null) or (@secids_1 = '') begin
        update DocSubCategory set seccategoryids = @secid_ch_1 where id = @fatherid_1
    end
    else if (charindex(@secid_ch_1, @secids_1)=0) begin
        update DocSubCategory set seccategoryids = @secids_1+','+@secid_ch_1 where id = @fatherid_1
    end
    set @fatherid_1 = @fatherid1_1
end
GO

/* 将一个子目录的id从它所有上级分目录的seccategoryids列表中删除 */
CREATE PROCEDURE Doc_DeleteSecidFromFather(@secid_1 int, @flag integer output , @msg varchar(80) output) as 
declare @fatherid_1 int, @fatherid1_1 int
declare @secid_ch_1 varchar(10)
declare @secids_1 varchar(500)

set @secid_ch_1 = ','+convert(varchar, @secid_1)+','
select @fatherid_1=subcategoryid from DocSecCategory where id = @secid_1
if @fatherid_1 is null set @fatherid_1 = -1
if @fatherid_1 = 0 set @fatherid_1 = -1 

while @fatherid_1 <> -1 begin
    select @fatherid1_1=subcategoryid, @secids_1=seccategoryids from DocSubCategory where id = @fatherid_1
    if (@secids_1 is not null) and (@secids_1 <> '') begin
        set @secids_1 = ','+@secids_1+','
        if charindex(@secid_ch_1, @secids_1) <> 0 begin
            set @secids_1 = replace(@secids_1, @secid_ch_1, ',')
            if @secids_1 = ',' begin
                set @secids_1 = ''
            end
            else begin
                set @secids_1 = substring(@secids_1, 2, len(@secids_1)-2)
            end
            update DocSubCategory set seccategoryids = @secids_1 where id = @fatherid_1
        end
    end
    set @fatherid_1 = @fatherid1_1
end
GO

/* 取得具有权限的所有目录的id，类型，名称，上级目录id，上级目录类型 */
CREATE PROCEDURE Doc_GetPermittedCategory(@userid_1 int, @usertype_1 int, @seclevel_1 int, @operationcode_1 int, @flag integer output , @msg varchar(80) output) as 

create table #temp(categoryid int, categorytype int, superdirid int, superdirtype int, categoryname varchar(200), orderid int)

declare @secdirid_1 int
declare @secdirname_1 varchar(200)
declare @subdirid_1 int, @subdirid1_1 int, @superdirid_1 int, @superdirtype_1 int, @maindirid_1 int
declare @subdirname_1 varchar(200)
declare @count_1 int
declare @orderid_1 int

if @usertype_1 = 0 begin
    if @operationcode_1 = 0 begin
        declare secdir_cursor cursor for
        select id mainid, categoryname, subcategoryid from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=@userid_1 and usertype=@usertype_1 and dirtype=2 and createdoc>0)
    end
    else if @operationcode_1 = 1 begin
        declare secdir_cursor cursor for
        select id mainid, categoryname, subcategoryid from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=@userid_1 and usertype=@usertype_1 and dirtype=2 and createdir>0)
    end
    else if @operationcode_1 = 2 begin
        declare secdir_cursor cursor for
        select id mainid, categoryname, subcategoryid from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=@userid_1 and usertype=@usertype_1 and dirtype=2 and movedoc>0)
    end
    else if @operationcode_1 = 3 begin
        declare secdir_cursor cursor for
        select id mainid, categoryname, subcategoryid from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=@userid_1 and usertype=@usertype_1 and dirtype=2 and copydoc>0)
    end
end
else begin
    declare secdir_cursor cursor for
    select id mainid, categoryname, subcategoryid from DocSecCategory where id in (select distinct dirid mainid from DirAccessControlList where dirtype=2 and operationcode=@operationcode_1 and ((permissiontype=3 and seclevel<=@seclevel_1) or (permissiontype=4 and usertype=@usertype_1 and seclevel<=@seclevel_1)))
end

open secdir_cursor
fetch next from secdir_cursor
into @secdirid_1, @secdirname_1, @subdirid_1

while @@fetch_status = 0 begin
    insert into #temp values(@secdirid_1, 2, @subdirid_1, 1, @secdirname_1, 0)

    if @subdirid_1 is null set @subdirid_1 = -1
    if @subdirid_1 = 0 set @subdirid_1 = -1
    
    while @subdirid_1 <> -1 begin
        select @subdirid1_1=subcategoryid,@subdirname_1=categoryname,@superdirid_1=subcategoryid,@maindirid_1=maincategoryid from DocSubCategory where id = @subdirid_1
        if @superdirid_1 = -1 begin
            set @superdirid_1 = @maindirid_1
            set @superdirtype_1 = 0
        end
        else begin
            set @superdirtype_1 = 1
        end
        set @count_1 = 0
        select @count_1=count(categoryid) from #temp where categoryid = @subdirid_1 and categorytype = 1
        if @count_1 <= 0
            insert into #temp values(@subdirid_1, 1, @superdirid_1, @superdirtype_1, @subdirname_1, 0)
        set @subdirid_1 = @subdirid1_1
    end
    
    fetch next from secdir_cursor
    into @secdirid_1, @secdirname_1, @subdirid_1
end
close secdir_cursor
deallocate secdir_cursor

declare maindir_cursor cursor for
select id, categoryname, categoryorder from DocMainCategory where id in (select distinct superdirid from #temp where superdirtype = 0)

open maindir_cursor

fetch next from maindir_cursor
into @subdirid_1, @subdirname_1, @orderid_1

while @@fetch_status = 0 begin
    insert into #temp values(@subdirid_1, 0, -1, -1, @subdirname_1, @orderid_1)
    fetch next from maindir_cursor
    into @subdirid_1, @subdirname_1, @orderid_1
end
close maindir_cursor
deallocate maindir_cursor

select * from #temp order by orderid
GO


/* 修改检查是否拥有权限的存储过程，附加一个参数用于输出检查结果 */
create PROCEDURE Doc_DirAcl_CheckPermissionEx1(@dirid_1 int, @dirtype_1 int, @userid_1 int, @usertype_1 int, @seclevel_1 int, @operationcode_1 int, @haspermission_1 int output, @flag int output, @msg varchar(80) output)  AS

declare @count_1 int
declare @result int

set @result = 0

if @usertype_1 = 0 begin
    if @operationcode_1 = 0 begin
        set @count_1 = (select createdoc from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1)
    end
    else if @operationcode_1 = 1 begin
        set @count_1 = (select createdir from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1)
    end
    else if @operationcode_1 = 2 begin
        set @count_1 = (select movedoc from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1)
    end
    else if @operationcode_1 = 3 begin
        select @count_1 = copydoc from DirAccessPermission where dirid = @dirid_1 and dirtype = @dirtype_1 and userid = @userid_1 and usertype = @usertype_1
    end
end
else begin
    set @count_1 = (select count(mainid) from DirAccessControlList where dirid=@dirid_1 and dirtype=@dirtype_1 and operationcode=@operationcode_1 and ((permissiontype=3 and seclevel<=@seclevel_1) or (permissiontype=4 and usertype=@usertype_1 and seclevel<=@seclevel_1)))
end

if (not (@count_1 is null)) and (@count_1 > 0) begin
    set @result = 1
end

set @haspermission_1 = @result

if @@error<>0 begin 
    set @flag=1 
    set @msg='检查目录访问权限成功' 
    return end 
else begin 
    set @flag=0 
    set @msg='检查目录访问权限失败' 
    return 
end

GO

/* 用于有继承性的权限检查，本过程首先检查目录本身是否有权限，其次检查所在主目录是否有权限，最后检查所有上级分目录是否有权限 */
create PROCEDURE Doc_DirAcl_CheckPermissionEx(@dirid_1 int, @dirtype_1 int, @userid_1 int, @usertype_1 int, @seclevel_1 int, @operationcode_1 int, @flag int output, @msg varchar(80) output)  AS
declare @result_1 int
declare @mainid_1 int
/* 检查目录本身是否有权限 */
execute Doc_DirAcl_CheckPermissionEx1 @dirid_1, @dirtype_1, @userid_1, @usertype_1, @seclevel_1, @operationcode_1, @result_1 output, 1, 1

if @result_1 <> 1 begin
    declare @fatherid_1 int, @fatherid1_1 int
    
    /* 取得上级目录 */
    if @dirtype_1 = 1 begin
        select @fatherid_1=subcategoryid from DocSubCategory where id = @dirid_1
    end
    else if @dirtype_1 = 2 begin
        select @fatherid_1=subcategoryid from DocSecCategory where id = @dirid_1
        if @fatherid_1 is null set @fatherid_1 = -1
        if @fatherid_1 = 0 set @fatherid_1 = -1
    end
    else begin
        set @fatherid_1 = -1
    end 
    
    /* 检查主目录是否有权限 */
    if @dirtype_1 = 1 begin
       select @mainid_1=maincategoryid from DocSubCategory where id = @dirid_1
       execute Doc_DirAcl_CheckPermissionEx1 @mainid_1, 0, @userid_1, @usertype_1, @seclevel_1, @operationcode_1, @result_1 output, 1, 1
       if @result_1=1 begin
           set @fatherid_1 = -1
       end
    end
    else if @dirtype_1 = 2 and @fatherid_1 <> -1 begin
       select @mainid_1=maincategoryid from DocSubCategory where id = @fatherid_1
       execute Doc_DirAcl_CheckPermissionEx1 @mainid_1, 0, @userid_1, @usertype_1, @seclevel_1, @operationcode_1, @result_1 output, 1, 1
       if @result_1=1 begin
           set @fatherid_1 = -1
       end
    end
    
    /* 自下而上依次检查各级分目录是否有权限 */
    while @fatherid_1 <> -1 begin
        execute Doc_DirAcl_CheckPermissionEx1 @fatherid_1, 1, @userid_1, @usertype_1, @seclevel_1, @operationcode_1, @result_1 output, 1, 1
        if @result_1 <> 1 begin
            select @fatherid1_1=subcategoryid from DocSubCategory where id = @fatherid_1
            set @fatherid_1 = @fatherid1_1
        end
        else begin
            set @fatherid_1 = -1
        end
    end
end

select @result_1 result

if @@error<>0 begin 
    set @flag=1 
    set @msg='检查目录访问权限成功' 
    return end 
else begin 
    set @flag=0 
    set @msg='检查目录访问权限失败' 
    return 
end

go





/* 必须先执行proc.sql，仅适用于旧系统升级时使用 */
exec Doc_SetSecIdsFromOldTable






/* 这是关于杨国生的工作计划提交测试报告的脚本   
  \sql\for SQLServer\yangguosheng\proc_2003-06-16.sql
\sql\for SQLServer\yangguosheng\table_2003-06-16.sql  */




alter table WorkPlan alter column description  text
GO



ALTER  PROCEDURE WorkPlan_Insert 
	(@type_n_1  [char] (1)   ,
	@name_1  [varchar] (100)   ,
	@resourceid_1  [varchar] (200)   ,
	@begindate_1  [char] (10)   ,
	@begintime_1  [char] (8)   ,
	@enddate_1  [char] (10)   ,
	@endtime_1  [char] (8)   ,	
	@color_1 [char] (6)  ,
	@description_1  [text]    ,
	@requestid_1  [varchar] (100)   ,
	@projectid_1  [varchar] (100)   ,
	@crmid_1  [varchar] (100)   ,
	@docid_1  [varchar] (100)   ,
	@meetingid_1  [varchar] (100)   ,
	@status_1  [char] (1)   ,
	@isremind_1 [int]  ,
	@waketime_1 [int]   ,	
	@createrid_1 [int]   ,
	@createdate_1 [char] (10)   ,
	@createtime_1 [char] (8) ,
	@deleted_1 [char] (1)   ,
	@flag integer output,
	@msg varchar(80) output)

AS INSERT INTO [WorkPlan] 
	(type_n ,
	name  ,
	resourceid ,
	begindate ,
	begintime ,
	enddate ,
	endtime  ,
	color ,
	description ,
	requestid  ,
	projectid ,
	crmid  ,
	docid  ,
	meetingid ,
	status  ,
	isremind  ,
	waketime  ,	
	createrid  ,
	createdate  ,
	createtime ,
	deleted) 
 
VALUES 
	(@type_n_1 ,
	@name_1  ,
	@resourceid_1 ,
	@begindate_1 ,
	@begintime_1 ,
	@enddate_1 ,
	@endtime_1  ,
	@color_1 ,
	@description_1 ,
	@requestid_1  ,
	@projectid_1 ,
	@crmid_1  ,
	@docid_1  ,
	@meetingid_1 ,
	@status_1  ,
	@isremind_1  ,
	@waketime_1  ,	
	@createrid_1  ,
	@createdate_1  ,
	@createtime_1 ,
	@deleted_1 )
select top 1 * from WorkPlan order by id desc

GO

ALTER  PROCEDURE WorkPlan_Update
	(
	@id_1 	[int] ,	
	@type_n_1  [char] (1)   ,
	@name_1  [varchar] (100)   ,
	@resourceid_1  [varchar] (200)   ,
	@begindate_1  [char] (10)   ,
	@begintime_1  [char] (8)   ,
	@enddate_1  [char] (10)   ,
	@endtime_1  [char] (8)   ,	
	@color_1 [char] (6)  ,
	@description_1  [text]    ,
	@requestid_1  [varchar] (100)   ,
	@projectid_1  [varchar] (100)   ,
	@crmid_1  [varchar] (100)   ,
	@docid_1  [varchar] (100)   ,
	@meetingid_1  [varchar] (100)   ,
	@isremind_1 [int]  ,
	@waketime_1 [int]   ,	
	@flag integer output,
	@msg varchar(80) output)

AS UPDATE WorkPlan SET 
	 type_n = @type_n_1 , 
	 name = @name_1, 
	 resourceid = @resourceid_1,
	 begindate = @begindate_1, 
	 begintime = @begintime_1,
	 enddate = @enddate_1 , 
	 endtime = @endtime_1, 
	 color = @color_1 ,
	 description = @description_1 ,
	 requestid = @requestid_1 , 
	 projectid = @projectid_1 , 
	 crmid = @crmid_1 , 
	 docid = @docid_1 , 
	 meetingid = @meetingid_1 ,
	 isremind = @isremind_1 , 
	 waketime = @waketime_1 	 
	 where id = @id_1 

GO



/*以下是陈英杰的人力资源工作时间维护－复制提交测试报告的脚本*/


alter procedure SequenceIndexRes_Init
as 
declare @id_1 integer, @resid_2 integer, @curid_3 integer
select @id_1=max(id) from HrmResource
select @resid_2 = max(id) from HrmCareerApply
if @resid_2 is null set @resid_2 = 0
if @id_1 is null set @id_1 = 0
if( @id_1>@resid_2) set @curid_3= @id_1+1
else  set @curid_3 = @resid_2+1
update SequenceIndex set currentid = @curid_3 where indexdesc='resourceid'
go

exec SequenceIndexRes_Init
go

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values(3050,'人力资源时间表复制','HrmResourceScheduleCopy:Copy',36)
go

 
/*以下是杨国生关于《ecology产品开发工作流费用报销出口条件设置提交测试报告》的脚本*/
update workflow_browserurl set browserurl = '/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?sqlwhere=where feetype=convert(char(1) ,1)' where tablename = 'FnaBudgetfeeType' 
GO



