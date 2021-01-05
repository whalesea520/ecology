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
      ,orderdate
      ,ordertime
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
      ,orderdate
      ,ordertime
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
      ,orderdate
      ,ordertime
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
      ,orderdate
      ,ordertime
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


delete from ShareinnerDoc where ShareinnerDoc.id<(select max(b.id) from ShareinnerDoc b where 
                ShareinnerDoc.sourceid=b.sourceid and ShareinnerDoc.type=b.type and 
                ShareinnerDoc.content=b.content and ShareinnerDoc.srcfrom=b.srcfrom and ShareinnerDoc.opuser=b.opuser 
                and ShareinnerDoc.sharelevel=b.sharelevel) and ShareinnerDoc.type=1
go

delete from ShareinnerDoc where ShareinnerDoc.sharelevel<(select max(b.sharelevel) from ShareinnerDoc b where 
                ShareinnerDoc.sourceid=b.sourceid and ShareinnerDoc.type=b.type and 
                ShareinnerDoc.content=b.content and ShareinnerDoc.srcfrom=b.srcfrom and ShareinnerDoc.opuser=b.opuser 
                ) and ShareinnerDoc.type=1
go

delete from ShareinnerDoc where ShareinnerDoc.id<(select max(b.id) from ShareinnerDoc b where 
                ShareinnerDoc.sourceid=b.sourceid and ShareinnerDoc.type=b.type and 
                ShareinnerDoc.content=b.content and ShareinnerDoc.srcfrom=b.srcfrom and ShareinnerDoc.opuser=b.opuser 
                and ShareinnerDoc.sharelevel=b.sharelevel) and ShareinnerDoc.type!=1
go

delete from ShareinnerDoc where ShareinnerDoc.sharelevel<(select max(b.sharelevel) from ShareinnerDoc b where 
                ShareinnerDoc.sourceid=b.sourceid and ShareinnerDoc.type=b.type and 
                ShareinnerDoc.content=b.content and ShareinnerDoc.srcfrom=b.srcfrom and ShareinnerDoc.opuser=b.opuser 
                ) and ShareinnerDoc.type!=1
go


delete from ShareouterDoc where ShareouterDoc.id<(select max(b.id) from ShareouterDoc b where 
                ShareouterDoc.sourceid=b.sourceid and ShareouterDoc.type=b.type and 
                ShareouterDoc.content=b.content and ShareouterDoc.srcfrom=b.srcfrom and ShareouterDoc.opuser=b.opuser 
                and ShareouterDoc.sharelevel=b.sharelevel) and ShareouterDoc.type=9
go

delete from ShareouterDoc where ShareouterDoc.sharelevel<(select max(b.sharelevel) from ShareouterDoc b where 
                ShareouterDoc.sourceid=b.sourceid and ShareouterDoc.type=b.type and 
                ShareouterDoc.content=b.content and ShareouterDoc.srcfrom=b.srcfrom and ShareouterDoc.opuser=b.opuser 
                ) and ShareouterDoc.type=9
go

delete from ShareouterDoc where ShareouterDoc.id<(select max(b.id) from ShareouterDoc b where 
                ShareouterDoc.sourceid=b.sourceid and ShareouterDoc.type=b.type and 
                ShareouterDoc.content=b.content and ShareouterDoc.srcfrom=b.srcfrom and ShareouterDoc.opuser=b.opuser 
                and ShareouterDoc.sharelevel=b.sharelevel) and ShareouterDoc.type!=10
go

delete from ShareouterDoc where ShareouterDoc.sharelevel<(select max(b.sharelevel) from ShareouterDoc b where 
                ShareouterDoc.sourceid=b.sourceid and ShareouterDoc.type=b.type and 
                ShareouterDoc.content=b.content and ShareouterDoc.srcfrom=b.srcfrom and ShareouterDoc.opuser=b.opuser 
                ) and ShareouterDoc.type!=10
go


delete from ShareinnerDoc where (sourceid<=0 or content<=0)
Go
delete from ShareouterDoc where (sourceid<=0 or content<=0)
Go 
delete from docdetail where (id<=0)
Go 
delete from docshare  where (docid<=0)
Go 
delete from docshare  where (sharetype=0)
Go 

