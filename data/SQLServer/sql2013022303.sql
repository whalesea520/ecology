Alter table workflow_requestLog
Add HandWrittenSign int , SpeechAttachment int

GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  workflow_RequestLogCurDate_New 
	@requestid int, @workflowid    int, @nodeid    int, @logtype   char(1), 
	@operatedate   char(10), @operatetime  char(8), @operator  int, @remark    text, 
	@clientip char(15), @operatortype int, @destnodeid    int, @operate varchar(1000), 
	@agentorbyagentid  int,@agenttype  char(1),@showorder int,@annexdocids varchar(2000),
	@requestLogId int,@signdocids varchar(500),@signworkflowids varchar(500),@clientType char(1), 
	@speechAttachment int,@handWrittenSign int,@flag integer output , @msg varchar(80) output 
AS 
	declare @count integer, @operatorDept integer  
	if @operatortype = '0' begin 
		select @operatorDept = departmentid from hrmresource where id = @operator 
	end 
	else begin 
		set @operatorDept = 0 
	end  
	if @logtype = '1' begin 
		select @count = count(*) from workflow_requestlog where requestid=@requestid and nodeid=@nodeid and logtype=@logtype and operator = @operator and operatortype = @operatortype 
		if @count > 0 begin 
			update workflow_requestlog SET   [operatedate]   = @operatedate, [operatetime]   = @operatetime, [remark]    = @remark, [clientip]   = @clientip, [destnodeid]   = @destnodeid,annexdocids=@annexdocids ,requestLogId=@requestLogId,signdocids=@signdocids,signworkflowids=@signworkflowids,isMobile=@clientType,SpeechAttachment=@speechAttachment,HandWrittenSign=@handWrittenSign WHERE ( [requestid]  = @requestid AND [nodeid]   = @nodeid AND [logtype]    = @logtype AND [operator]   = @operator AND [operatortype]  = @operatortype) 
		end 
		else begin 
			insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder,annexdocids,requestLogId,operatorDept,signdocids,signworkflowids,isMobile,HandWrittenSign,SpeechAttachment) values(@requestid,@workflowid,@nodeid,@logtype, @operatedate,@operatetime,@operator, @remark,@clientip,@operatortype,@destnodeid,@operate,@agentorbyagentid,@agenttype,@showorder,@annexdocids,@requestLogId,@operatorDept,@signdocids,@signworkflowids,@clientType,@handWrittenSign,@speechAttachment) 
		end 
	end 
	else begin 
		delete workflow_requestlog where requestid=@requestid and nodeid=@nodeid and (logtype='1') and operator = @operator and operatortype = @operatortype 
		insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder,annexdocids,requestLogId,operatorDept,signdocids,signworkflowids,isMobile,HandWrittenSign,SpeechAttachment) values(@requestid,@workflowid,@nodeid,@logtype, @operatedate,@operatetime,@operator, @remark,@clientip,@operatortype,@destnodeid,@operate,@agentorbyagentid,@agenttype,@showorder,@annexdocids,@requestLogId,@operatorDept,@signdocids,@signworkflowids,@clientType,@handWrittenSign,@speechAttachment) 
	end

GO

ALTER PROCEDURE  workflow_RequestLogCurDate_I 
	@requestid int, @workflowid    int, @nodeid    int, @logtype   char(1), 
	@operatedate   char(10), @operatetime  char(8), @operator  int, @remark    text, 
	@clientip char(15), @operatortype int, @destnodeid    int, @operate varchar(1000), 
	@agentorbyagentid  int,@agenttype  char(1),@showorder int,@annexdocids varchar(2000),
	@requestLogId int,@signdocids varchar(500),@signworkflowids varchar(500),
	@flag integer output , @msg varchar(80) output 
AS 
	exec workflow_RequestLogCurDate_New @requestid, @workflowid, @nodeid, @logtype, @operatedate, 
	@operatetime, @operator, @remark, @clientip, @operatortype, @destnodeid, @operate,
	@agentorbyagentid, @agenttype, @showorder, @annexdocids, @requestLogId, @signdocids,
	@signworkflowids, '0', 0, 0, @flag, @msg
	
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE  workflow_RequestLog_Insert_New 
	@requestid int, @workflowid    int, @nodeid    int, @logtype   char(1), 
	@operatedate   char(10), @operatetime  char(8), @operator  int, @remark    text, 
	@clientip char(15), @operatortype int, @destnodeid    int, @operate varchar(1000), 
	@agentorbyagentid  int,@agenttype  char(1),@showorder int,@annexdocids varchar(2000),
	@requestLogId int,@signdocids varchar(500),@signworkflowids varchar(500), @clientType char(1),
	@speechAttachment int,@handWrittenSign int,@flag integer output , @msg varchar(80) output 
AS 
	declare 
		@count integer, @currentdate char(10), @currenttime char(8), @operatorDept integer  
	set @currentdate=convert(char(10),getdate(),20) 
	set @currenttime=convert(char(8),getdate(),108)  
	if @operatortype = '0' begin 
		select @operatorDept = departmentid from hrmresource where id = @operator 
	end 
	else begin 
		set @operatorDept = 0 
	end 
	if @logtype = '1' begin 
		select @count = count(*) from workflow_requestlog where requestid=@requestid and nodeid=@nodeid and logtype=@logtype and operator = @operator and operatortype = @operatortype 
		if @count > 0 begin 
			update workflow_requestlog SET   [operatedate]   = @currentdate, [operatetime]   = @currenttime, [remark]    = @remark, [clientip]   = @clientip, [destnodeid]   = @destnodeid,annexdocids=@annexdocids ,requestLogId=@requestLogId,signdocids=@signdocids,signworkflowids=@signworkflowids,isMobile=@clientType,SpeechAttachment=@speechAttachment,HandWrittenSign=@handWrittenSign  WHERE ( [requestid]  = @requestid AND [nodeid]   = @nodeid AND [logtype]    = @logtype AND [operator]   = @operator AND [operatortype]  = @operatortype) 
		end 
		else begin 
			insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder,annexdocids,requestLogId,operatorDept,signdocids,signworkflowids,isMobile,HandWrittenSign,SpeechAttachment) values(@requestid,@workflowid,@nodeid,@logtype, @currentdate,@currenttime,@operator, @remark,@clientip,@operatortype,@destnodeid,@operate,@agentorbyagentid,@agenttype,@showorder,@annexdocids,@requestLogId,@operatorDept,@signdocids,@signworkflowids,@clientType,@handWrittenSign,@speechAttachment) 
		end 
		select @currentdate,@currenttime from workflow_requestlog where requestid=@requestid 
	end 
	else begin 
		delete workflow_requestlog where requestid=@requestid and nodeid=@nodeid and (logtype='1') and operator = @operator and operatortype = @operatortype 
		insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder,annexdocids,requestLogId,operatorDept,signdocids,signworkflowids,isMobile,HandWrittenSign,SpeechAttachment) values(@requestid,@workflowid,@nodeid,@logtype, @currentdate,@currenttime,@operator, @remark,@clientip,@operatortype,@destnodeid,@operate,@agentorbyagentid,@agenttype,@showorder,@annexdocids,@requestLogId,@operatorDept,@signdocids,@signworkflowids,@clientType,@handWrittenSign,@speechAttachment) 
		select @currentdate,@currenttime from workflow_requestlog where requestid=@requestid 
	end
	
GO


ALTER PROCEDURE  workflow_RequestLog_Insert 
	@requestid int, @workflowid    int, @nodeid    int, @logtype   char(1), 
	@operatedate   char(10), @operatetime  char(8), @operator  int, @remark    text, 
	@clientip char(15), @operatortype int, @destnodeid    int, @operate varchar(1000), 
	@agentorbyagentid  int,@agenttype  char(1),@showorder int,@annexdocids varchar(2000),
	@requestLogId int,@signdocids varchar(500),@signworkflowids varchar(500),
	@flag integer output , @msg varchar(80) output 
AS 
	exec [workflow_RequestLog_Insert_New] @requestid, @workflowid, @nodeid, @logtype, @operatedate, 
	@operatetime, @operator, @remark, @clientip, @operatortype, @destnodeid, @operate,
	@agentorbyagentid, @agenttype, @showorder, @annexdocids, @requestLogId, @signdocids,
	@signworkflowids, '0', 0, 0, @flag, @msg


GO