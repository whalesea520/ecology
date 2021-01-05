ALTER  PROCEDURE MostExceedFlow_Get
@sqlStr_1	varchar(4000), 
@sqlStr_2	varchar(4000), 
@pagenum   int , 
@prepage  int, 
@count  int, 
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS DECLARE 
@num int, 
@countss int 
set @num=@pagenum*@prepage 
set @countss=@count-(@pagenum-1)*@prepage-1 
if @pagenum=1 
exec ('
select top '+@prepage+' * from (
select requestname,workflow_requestbase.requestid,workflow_requestbase.workflowid, 
(24*(convert(float,
convert(datetime,
         case lastoperatedate
		 when '' '' then convert(char(10),getdate(),20)  
		 when null then convert(char(10),getdate(),20)
		 else lastoperatedate end
			 + '' '' +
			 isnull(lastoperatetime,convert(char(10), getdate(),108))
))
-convert(float,convert(datetime,createdate+'' ''+createtime))) - 
(select sum(isnull(convert(float,nodepasshour),0)+isnull(convert(float,nodepassminute),0)/24) 
from workflow_nodelink where workflowid=workflow_requestbase.workflowid)) 
as spends from workflow_requestbase 
where 
(24*(convert(float,
convert(datetime,
         case lastoperatedate
		 when '' '' then convert(char(10),getdate(),20)  
		 when null then convert(char(10),getdate(),20)
		 else lastoperatedate end
			 + '' '' +
			 isnull(lastoperatetime,convert(char(10), getdate(),108))
))
-convert(float,convert(datetime,createdate+'' ''+createtime))) 
- 
(select sum(isnull(convert(float,nodepasshour),0)+isnull(convert(float,nodepassminute),0)/24) from workflow_nodelink where workflowid=workflow_requestbase.workflowid))>0 
and exists (select 1 from workflow_currentoperator where requestid=workflow_requestbase.requestid '+@sqlStr_1+') and status is not null and status!=''''  
and exists (select 1 from workflow_nodelink where workflowid=workflow_requestbase.workflowid and (convert(float,nodepasshour)>0 or convert(float,nodepassminute)>0)) '+@sqlStr_2+') 
as t  order by spends desc') 
else 
exec ('
select * from (select top '+@countss+' * from (
select top '+@num+' * from (
select requestname,workflow_requestbase.requestid,workflow_requestbase.workflowid, 
(24*(convert(float,
convert(datetime,
         case lastoperatedate
		 when '' '' then convert(char(10),getdate(),20)  
		 when null then convert(char(10),getdate(),20)
		 else lastoperatedate end
			 + '' '' +
			 isnull(lastoperatetime,convert(char(10), getdate(),108))
))
-
convert(float,convert(datetime,createdate+'' ''+createtime))) 
- 
(select sum(isnull(convert(float,nodepasshour),0)+isnull(convert(float,nodepassminute),0)/24) 
from workflow_nodelink where workflowid=workflow_requestbase.workflowid)) 
as spends 
from workflow_requestbase 
where  
(24*(convert(float,
convert(datetime,
         case lastoperatedate
		 when '' '' then convert(char(10),getdate(),20)  
		 when null then convert(char(10),getdate(),20)
		 else lastoperatedate end
			 + '' '' +
			 isnull(lastoperatetime,convert(char(10), getdate(),108))
))
-convert(float,convert(datetime,createdate+'' ''+createtime))) 
- (select sum(isnull(convert(float,nodepasshour),0)+isnull(convert(float,nodepassminute),0)/24) from workflow_nodelink where workflowid=workflow_requestbase.workflowid))>0 
and exists (select 1 from workflow_currentoperator where requestid=workflow_requestbase.requestid '+@sqlStr_1+') 
and status is not null and status!=''''  
and exists (select 1 from workflow_nodelink where workflowid=workflow_requestbase.workflowid and (convert(float,nodepasshour)>0 or convert(float,nodepassminute)>0)) '+@sqlStr_2+') 
as t  order by spends desc) as tt order by spends) as temp order by spends desc')
go
