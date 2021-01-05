/* 工作流创建权限检索，带代理流程是否过期判断 */

CREATE PROCEDURE Workflow_createlist_select 
 @userid int,
 @usertype int,
 @flag integer output,
 @msg varchar(80) output

AS 
Declare @current_date char(10),
        @current_time char(8)
set @current_date=subString(convert(char,getDate(),120),1,10)
set @current_time=subString(convert(char,getDate(),120),11,19)

select distinct a.workflowid 
from workflow_createrlist a
where 
(a.isagenter=0 or a.isagenter is null) and a.userid =@userid and a.usertype =@usertype 

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
and a.userid =@userid and a.usertype =@usertype 

GO
