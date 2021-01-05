Create PROCEDURE MostExceedPerson_Get
@sqlStr_1	varchar(4000), 
@flag 		integer 	output, 
@msg 		varchar(80) output 
AS 
exec ('
select top  100 percent userid as userid,count(distinct workflow_requestbase.requestid) as counts,
(select count(requestid) from workflow_requestbase b 
where exists (select 1 from workflow_currentoperator  a 
where a.requestid=b.requestid 
and a.userid=workflow_currentoperator.userid) 
and b.status is not null and b.status!='''') as countall,
convert(float,count(distinct workflow_requestbase.requestid)*100)/convert(float,(select count(requestid) from workflow_requestbase b 
where exists (select 1 from workflow_currentoperator  a 
where a.requestid=b.requestid 
and a.userid=workflow_currentoperator.userid) 
and b.status is not null and b.status!='''') ) as percents
from workflow_currentoperator,workflow_requestbase 
where  workflow_currentoperator.requestid=workflow_requestbase.requestid  and (24*(convert(float,convert(datetime,isnull(lastoperatedate ,convert(char(10),getdate(),20)) 
+'' ''+isnull(lastoperatetime,convert(char(10),getdate(),108))))-convert(float,convert(datetime,createdate+'' ''+createtime)))
-
(select 
sum(isnull(convert(float,nodepasshour),0)+isnull(convert(float,nodepassminute),0)/24) 
from workflow_nodelink where workflowid=workflow_requestbase.workflowid))>0 
and  workflow_requestbase.status is not null and workflow_requestbase.status!=''''  
and exists (select 1 from workflow_nodelink where workflowid=workflow_requestbase.workflowid
and  (workflow_currentoperator.usertype = 0) and exists (select 1 from hrmresource where hrmresource.id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))  
and (convert(float,nodepasshour)>0 or convert(float,nodepassminute)>0))
and isremark<>4
'+@sqlStr_1+'
group by userid
order by percents desc
') 
go

Create PROCEDURE WorkFlowPending_Get 
@sqlStr_1	varchar(4000), 
@flag 		integer 	output, 
@msg 		varchar(80) output 
AS 
exec ('
SELECT TOP 100 PERCENT userid as userid, COUNT(requestid) AS counts
FROM  workflow_currentoperator
WHERE workflowtype>1 and (isremark IN (''0'', ''1'', ''5'')) 
AND (islasttimes = 1) AND (usertype = 0) 
and exists (select 1 from hrmresource where hrmresource.id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))
'+@sqlStr_1+'
GROUP BY userid
ORDER BY COUNT(requestid) desc
') 
go