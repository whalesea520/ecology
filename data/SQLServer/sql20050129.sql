create table Voting(
    id  int  IDENTITY(1,1) primary key CLUSTERED,
    subject     varchar(100),
    detail      text,
    createrid  int,
    createdate  char(10),
    createtime  char(8),
    approverid  int,
    approvedate char(10),
    approvetime char(8),
    begindate   char(10),
    begintime   char(8),
    enddate     char(10),
    endtime     char(8),
    isanony     int,
    docid       int,
    crmid       int,
    projid      int,
    requestid   int,
    votingcount int,
    status      int           /*0,待审批 1,正常 2,结束 3,暂停  4,延期*/
)
go

create table VotingQuestion(
    id  int  IDENTITY(1,1) primary key CLUSTERED,
    subject     varchar(100),
    description varchar(255),
    votingid    int,
    ismulti     int,
    isother     int,
    questioncount   int
)
go

create table VotingOption(
    id  int  IDENTITY(1,1) primary key CLUSTERED,
    votingid    int,
    questionid  int,
    description varchar(255),
    optioncount int
)
go

create table VotingResource(
    votingid    int,
    questionid  int,
    optionid    int,
    resourceid      int,
    operatedate char(10),
    operatetime char(8)
)
go

create table VotingResourceRemark(
    votingid    int,
    questionid  int,
    resourceid  int,
    useranony   int,
    otherinput   varchar(255),
    operatedate char(10),
    operatetime char(8)
)
go

create table VotingRemark(
    votingid    int,
    resourceid  int,
    useranony   int,
    remark      text,
    operatedate char(10),
    operatetime char(8)
)
go

create table VotingShare(
    id  int  IDENTITY(1,1) primary key CLUSTERED,
    votingid    int,
    sharetype   int,   /*1人力资源2分部3部门4角色5所有人*/
    resourceid      int,
    subcompanyid    int,
    departmentid    int,
    roleid          int,
    seclevel     int,
    rolelevel   int,
    foralluser  int
)
go

create table VotingShareDetail(
    votingid    int,
    resourceid  int
)
go

create table VotingMaintDetail(
    id  int  IDENTITY(1,1) primary key CLUSTERED,
    createrid   int,
    approverid  int
)
go


CREATE PROCEDURE Voting_SelectAll
(@flag integer output,
 @msg varchar(80) output)
AS 
	select * from voting order by begindate desc,begintime desc
go

CREATE PROCEDURE Voting_SelectByStatus
(@status     int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	select * from voting where status=@status order by begindate desc,begintime desc
go

CREATE PROCEDURE Voting_SelectByID
(@id     int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	select * from voting where id=@id
go

CREATE PROCEDURE Voting_Insert
(@subject   varchar(100),
 @detail    text,
 @createrid int,
 @createdate    char(10),
 @createtime    char(8),
 @approverid    int,
 @approvedate   char(10),
 @approvetime   char(8),
 @begindate     char(10),
 @begintime     char(8),
 @enddate       char(10),
 @endtime       char(8),
 @isanony       int,
 @docid         int,
 @crmid     int,
 @projid    int,
 @requestid int,
 @votingcount   int,
 @status        int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	insert into voting (subject,detail,createrid,createdate,createtime,approverid,approvedate,approvetime,begindate,begintime,enddate,endtime,isanony,docid,crmid,projid,requestid,votingcount,status)
	values (@subject,@detail,@createrid,@createdate,@createtime,@approverid,@approvedate,@approvetime,@begindate,@begintime,@enddate,@endtime,@isanony,@docid,@crmid,@projid,@requestid,@votingcount,@status)
	
	select max(id) from voting 
go

CREATE PROCEDURE Voting_Update
(@id    int,
 @subject   varchar(100),
 @detail    text,
 @createrid int,
 @createdate    char(10),
 @createtime    char(8),
 @approverid    int,
 @approvedate   char(10),
 @approvetime   char(8),
 @begindate     char(10),
 @begintime     char(8),
 @enddate       char(10),
 @endtime       char(8),
 @isanony       int,
 @docid         int,
 @crmid     int,
 @projid    int,
 @requestid int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	update voting set
	subject=@subject,
	detail=@detail,
	createrid=@createrid,
	createdate=@createdate,
	createtime=@createtime,
	approverid =@approverid,
	approvedate=@approvedate,
	approvetime=@approvetime,
	begindate=@begindate,
	begintime=@begintime,
	enddate=@enddate,
	endtime=@endtime,
	isanony=@isanony,
	docid=@docid,
	crmid=@crmid,
	projid=@projid,
	requestid=@requestid
	where id=@id
go

CREATE PROCEDURE Voting_Delete
(@id    int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	delete from voting where id=@id
go

CREATE PROCEDURE Voting_UpdateStatus
(@id    int,
 @status    int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	update voting set status=@status where id=@id
go

CREATE PROCEDURE VotingQuestion_SelectByVoting
(@votingid  int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	select * from votingquestion where votingid=@votingid order by id
go

CREATE PROCEDURE VotingQuestion_SelectByID
(@id  int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	select * from votingquestion where id=@id order by id
go

CREATE PROCEDURE VotingQuestion_Insert
(@votingid  int,
 @subject   varchar(100),
 @description   varchar(255),
 @ismulti       int,
 @isother       int,
 @questioncount int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	insert into votingquestion (votingid,subject,description,ismulti,isother,questioncount)
	values (@votingid,@subject,@description,@ismulti,@isother,@questioncount)
	
	select max(id) from votingquestion
go

CREATE PROCEDURE VotingQuestion_Update
(@id    int,
 @votingid  int,
 @subject   varchar(100),
 @description   varchar(255),
 @ismulti       int,
 @isother       int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	update votingquestion set
	votingid=@votingid,
	subject=@subject,
	description=@description,
	ismulti=@ismulti,
	isother=@isother
	where id=@id
go

CREATE PROCEDURE VotingQuestion_Delete
(@id    int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	delete from votingoption where questionid=@id
	delete from votingquestion where id=@id
go

CREATE PROCEDURE VotingOption_SelectByQuestion
(@questionid  int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	select * from votingoption where questionid=@questionid order by id
go

CREATE PROCEDURE VotingOption_SelectByID
(@id  int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	select * from votingoption where id=@id order by id
go

CREATE PROCEDURE VotingOption_Insert
(@votingid  int,
 @questionid    int,
 @description   varchar(255),
 @optioncount   int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	insert into votingoption (votingid,questionid,description,optioncount)
	values (@votingid,@questionid,@description,@optioncount)
    select max(id) from votingoption
go

CREATE PROCEDURE VotingOption_Update
(@id    int,
 @votingid  int,
 @questionid    int,
 @description   varchar(255),
 @flag integer output,
 @msg varchar(80) output)
AS 
	update votingoption set 
	votingid=@votingid,
	questionid=@questionid,
	description=@description
	where id=@id
go

CREATE PROCEDURE VotingOption_Delete
(@id    int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	delete from votingoption where id=@id
go

CREATE PROCEDURE VotingShare_SelectByVotingid
(@votingid    int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	select * from votingshare where votingid=@votingid
go

CREATE PROCEDURE VotingShare_SelectByID
(@id    int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	select * from votingshare where id=@id
go

CREATE PROCEDURE VotingShare_Insert
(@votingid    int,
 @sharetype     int,
 @resourceid      int,
 @subcompanyid  int,
 @departmentid  int,
 @roleid        int,
 @seclevel      int,
 @rolelevel     int,
 @foralluser    int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	insert into votingshare (votingid,sharetype,resourceid,subcompanyid,departmentid,roleid,seclevel,rolelevel,foralluser)
	values (@votingid,@sharetype,@resourceid,@subcompanyid,@departmentid,@roleid,@seclevel,@rolelevel,@foralluser)
	select max(id) from votingshare
go

CREATE PROCEDURE VotingShare_Delete
(@id    int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	delete from votingshare where id=@id
go

CREATE PROCEDURE VotingShareDetail_Update
(@votingid    int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	declare @shareid int,
	        @sharetype   int,
	        @resourceid  int,
	        @subcompanyid    int,
	        @departmentid    int,
	        @roleid      int,
	        @seclevel    int,
	        @rolelevel   int,
	        @foralluser  int,
	        @all_cursor cursor,
	        @detail_cursor cursor,
	        @userid int,
	        @count  int
	delete from votingsharedetail where votingid=@votingid
	
	SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR				
    select id,sharetype,resourceid,subcompanyid,departmentid,roleid,seclevel,rolelevel,foralluser from votingshare where votingid=@votingid
    OPEN @all_cursor 
    FETCH NEXT FROM @all_cursor INTO @shareid ,	@sharetype ,@resourceid ,@subcompanyid,@departmentid,@roleid,@seclevel,@rolelevel,@foralluser
    WHILE @@FETCH_STATUS = 0 
    begin 
        if @sharetype=1 
    	begin
    		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
    		select id from HrmResource where id = @resourceid and seclevel >= @seclevel
    		OPEN @detail_cursor 
    		FETCH NEXT FROM @detail_cursor INTO @userid
    		WHILE @@FETCH_STATUS = 0 
    		begin 
    			select @count=count(*) from votingsharedetail where votingid=@votingid and resourceid=@userid
    			if  @count=0
    			    insert into votingsharedetail values(@votingid,@userid)
    			FETCH NEXT FROM @detail_cursor INTO @userid
    		end 
    		CLOSE @detail_cursor
    		DEALLOCATE @detail_cursor  
    	end
    	
        if @sharetype=2 
    	begin
    		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
    		select id from HrmResource where subcompanyid1 = @subcompanyid and seclevel >= @seclevel
    		OPEN @detail_cursor 
    		FETCH NEXT FROM @detail_cursor INTO @userid
    		WHILE @@FETCH_STATUS = 0 
    		begin 
    			select @count=count(*) from votingsharedetail where votingid=@votingid and resourceid=@userid
    			if  @count=0
    			    insert into votingsharedetail values(@votingid,@userid)
    			FETCH NEXT FROM @detail_cursor INTO @userid
    		end 
    		CLOSE @detail_cursor
    		DEALLOCATE @detail_cursor  
    	end
        
        if @sharetype=3 
    	begin
    		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
    		select id from HrmResource where departmentid = @departmentid and seclevel >= @seclevel
    		OPEN @detail_cursor 
    		FETCH NEXT FROM @detail_cursor INTO @userid
    		WHILE @@FETCH_STATUS = 0 
    		begin 
    			select @count=count(*) from votingsharedetail where votingid=@votingid and resourceid=@userid
    			if  @count=0
    			    insert into votingsharedetail values(@votingid,@userid)
    			FETCH NEXT FROM @detail_cursor INTO @userid
    		end 
    		CLOSE @detail_cursor
    		DEALLOCATE @detail_cursor  
    	end
    	
    	if @sharetype=4 
    	begin
    		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
    		select resourceid from HrmRoleMembers where roleid = @roleid and rolelevel >= @rolelevel
    		OPEN @detail_cursor 
    		FETCH NEXT FROM @detail_cursor INTO @userid
    		WHILE @@FETCH_STATUS = 0 
    		begin 
    			select @count=count(*) from votingsharedetail where votingid=@votingid and resourceid=@userid
    			if  @count=0
    			    insert into votingsharedetail values(@votingid,@userid)
    			FETCH NEXT FROM @detail_cursor INTO @userid
    		end 
    		CLOSE @detail_cursor
    		DEALLOCATE @detail_cursor  
    	end
    	
    	if @sharetype=5 
    	begin
    		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
    		select id from HrmResource where seclevel >= @seclevel
    		OPEN @detail_cursor 
    		FETCH NEXT FROM @detail_cursor INTO @userid
    		WHILE @@FETCH_STATUS = 0 
    		begin 
    			select @count=count(*) from votingsharedetail where votingid=@votingid and resourceid=@userid
    			if  @count=0
    			    insert into votingsharedetail values(@votingid,@userid)
    			FETCH NEXT FROM @detail_cursor INTO @userid
    		end 
    		CLOSE @detail_cursor
    		DEALLOCATE @detail_cursor  
    	end
        FETCH NEXT FROM @all_cursor INTO @shareid ,	@sharetype ,@resourceid ,@subcompanyid,@departmentid,@roleid,@seclevel,@rolelevel,@foralluser
    end 
    CLOSE @all_cursor 
    DEALLOCATE @all_cursor  
go


CREATE PROCEDURE VotingResource_SelectByUser
(@votingid    int,
 @resourceid int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	select * from votingresource where votingid=@votingid and resourceid=@resourceid
go

CREATE PROCEDURE VotingResource_Insert
(@votingid    int,
 @questionid    int,
 @optionid   int,
 @resourceid int,
 @operatedate   char(10),
 @operatetime   char(8),
 @flag integer output,
 @msg varchar(80) output)
AS 
	declare @count int
	select @count=count(votingid) from votingresource where optionid=@optionid and resourceid=@resourceid
	if  @count=0
	begin
    	insert into votingresource (votingid,questionid,optionid,resourceid,operatedate,operatetime)
    	values (@votingid,@questionid,@optionid,@resourceid,@operatedate,@operatetime)
	end
go


CREATE PROCEDURE VotingResourceRemark_Insert
(@votingid    int,
 @questionid    int,
 @resourceid int,
 @useranony     int,
 @otherinput    varchar(255),
 @operatedate   char(10),
 @operatetime   char(8),
 @flag integer output,
 @msg varchar(80) output)
AS 
	insert into votingresourceremark (votingid,questionid,resourceid,useranony,otherinput,operatedate,operatetime)
	values (@votingid,@questionid,@resourceid,@useranony,@otherinput,@operatedate,@operatetime)
go

CREATE PROCEDURE VotingRemark_Insert
(@votingid    int,
 @resourceid int,
 @useranony     int,
 @remark    text,
 @operatedate   char(10),
 @operatetime   char(8),
 @flag integer output,
 @msg varchar(80) output)
AS 
	insert into votingremark (votingid,resourceid,useranony,remark,operatedate,operatetime)
	values (@votingid,@resourceid,@useranony,@remark,@operatedate,@operatetime)
go

CREATE PROCEDURE Voting_UpdateCount
(@votingid    int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	update voting set votingcount=votingcount+1 where id=@votingid
go

CREATE PROCEDURE VotingQuestion_UpdateCount
(@questionid    int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	update votingquestion set questioncount=questioncount+1 where id=@questionid
go

CREATE PROCEDURE VotingOption_UpdateCount
(@optionid    int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	update votingoption set optioncount=optioncount+1 where id = @optionid
go


CREATE PROCEDURE VotingMaintDetail_Insert
(@createrid    int,
 @approverid    int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	insert into votingmaintdetail (createrid,approverid)
	values (@createrid,@approverid)
go

CREATE PROCEDURE VotingMaintDetail_Delete
(@id    int,
 @flag integer output,
 @msg varchar(80) output)
AS 
	delete from  votingmaintdetail where id=@id
go

/*建新权限 调查维护权限*/

insert into SystemRights (id,rightdesc,righttype) values (458,'调查维护权限','1') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (458,8,'votingMaint','votingMaint') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (458,7,'调查维护权限','调查维护权限') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3149,'调查维护权限','Voting:Maint',458) 
GO
insert into SystemRightToGroup (groupid, rightid) values (2,458)
GO
insert into systemrightroles(rightid,roleid,rolelevel) values (458,3,2)
GO