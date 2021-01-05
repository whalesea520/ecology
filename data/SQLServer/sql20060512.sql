alter PROCEDURE workflow_CurrentOperator_I(
@requestid  int, @userid int, @groupid   int, @workflowid    int,
@workflowtype  int, @usertype  int, @isremark  char(1),
@nodeid  int,@agentorbyagentid  int,@agenttype  char(1),@showorder int, @groupdetailid int,
@flag integer output , @msg varchar(80) output)
AS
declare @workflowtype1 integer,
	@receivedate char(10),
    @receivetime char(8)

set @receivedate=convert(char(10),getdate(),20)
set @receivetime=convert(char(8),getdate(),108)

update workflow_currentoperator set islasttimes=0 where requestid=@requestid and userid=@userid and usertype = @usertype

if @workflowtype = ''
   begin
        select @workflowtype1 = workflowtype from workflow_base where id = @workflowid
        insert into workflow_currentoperator(requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,viewtype,iscomplete,islasttimes,groupdetailid)
        values
       (@requestid,@userid,@groupid, @workflowid,@workflowtype1,@usertype,@isremark,@nodeid,@agentorbyagentid,@agenttype,@showorder,@receivedate,@receivetime,0,0,1,@groupdetailid)
   end
else
  begin
       insert into workflow_currentoperator(requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,viewtype,iscomplete,islasttimes,groupdetailid)
       values
       (@requestid,@userid,@groupid, @workflowid,@workflowtype,@usertype,@isremark,@nodeid,@agentorbyagentid,@agenttype,@showorder,@receivedate,@receivetime,0,0,1,@groupdetailid)
 end
 
go

ALTER PROCEDURE workflow_requeststatus_Select
@userid		int, 
@requestid	int, 
@workflowid	int, 
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS
declare @mcount int 
declare @viewnodeidstmp varchar(1000)
declare @viewnodeids varchar(5000)
declare @c1 cursor

select @mcount=count(*) from workflow_monitor_bound where monitorhrmid=@userid and workflowid=@workflowid

if @mcount>0 begin 
	select a.nodeid,b.nodename,a.userid,a.isremark,a.usertype,a.agentorbyagentid,
	a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime,a.viewtype
	from (SELECT distinct requestid
      ,userid
      ,workflowid
      ,workflowtype
      ,isremark
      ,usertype
      ,nodeid
      ,agentorbyagentid
      ,agenttype
     
      ,receivedate
      ,receivetime
      ,viewtype
      ,iscomplete
 
      ,operatedate
      ,operatetime
  FROM workflow_currentoperator  where requestid=@requestid) a,workflow_nodebase b
	where a.nodeid=b.id
	and requestid=@requestid and a.agenttype<>1
	order by a.receivedate,a.receivetime

end else begin
	
	set @viewnodeids=''
	SET @c1 = CURSOR FORWARD_ONLY STATIC FOR
	select b.viewnodeids 
	from (SELECT distinct requestid
      ,userid
      ,workflowid
      ,workflowtype
      ,isremark
      ,usertype
      ,nodeid
      ,agentorbyagentid
      ,agenttype
     
      ,receivedate
      ,receivetime
      ,viewtype
      ,iscomplete
 
      ,operatedate
      ,operatetime
  FROM workflow_currentoperator  where requestid=@requestid) a,workflow_flownode b
	where a.workflowid=b.workflowid and a.nodeid=b.nodeid
	and a.requestid=@requestid and a.userid=@userid and a.usertype=0
	OPEN @c1
	FETCH NEXT FROM @c1 INTO @viewnodeidstmp
	WHILE @@FETCH_STATUS = 0 
	begin 
		if @viewnodeidstmp='-1' begin 
			set @viewnodeids='-1'
			break
		end else begin
			set @viewnodeids=@viewnodeids+@viewnodeidstmp
		end
		FETCH NEXT FROM @c1 INTO @viewnodeidstmp
	end 

	if(@viewnodeids='-1') begin
		select a.nodeid,b.nodename,a.userid,a.isremark,a.usertype,a.agentorbyagentid,
		a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime,a.viewtype
		from (SELECT distinct requestid
      ,userid
      ,workflowid
      ,workflowtype
      ,isremark
      ,usertype
      ,nodeid
      ,agentorbyagentid
      ,agenttype
     
      ,receivedate
      ,receivetime
      ,viewtype
       ,iscomplete
 
      ,operatedate
      ,operatetime
  FROM workflow_currentoperator  where requestid=@requestid) a,workflow_nodebase b
		where a.nodeid=b.id
		and requestid=@requestid and a.agenttype<>1
		order by a.receivedate,a.receivetime
	end else begin
		set @viewnodeids=rtrim(ltrim(@viewnodeids))
		set @viewnodeids=substring(@viewnodeids,1,len(@viewnodeids)-1)
		select a.nodeid,b.nodename,a.userid,a.isremark,a.usertype,a.agentorbyagentid,
		a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime,a.viewtype
		from (SELECT distinct requestid
      ,userid
      ,workflowid
      ,workflowtype
      ,isremark
      ,usertype
      ,nodeid
      ,agentorbyagentid
      ,agenttype
     
      ,receivedate
      ,receivetime
      ,viewtype
      ,iscomplete
 
      ,operatedate
      ,operatetime
  FROM workflow_currentoperator  where requestid=@requestid) a,workflow_nodebase b
		where a.nodeid=b.id
		and requestid=@requestid and a.nodeid in(@viewnodeids) and a.agenttype<>1
		order by a.receivedate,a.receivetime
	end
end
GO

ALTER TABLE workflow_currentoperator DROP COLUMN orderdate
GO

ALTER TABLE workflow_currentoperator DROP COLUMN ordertime
GO
