CREATE TABLE Workflow_DocShareInfo ( 
    id int not null IDENTITY (1,1),	/*自增长ID*/
    docId int,	/*docid*/
    workflowId int,	/*工作流id*/
    requestId int,	/*请求id*/
    nodeId int,	/*节点id*/
    userId int,	/*被赋权人*/
    beAgentid int,/*被代理人*/
    sharelevel int		/*所赋权限*/
    )
GO
alter table DocShare add  sharesource int
GO
CREATE PROCEDURE Workflow_DocShareInfo_I (@docid  int, @workflowId	int, @requestId	int, @nodeId int, @userid	int,@beAgentid int, @sharelevel int, @flag	int output, @msg	varchar(80)	output) as insert into Workflow_DocShareInfo(docid,workflowId,requestId,nodeId,userid,beAgentid,sharelevel)  values(@docid,@workflowId,@requestId,@nodeId,@userid,@beAgentid,@sharelevel)   
GO
CREATE PROCEDURE WFDocShareInfo_Delete 
(@requestId	int,@userid    int, @flag	int output, @msg	varchar(80)	output) as 
delete from Workflow_DocShareInfo where requestId=@requestId and userid=@userid
GO
CREATE PROCEDURE WFDocShareInfo_Select 
(@requestId	int,@userid    int, @flag	int output, @msg	varchar(80)	output) as 
select * from Workflow_DocShareInfo where requestId=@requestId and userid=@userid
GO
CREATE PROCEDURE DocShare_FromDocSecCategoryI (@docid  int, @sharetype	int, @seclevel	tinyint, @rolelevel	tinyint, @sharelevel	tinyint, @userid	int, @subcompanyid	int, @departmentid	int, @roleid	int, @foralluser	tinyint, @crmid	int,@sharesource int, @flag	int output, @msg	varchar(80)	output) as insert into DocShare(docid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,sharesource) values(@docid,@sharetype,@seclevel,@rolelevel,@sharelevel,@userid,@subcompanyid,@departmentid,@roleid,@foralluser,@crmid,@sharesource)   
GO
CREATE PROCEDURE WF_DocShare_AddSharesource (@docid_1	int, @sharelevel_1	int, @userid_1	int, @usertype_1	int,@sharesource int, @flag  int output, @msg   varchar(80) output ) as declare @count_1 int declare @count_2 int select @count_1=count(*)  from docdetail where usertype=@usertype_1 and (ownerid=@userid_1 or doccreaterid=@userid_1) if @count_1=0 begin select @count_2=count(*)  from DocShare where docid=@docid_1 and sharelevel=@sharelevel_1 and userid= @userid_1 if @count_2=0 begin if @usertype_1=0 begin insert into DocShare(docid,sharetype,sharelevel,userid,sharesource) values(@docid_1,'1',@sharelevel_1,@userid_1,@sharesource) end if @usertype_1=1 begin insert into DocShare(docid,sharetype,sharelevel,crmid) values(@docid_1,'9',@sharelevel_1,@userid_1) end end end 
GO