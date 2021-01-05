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
      ,workflow_currentoperator.workflowid
      ,workflowtype
      ,isremark
      ,usertype
      ,workflow_currentoperator.nodeid
      ,agentorbyagentid
      ,agenttype
     
      ,receivedate
      ,receivetime
      ,viewtype
      ,iscomplete
 
      ,operatedate
      ,operatetime
      ,nodetype
  FROM workflow_currentoperator,workflow_flownode  where workflow_currentoperator.nodeid=workflow_flownode.nodeid and requestid=@requestid) a,workflow_nodebase b
	where a.nodeid=b.id
	and requestid=@requestid and a.agenttype<>1
	order by a.receivedate,a.receivetime,a.nodetype
end else begin
	set @viewnodeids=''
	SET @c1 = CURSOR FORWARD_ONLY STATIC FOR
	select b.viewnodeids 
	from (SELECT distinct requestid
      ,userid
      ,workflow_currentoperator.workflowid
      ,workflowtype
      ,isremark
      ,usertype
      ,workflow_currentoperator.nodeid
      ,agentorbyagentid
      ,agenttype
     
      ,receivedate
      ,receivetime
      ,viewtype
      ,iscomplete
 
      ,operatedate
      ,operatetime
      ,nodetype
  FROM workflow_currentoperator,workflow_flownode  where workflow_currentoperator.nodeid=workflow_flownode.nodeid and requestid=@requestid) a,workflow_flownode b
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
      ,workflow_currentoperator.workflowid
      ,workflowtype
      ,isremark
      ,usertype
      ,workflow_currentoperator.nodeid
      ,agentorbyagentid
      ,agenttype
     
      ,receivedate
      ,receivetime
      ,viewtype
      ,iscomplete
 
      ,operatedate
      ,operatetime
      ,nodetype
  FROM workflow_currentoperator,workflow_flownode  where workflow_currentoperator.nodeid=workflow_flownode.nodeid and requestid=@requestid) a,workflow_nodebase b
		where a.nodeid=b.id
		and requestid=@requestid and a.agenttype<>1
		order by a.receivedate,a.receivetime,a.nodetype
	end else begin
		set @viewnodeids=rtrim(ltrim(@viewnodeids))
		if(@viewnodeids<>'') begin
		set @viewnodeids=substring(@viewnodeids,1,len(@viewnodeids)-1)
		select a.nodeid,b.nodename,a.userid,a.isremark,a.usertype,a.agentorbyagentid,
		a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime,a.viewtype
		from (SELECT distinct requestid
      ,userid
      ,workflow_currentoperator.workflowid
      ,workflowtype
      ,isremark
      ,usertype
      ,workflow_currentoperator.nodeid
      ,agentorbyagentid
      ,agenttype
     
      ,receivedate
      ,receivetime
      ,viewtype
      ,iscomplete
 
      ,operatedate
      ,operatetime
      ,nodetype
  FROM workflow_currentoperator,workflow_flownode  where  workflow_currentoperator.nodeid=workflow_flownode.nodeid and requestid=@requestid) a,workflow_nodebase b
		where a.nodeid=b.id
		and requestid=@requestid and a.nodeid in(@viewnodeids) and a.agenttype<>1
		order by a.receivedate,a.receivetime,a.nodetype
	end
	end
end
GO
