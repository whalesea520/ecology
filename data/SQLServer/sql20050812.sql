ALTER TABLE workflow_agent ADD agenttype  char(1)
GO
ALTER TABLE workflow_agent ADD operatorid  int
GO
ALTER TABLE workflow_agent ADD operatordate  char(10)
GO
ALTER TABLE workflow_agent ADD operatortime  char(8)
GO

INSERT INTO HtmlLabelIndex values(17860,'批量回收') 
GO
INSERT INTO HtmlLabelInfo VALUES(17860,'批量回收',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17860,'Countermand Workflow Agent',8) 
GO

/*对老数据的处理*/
update workflow_agent set agenttype = 1, operatorid  = workflow_agent.beagenterid
GO


create PROCEDURE Workflow_select_foragent 
 @userid int,
 @usertype int,
 @flag integer output,
 @msg varchar(80) output

AS 
Declare @current_date char(10),
        @current_time char(8)
set @current_date=subString(convert(char,getDate(),120),1,10)
set @current_time=subString(convert(char,getDate(),120),12,5)

select distinct a.workflowid 
from workflow_createrlist a
where a.isagenter=0 or a.isagenter is null

UNION

select distinct a.workflowid 
from workflow_createrlist a,workflow_agent b
where 
a.isagenter=1 and a.workflowid=b.workflowid and b.isCreateAgenter=1 and
(
(b.begindate='' and b.enddate='') or

(b.begindate<>'' and b.enddate='' and b.begindate<@current_date ) or
(b.begindate<>'' and b.enddate='' and b.begindate=@current_date and b.begintime='') or
(b.begindate<>'' and b.enddate='' and b.begindate=@current_date and b.begintime<>'' and b.begintime<=@current_time) or

(b.enddate<>'' and b.begindate='' and b.enddate>@current_date ) or  
(b.enddate<>'' and b.begindate='' and b.enddate=@current_date and b.endtime='') or
(b.enddate<>'' and b.begindate='' and b.enddate=@current_date and b.endtime<>'' and b.endtime>=@current_time) or

(b.begindate<>'' and b.enddate<>'' and b.begindate<=@current_date and @current_date<=b.enddate and b.begintime='' and b.endtime='') or
(b.begindate<>'' and b.enddate<>'' and b.begindate<=@current_date and @current_date<=b.enddate and b.begintime<>'' and b.endtime='' and b.begintime<=@current_time)or
(b.begindate<>'' and b.enddate<>'' and b.begindate<=@current_date and @current_date<=b.enddate and b.begintime='' and b.endtime<>'' and b.endtime>=@current_time)or
(b.begindate<>'' and b.enddate<>'' and b.begindate<=@current_date and @current_date<=b.enddate and b.begintime<>'' and b.endtime<>''and b.begintime<=@current_time and @current_time<=b.endtime)
)


go