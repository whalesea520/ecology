ALTER     PROCEDURE WorkFlowNodeTime_Get 
@sqlStr_1	varchar(4000), 
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
exec 
('
select workflow_currentoperator.workflowid, workflow_currentoperator.nodeid,
(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid), 
24*avg(
         convert(float,
               convert(datetime,
                       case isremark when ''2'' then case operatedate when '''' then convert(char(10),getdate(),20) else operatedate end  
                       when null then isnull(operatedate,convert(char(10),getdate(),20)) 
                       else convert(char(10),getdate(),20)
                       end +'' ''+ 
                       case isremark when ''2'' then case operatetime when '''' then convert(char(10),getdate(),108) else operatetime end  
                       when null then isnull(operatedate,convert(char(10),getdate(),108)) 
                       else convert(char(10),getdate(),108) 
                       end 
                       )
               )
          - 
          convert(float,convert(datetime,receivedate+'' ''+receivetime))
      )
from workflow_currentoperator,workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and (workflow_requestbase.status is not null and workflow_requestbase.status!='''') and workflowtype>1  and isremark<4 '+@sqlStr_1+' and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and  workflowid=workflow_currentoperator.workflowid and nodetype<3) group by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid order by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid
')


ALTER    PROCEDURE WorkFlowTypeNodeTime_Get 
@sqlStr_1	varchar(4000), 
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
exec ('
select 
 workflow_currentoperator.requestid, 
 workflow_currentoperator.nodeid,
 (select requestname from workflow_requestbase where requestid=workflow_currentoperator.requestid ),
 (select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid), 
 24*avg(
         convert(float,
                convert(datetime,
                       case isremark when ''2'' then case operatedate when '''' then convert(char(10),getdate(),20) else operatedate end  
                       when null then isnull(operatedate,convert(char(10),getdate(),20)) 
                       else convert(char(10),getdate(),20)
                       end +'' ''+ 
                       case isremark when ''2'' then case operatetime when '''' then convert(char(10),getdate(),108) else operatetime end  
                       when null then isnull(operatedate,convert(char(10),getdate(),108)) 
                       else convert(char(10),getdate(),108) 
                       end 
                       )
                ) 
         -
         convert(float,convert(datetime,receivedate+'' ''+receivetime))) 
from workflow_currentoperator,workflow_requestbase 
where workflow_requestbase.requestid=workflow_currentoperator.requestid 
and (workflow_requestbase.status is not null and workflow_requestbase.status!='''') 
and workflowtype>1  
and isremark<4 '+@sqlStr_1+' 
and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and  workflowid=workflow_currentoperator.workflowid and nodetype<3) 
group by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid 
order by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid
')   