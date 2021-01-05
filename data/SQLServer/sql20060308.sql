alter PROCEDURE workflow_requeststatus_Select 
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
	and requestid=@requestid and a.agenttype<>1
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
		and requestid=@requestid and a.agenttype<>1
		order by a.id
	end else begin
		set @viewnodeids=rtrim(ltrim(@viewnodeids))
		set @viewnodeids=substring(@viewnodeids,1,len(@viewnodeids)-1)
		select a.nodeid,b.nodename,a.userid,a.isremark,a.usertype,a.agentorbyagentid,
		a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime
		from workflow_currentoperator a,workflow_nodebase b
		where a.nodeid=b.id
		and requestid=@requestid and a.nodeid in(@viewnodeids) and a.agenttype<>1
		order by a.id
	end
end

GO

update workflow_currentoperator set isremark='4' where requestid in(select requestid from workflow_requestbase where currentnodetype='3') and isremark='0'
GO
INSERT INTO HtmlLabelIndex values(18420,'只允许复制具体的菜单项') 
GO
INSERT INTO HtmlLabelInfo VALUES(18420,'只允许复制具体的菜单项',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18420,'you must select one menu',8) 
GO
INSERT INTO HtmlLabelIndex values(18421,'是否复制到自定义分类') 
GO
INSERT INTO HtmlLabelInfo VALUES(18421,'是否复制到自定义分类',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18421,'Do you copy this menu to custom menu category',8) 
GO

update MainMenuInfo set linkaddress='/fna/report/budget/FnaBudgetDepartment.jsp' where id=246
go

