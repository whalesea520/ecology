ALTER PROCEDURE MostExceedPerson_Get
@sqlStr_1	varchar(4000), 
@sqlStr_2       varchar(4000),
@sqlStr_3       varchar(4000),
@flag 		integer 	output, 
@msg 		varchar(80) output 
AS 
exec ('
select top  100 percent userid as userid,count(distinct workflow_requestbase.requestid) as counts,
(select count(requestid) from workflow_requestbase b 
where exists (select 1 from workflow_currentoperator  a 
where a.requestid=b.requestid 
and a.userid=workflow_currentoperator.userid '+@sqlStr_2+') 
and b.status is not null and b.status!='''' '+@sqlStr_3+') as countall,

convert(float,count(distinct workflow_requestbase.requestid)*100)/convert(float,(select count(requestid) from workflow_requestbase b 
where exists (select 1 from workflow_currentoperator  a 
where a.requestid=b.requestid 
and a.userid=workflow_currentoperator.userid '+@sqlStr_2+') 
and b.status is not null and b.status!='''' '+@sqlStr_3+') ) as percents

from workflow_currentoperator,workflow_requestbase 
where  workflow_currentoperator.requestid=workflow_requestbase.requestid  
and (workflow_currentoperator.isprocessed = ''2'' or workflow_currentoperator.isprocessed = ''3'')
and workflow_requestbase.status is not null and workflow_requestbase.status!=''''  
and exists (select 1 from workflow_nodelink where workflowid=workflow_requestbase.workflowid
and (workflow_currentoperator.usertype = 0) and exists (select 1 from hrmresource where hrmresource.id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))  
and (convert(float,nodepasshour)>0 or convert(float,nodepassminute)>0))
and isremark<>4
'+@sqlStr_1+'
group by userid
order by percents desc
') 
GO
