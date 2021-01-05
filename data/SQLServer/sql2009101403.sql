alter PROCEDURE WorkFlowPending_Get 
@sqlStr_1	varchar(4000), 
@flag 		integer 	output, 
@msg 		varchar(80) output 
AS 
exec ('
SELECT TOP 100 PERCENT userid as userid, COUNT(requestid) AS counts
FROM  workflow_currentoperator
WHERE workflowtype>1 and (isremark IN (''0'', ''1'', ''5'',''8'',''9'')) 
AND (islasttimes = 1) AND (usertype = 0) 
and exists (select 1 from hrmresource where hrmresource.id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))
'+@sqlStr_1+'
GROUP BY userid
ORDER BY COUNT(requestid) desc
') 
go
