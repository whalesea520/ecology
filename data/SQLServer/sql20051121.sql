INSERT INTO HtmlLabelIndex values(18002,'接收时间') 
GO
INSERT INTO HtmlLabelIndex values(18003,'操作耗时') 
GO
INSERT INTO HtmlLabelIndex values(18008,'操作时间') 
GO
INSERT INTO HtmlLabelIndex values(18006,'已查看') 
GO
INSERT INTO HtmlLabelIndex values(18007,'未查看') 
GO
INSERT INTO HtmlLabelInfo VALUES(18002,'接收时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18002,'receive time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18003,'操作耗时',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18003,'operate time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18006,'已查看',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18006,'viewed',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18007,'未查看',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18007,'no view',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18008,'操作时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18008,'opetating time',8) 
GO

ALTER TABLE workflow_currentoperator ADD 
operatedate char(10),
operatetime char(8)
GO 

CREATE PROCEDURE workflow_CurOpe_UpdatebySubmit 
@requestid	int, 
@groupid	int, 
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
declare @currentdate char(10),
	@currenttime char(8)

set @currentdate=convert(char(10),getdate(),20)
set @currenttime=convert(char(8),getdate(),108)

update workflow_currentoperator set isremark = '2',operatedate=@currentdate,operatetime=@currenttime 
where requestid =@requestid and isremark=0 and groupid =@groupid

GO

CREATE PROCEDURE workflow_CurOpe_UpdatebyReject 
@requestid	int, 
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
declare @currentdate char(10),
	@currenttime char(8)

set @currentdate=convert(char(10),getdate(),20)
set @currenttime=convert(char(8),getdate(),108)

update workflow_currentoperator set isremark = '2',operatedate=@currentdate,operatetime=@currenttime 
where requestid =@requestid and isremark=0 

GO

CREATE PROCEDURE workflow_CurOpe_UpdatebyView 
@requestid	int, 
@userid		int, 
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
declare @currentdate char(10),
	@currenttime char(8)

set @currentdate=convert(char(10),getdate(),20)
set @currenttime=convert(char(8),getdate(),108)

update workflow_currentoperator set operatedate=@currentdate,operatetime=@currenttime 
where requestid =@requestid and userid =@userid and isremark in(0,4) and operatedate is null

GO

CREATE PROCEDURE workflow_CurOpe_UbyForward 
@requestid	int, 
@userid		int, 
@usertype	int, 
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
declare @currentdate char(10),
	@currenttime char(8)

set @currentdate=convert(char(10),getdate(),20)
set @currenttime=convert(char(8),getdate(),108)

update workflow_currentoperator set isremark=2,operatedate=@currentdate,operatetime=@currenttime 
where requestid =@requestid and userid =@userid and usertype=@usertype and isremark=1 

GO

CREATE PROCEDURE workflow_requeststatus_Select 
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
	a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime
	from workflow_currentoperator a,workflow_nodebase b
	where a.nodeid=b.id
	and requestid=@requestid
	order by a.id

end else begin

	set @viewnodeids=''
	SET @c1 = CURSOR FORWARD_ONLY STATIC FOR
	select b.viewnodeids 
	from workflow_currentoperator a,workflow_flownode b
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
		a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime
		from workflow_currentoperator a,workflow_nodebase b
		where a.nodeid=b.id
		and requestid=@requestid
		order by a.id
	end else begin
		set @viewnodeids=rtrim(ltrim(@viewnodeids))
		set @viewnodeids=substring(@viewnodeids,1,len(@viewnodeids)-1)
		select a.nodeid,b.nodename,a.userid,a.isremark,a.usertype,a.agentorbyagentid,
		a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime
		from workflow_currentoperator a,workflow_nodebase b
		where a.nodeid=b.id
		and requestid=@requestid and a.nodeid in(@viewnodeids)
		order by a.id
	end
end

GO
