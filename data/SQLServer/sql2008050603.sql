CREATE TABLE Workflow_FormSignRemark(
	id int identity (1, 1) NOT NULL ,
	requestLogId int NULL ,
	imageFileId int NULL ,
	remark text NULL 
)
GO

insert into Workflow_FormSignRemark(requestLogId,imageFileId,remark)
select requestLogId,imageFileId,remark
  from workflow_requestlog
 where isFormSignature='1'
   and requestId>0
GO

alter table workflow_requestlog drop column isFormSignature
GO

alter table workflow_requestlog drop column imageFileId
GO

update workflow_requestlog set requestLogId=0 
where not exists  (select 1 from Workflow_FormSignRemark where Workflow_FormSignRemark.requestLogId=workflow_requestlog.requestLogId)
GO

alter PROCEDURE  workflow_RequestLog_Insert @requestid int, @workflowid    int, @nodeid    int, @logtype   char(1), @operatedate   char(10), @operatetime  char(8), @operator  int,
@remark    text, @clientip char(15), @operatortype int, @destnodeid    int, @operate varchar(1000),
@agentorbyagentid  int,@agenttype  char(1),@showorder int,@annexdocids varchar(2000),@requestLogId int, @flag integer output , @msg varchar(80) output
AS 
declare @count integer,
	@currentdate char(10),
	@currenttime char(8)

set @currentdate=convert(char(10),getdate(),20)
set @currenttime=convert(char(8),getdate(),108)

if @logtype = '1'
  begin
    select @count = count(*) from workflow_requestlog where requestid=@requestid and nodeid=@nodeid and logtype=@logtype and operator = @operator and operatortype = @operatortype
    if @count > 0
       begin
         update workflow_requestlog SET   [operatedate]   = @currentdate, [operatetime]   = @currenttime, [remark]    = @remark, [clientip]   = @clientip, [destnodeid]   = @destnodeid,annexdocids=@annexdocids ,requestLogId=@requestLogId
         WHERE ( [requestid]  = @requestid AND [nodeid]   = @nodeid AND [logtype]    = @logtype AND [operator]   = @operator AND [operatortype]  = @operatortype)
       end
    else
       begin
         insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder,annexdocids,requestLogId) values(@requestid,@workflowid,@nodeid,@logtype, @currentdate,@currenttime,@operator, @remark,@clientip,@operatortype,@destnodeid,@operate,@agentorbyagentid,@agenttype,@showorder,@annexdocids,@requestLogId)
       end
  end
else
    begin
      delete workflow_requestlog where requestid=@requestid and nodeid=@nodeid and (logtype='1') and operator = @operator and operatortype = @operatortype
      insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder,annexdocids,requestLogId) values(@requestid,@workflowid,@nodeid,@logtype, @currentdate,@currenttime,@operator, @remark,@clientip,@operatortype,@destnodeid,@operate,@agentorbyagentid,@agenttype,@showorder,@annexdocids,@requestLogId)
    end
GO
