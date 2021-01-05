alter table workflow_flownode add isFormSignature char(1) null
GO
update workflow_flownode set isFormSignature='0'
GO

ALTER TABLE workflow_RequestLog ADD  isFormSignature char(1) null
GO

ALTER TABLE workflow_RequestLog ADD  imageFileId int null
GO

CREATE TABLE workflow_requestLogSequence (
	requestLogId int NULL 
)
GO
insert into  workflow_requestLogSequence(requestLogId) values(0)
GO

ALTER TABLE workflow_RequestLog ADD  requestLogId int NOT NULL  default 0
GO
update workflow_RequestLog set requestLogId=logId
GO
update workflow_requestLogSequence set requestLogId=(select max(requestLogId) from workflow_RequestLog)
GO


CREATE TABLE Workflow_FormSignatureLog(
	id int identity (1, 1) NOT NULL ,
	workflowRequestLogId int NULL ,
	fieldName varchar(50) NULL ,
	markName varchar(50) NULL ,
	userName varchar(50) NULL ,
	dateTime varchar(19) NULL ,
	hostName varchar(50) NULL ,
	markGuid varchar(128) NULL 
)
GO

CREATE TABLE Workflow_FormSignatureImgLog(
	id int identity (1, 1) NOT NULL ,
	requestLogId int NULL ,
	imageFileId int NULL 
)
GO

CREATE PROCEDURE workflow_RequestLogID_Update 
 @flag integer output , 
 @msg varchar(80) output 
 AS 
 update workflow_requestlogsequence set requestlogid=requestlogid+1  
 select requestlogid from workflow_requestlogsequence 
GO



alter PROCEDURE  workflow_RequestLog_Insert @requestid int, @workflowid    int, @nodeid    int, @logtype   char(1), @operatedate   char(10), @operatetime  char(8), @operator  int,
@remark    text, @clientip char(15), @operatortype int, @destnodeid    int, @operate varchar(1000),
@agentorbyagentid  int,@agenttype  char(1),@showorder int,@annexdocids varchar(2000),@requestLogId int, @flag integer output , @msg varchar(80) output
AS 
declare @count integer,
	@isFormSignature char(1),
	@currentdate char(10),
	@currenttime char(8)

set @isFormSignature='0'
set @currentdate=convert(char(10),getdate(),20)
set @currenttime=convert(char(8),getdate(),108)

if @requestLogId>0
  begin
    select @isFormSignature=isFormSignature from workflow_requestlog where requestLogId=@requestLogId
  end

if @logtype = '1'
  begin
    select @count = count(*) from workflow_requestlog where requestid=@requestid and nodeid=@nodeid and logtype=@logtype and operator = @operator and operatortype = @operatortype
    if @count > 0
       begin
         if @isFormSignature='1'
	   begin
             update workflow_requestlog SET   operatedate   = @currentdate, operatetime   = @currenttime, clientip   = @clientip, destnodeid   = @destnodeid,annexdocids=@annexdocids
             WHERE ( requestid  = @requestid AND nodeid = @nodeid AND logtype    = @logtype AND operator   = @operator AND operatortype  = @operatortype)
	   end
	 else
	   begin
             update workflow_requestlog SET   operatedate   = @currentdate, operatetime   = @currenttime, remark    = @remark, clientip   = @clientip, destnodeid   = @destnodeid,annexdocids=@annexdocids
             WHERE ( requestid  = @requestid AND nodeid = @nodeid AND logtype    = @logtype AND operator   = @operator AND operatortype  = @operatortype)
	   end


       end
    else
       begin
         if @requestLogId>0
	   begin
	     if @isFormSignature='1'
	       begin
                 update workflow_requestlog SET   requestid= @requestid, workflowid= @workflowid, nodeid= @nodeid, logtype= @logtype, operator= @operator, operatortype= @operatortype, receivedPersons= @operate, agentorbyagentid= @agentorbyagentid, agenttype= @agenttype, showorder= @showorder, operatedate   = @currentdate, operatetime   = @currenttime,  clientip   = @clientip, destnodeid   = @destnodeid, annexdocids= @annexdocids
                 WHERE  requestLogId  = @requestLogId
	       end 
	     else
	       begin
                 update workflow_requestlog SET   requestid= @requestid, workflowid= @workflowid, nodeid= @nodeid, logtype= @logtype, operator= @operator, operatortype= @operatortype, receivedPersons= @operate, agentorbyagentid= @agentorbyagentid, agenttype= @agenttype, showorder= @showorder, operatedate   = @currentdate, operatetime   = @currenttime, remark    = @remark, clientip   = @clientip, destnodeid   = @destnodeid, annexdocids= @annexdocids
                 WHERE  requestLogId  = @requestLogId
	       end

	   end
	 else
	   begin
             insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder,annexdocids) values(@requestid,@workflowid,@nodeid,@logtype, @currentdate,@currenttime,@operator, @remark,@clientip,@operatortype,@destnodeid,@operate,@agentorbyagentid,@agenttype,@showorder,@annexdocids)
	   end
       end
  end
else
    begin
      if @requestLogId>0
        begin
          delete workflow_requestlog where requestid=@requestid and nodeid=@nodeid and (logtype='1') and operator = @operator and operatortype = @operatortype and requestLogId<>@requestLogId
          if @isFormSignature='1' 
	    begin
              update workflow_requestlog SET   requestid= @requestid, workflowid= @workflowid, nodeid= @nodeid, logtype= @logtype, operator= @operator, operatortype= @operatortype, receivedPersons= @operate, agentorbyagentid= @agentorbyagentid, agenttype= @agenttype, showorder= @showorder, operatedate   = @currentdate, operatetime   = @currenttime,  clientip   = @clientip, destnodeid   = @destnodeid, annexdocids= @annexdocids
              WHERE  requestLogId  = @requestLogId
	    end
	  else
	    begin
              update workflow_requestlog SET   requestid= @requestid, workflowid= @workflowid, nodeid= @nodeid, logtype= @logtype, operator= @operator, operatortype= @operatortype, receivedPersons= @operate, agentorbyagentid= @agentorbyagentid, agenttype= @agenttype, showorder= @showorder, operatedate   = @currentdate, operatetime   = @currenttime, remark    = @remark, clientip   = @clientip, destnodeid   = @destnodeid, annexdocids= @annexdocids
              WHERE  requestLogId  = @requestLogId
	    end

        end
      else
        begin
          delete workflow_requestlog where requestid=@requestid and nodeid=@nodeid and (logtype='1') and operator = @operator and operatortype = @operatortype

          insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder,annexdocids) values(@requestid,@workflowid,@nodeid,@logtype, @currentdate,@currenttime,@operator, @remark,@clientip,@operatortype,@destnodeid,@operate,@agentorbyagentid,@agenttype,@showorder,@annexdocids)	  
	end
    end
GO

