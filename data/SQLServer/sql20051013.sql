ALTER  PROCEDURE DocShare_FromDocSecCategoryI (@docid  int, @sharetype	int, @seclevel	tinyint, @rolelevel	tinyint, 
@sharelevel	tinyint, @userid	int, @subcompanyid	int, @departmentid	int, @roleid	int, 
@foralluser	tinyint, @crmid	int,@sharesource int, @flag	int output, @msg	varchar(80)	output) as 

declare @count_1 int 

select @count_1=count(*)  
from DocShare 
where docid=@docid and sharetype=@sharetype and seclevel=@seclevel and rolelevel=@rolelevel and sharelevel<=@sharelevel 
and userid=@userid and subcompanyid=@subcompanyid and departmentid=@departmentid and roleid=@roleid and foralluser=@foralluser 
and crmid=@crmid and sharesource=@sharesource

if @count_1=0 begin 
	insert into DocShare(docid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,sharesource) 
	values(@docid,@sharetype,@seclevel,@rolelevel,@sharelevel,@userid,@subcompanyid,@departmentid,@roleid,@foralluser,@crmid,@sharesource)   
end else begin
	update DocShare 
	set docid=@docid , sharetype=@sharetype , seclevel=@seclevel , rolelevel=@rolelevel , 
	sharelevel=@sharelevel , userid=@userid , subcompanyid=@subcompanyid , departmentid=@departmentid 
	, roleid=@roleid , foralluser=@foralluser , crmid=@crmid , sharesource=@sharesource
	where docid=@docid and sharetype=@sharetype and seclevel=@seclevel and rolelevel=@rolelevel and 
	sharelevel<@sharelevel and userid=@userid and subcompanyid=@subcompanyid and departmentid=@departmentid 
	and roleid=@roleid and foralluser=@foralluser and crmid=@crmid and sharesource=@sharesource
end

GO

CREATE  PROCEDURE Workflow_DocShareInfo_S (@docid int, @workflowId int, @requestId int, @nodeId int, @userid int,@beAgentid int, @sharelevel int, @flag int output, @msg varchar(80) output) as 

select userid 
from Workflow_DocShareInfo 
where docid=@docid and workflowId=@workflowId and requestId=@requestId and nodeId=@nodeId and userid=@userid and beAgentid=@beAgentid and sharelevel=@sharelevel  

GO


