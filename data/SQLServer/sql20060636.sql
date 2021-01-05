alter   PROCEDURE SpendTimeStat_Get 
@sqlStr_1	varchar(4000),
@sqlStr_2	varchar(4000), 
@pagenum   int ,
@prepage  int,
@count  int,
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
DECLARE 
@num int,
@countss int
set @num=@pagenum*@prepage
set @countss=@count-(@pagenum-1)*@prepage-1
if @pagenum=1
exec ('select top '+@prepage+' * from (select  requestname,workflow_requestbase.requestid,workflow_requestbase.workflowid,status,24*(convert(float,convert(datetime,isnull(lastoperatedate ,convert(char(10),getdate(),20)) 
	 +'' ''+isnull(lastoperatetime,convert(char(10),getdate(),108))))-convert(float,convert(datetime,createdate+'' ''+createtime))) as spends 
	 from workflow_requestbase where  
	  exists (select 1 from workflow_currentoperator where requestid=workflow_requestbase.requestid '+@sqlStr_1+' ) and status is not null and status!='''' '+@sqlStr_2+'
	  ) as t order by spends desc')
else
exec ('select * from (select top '+@countss+' * from (select top '+@num+' * from (select  requestname,workflow_requestbase.requestid,workflow_requestbase.workflowid,status,24*(convert(float,convert(datetime,isnull(lastoperatedate ,convert(char(10),getdate(),20)) 
	 +'' ''+isnull(lastoperatetime,convert(char(10),getdate(),108))))-convert(float,convert(datetime,createdate+'' ''+createtime))) as spends 
	 from workflow_requestbase where  
	  exists (select 1 from workflow_currentoperator where requestid=workflow_requestbase.requestid '+@sqlStr_1+' ) and status is not null and status!='''' '+@sqlStr_2+'
	 ) as temp order by spends desc ) as t  order by spends ) as temp1 order by spends desc')
Go
