INSERT INTO HtmlLabelIndex values(19023,'报表共享设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(19023,'报表共享设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19023,'set the Share of report',8) 
GO

INSERT INTO HtmlLabelIndex values(19024,'工作流 － 效率报表') 
GO
INSERT INTO HtmlLabelInfo VALUES(19024,'工作流 － 效率报表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19024,'WORKFLOW - EFFICIENCY REPORT FORM',8) 
GO

INSERT INTO HtmlLabelIndex values(19059,'平均耗时') 
GO
INSERT INTO HtmlLabelInfo VALUES(19059,'平均耗时',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19059,'average spending',8) 
GO

INSERT INTO HtmlLabelIndex values(19025,'共享设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(19025,'共享设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19025,'SET SHARE',8) 
GO
INSERT INTO HtmlLabelIndex values(19101,'超期率') 
GO
INSERT INTO HtmlLabelInfo VALUES(19101,'超期率',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19101,'percent of overTime',8) 
GO
INSERT INTO HtmlLabelIndex values(19045,'待提交') 
GO
INSERT INTO HtmlLabelIndex values(19044,'待批准') 
GO
INSERT INTO HtmlLabelInfo VALUES(19044,'待批准',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19044,'approving',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19045,'待提交',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19045,'submiting',8) 
GO

INSERT INTO HtmlLabelIndex values(19060,'具体流程') 
GO
INSERT INTO HtmlLabelInfo VALUES(19060,'具体流程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19060,'request',8) 
GO

INSERT INTO HtmlLabelIndex values(19081,'超时') 
GO
INSERT INTO HtmlLabelInfo VALUES(19081,'超时',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19081,'Overtime',8) 
GO

INSERT INTO HtmlLabelIndex values(19079,'耗时') 
GO
INSERT INTO HtmlLabelInfo VALUES(19079,'耗时',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19079,'spendtime',8) 
GO
INSERT INTO HtmlLabelIndex values(19061,'流程状态') 
GO
INSERT INTO HtmlLabelInfo VALUES(19061,'流程状态',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19061,'request status',8) 
GO
INSERT INTO HtmlLabelIndex values(19062,'流转中') 
GO
INSERT INTO HtmlLabelInfo VALUES(19062,'流转中',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19062,'flowing',8) 
GO
INSERT INTO HtmlLabelIndex values(19027,'流程类型统计表') 
GO
INSERT INTO HtmlLabelIndex values(19028,'待办事宜统计表') 
GO
INSERT INTO HtmlLabelIndex values(19032,'待办事宜最多人员排名表') 
GO
INSERT INTO HtmlLabelIndex values(19037,'超期最多人员排名表') 
GO
INSERT INTO HtmlLabelIndex values(19030,'人员办理时间分析表') 
GO
INSERT INTO HtmlLabelIndex values(19033,'流程效率排名') 
GO
INSERT INTO HtmlLabelIndex values(19036,'超期最多流程排名表') 
GO
INSERT INTO HtmlLabelIndex values(19035,'节点操作效率人员排名表') 
GO
INSERT INTO HtmlLabelIndex values(19029,'流程流程时间分析表') 
GO
INSERT INTO HtmlLabelIndex values(19034,'耗时最长流程排名表') 
GO
INSERT INTO HtmlLabelIndex values(19031,'流程耗时统计表') 
GO
INSERT INTO HtmlLabelInfo VALUES(19027,'流程类型统计表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19027,'statistical table of Flow type',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19028,'待办事宜统计表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19028,'statistical table of treats manages the matters concerned',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19029,'流程流程时间分析表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19029,'Analytical table of flow flow time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19030,'人员办理时间分析表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19030,'Analytical table of the time that personnel handles',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19031,'流程耗时统计表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19031,'Statistical table of the flow consumes time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19032,'待办事宜最多人员排名表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19032,'Order table of most personnel that treats manages matters concerned',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19033,'流程效率排名',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19033,'the oder of Flow efficiency',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19034,'耗时最长流程排名表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19034,'Order table of Consumes when longest flow',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19035,'节点操作效率人员排名表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19035,'Order table of node operating efficiency personnel',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19036,'超期最多流程排名表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19036,'Order table of most flows of Goes over the time limit',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19037,'超期最多人员排名表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19037,'Order table of most personnel of Goes over the time limit',8) 
GO

INSERT INTO HtmlLabelIndex values(19083,'总') 
GO
INSERT INTO HtmlLabelIndex values(19082,'排名') 
GO
INSERT INTO HtmlLabelInfo VALUES(19082,'排名',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19082,'sort',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19083,'总',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19083,'total',8) 
GO

EXECUTE MMConfig_U_ByInfoInsert 4,15
GO
EXECUTE MMInfo_Insert 479,19023,'报表共项设置','/workflow/flowReport/ReportShareSet.jsp','mainFrame',4,1,15,0,'',0,'',0,'','',0,'','',3
GO


insert into SystemRights (id,rightdesc,righttype) values (646,'报表共项设置','5') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (646,8,'SET WORKFLOW - EFFICIENCY REPORT FORM','SET WORKFLOW - EFFICIENCY REPORT FORM') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (646,7,'效率报表共项设置','效率报表共项设置') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4146,'报表共项设置','REPORTSHARE:WORKFLOW',646) 
GO



EXECUTE MMConfig_U_ByInfoInsert 203,3
GO
EXECUTE MMInfo_Insert 482,19029,'流程流转时间分析表','/workflow/flowReport/FlowTimeAnalyse.jsp','mainFrame',203,2,3,0,'',0,'',0,'','',0,'','',3
GO

EXECUTE MMConfig_U_ByInfoInsert 203,4
GO
EXECUTE MMInfo_Insert 483,19030,'人员办理时间分析表','/workflow/flowReport/HandleRequestAnalyse.jsp','mainFrame',203,2,4,0,'',0,'',0,'','',0,'','',3
GO

EXECUTE MMConfig_U_ByInfoInsert 203,9
GO
EXECUTE MMInfo_Insert 485,19033,'流程效率排名','','',203,2,9,0,'',0,'',0,'','',0,'','',3
GO

EXECUTE MMConfig_U_ByInfoInsert 203,1
GO
EXECUTE MMInfo_Insert 480,19027,'流程类型统计表','/workflow/flowReport/FlowTypeStat.jsp','mainFrame',203,2,1,0,'',0,'',0,'','',0,'','',3
GO

EXECUTE MMConfig_U_ByInfoInsert 203,5
GO
EXECUTE MMInfo_Insert 484,19031,'流程耗时时间统计表','/workflow/flowReport/SpendTimeStat.jsp','mainFrame',203,2,5,0,'',0,'',0,'','',0,'','',3
GO

EXECUTE MMConfig_U_ByInfoInsert 203,2
GO
EXECUTE MMInfo_Insert 481,19028,'待办事宜统计表','/workflow/flowReport/PendingRequestStat.jsp','mainFrame',203,2,2,0,'',0,'',0,'','',0,'','',3
GO

EXECUTE MMConfig_U_ByInfoInsert 485,1
GO
EXECUTE MMInfo_Insert 486,19032,'待办事宜最多人员排名表','/workflow/flowReport/MostPendingRequest.jsp','mainFrame',485,3,1,0,'',0,'',0,'','',0,'','',3
GO

EXECUTE MMConfig_U_ByInfoInsert 485,3
GO
EXECUTE MMInfo_Insert 488,19035,'节点操作效率人员排名表','/workflow/flowReport/NodeOperatorfficiency.jsp','mainFrame',485,3,3,0,'',0,'',0,'','',0,'','',3
GO

EXECUTE MMConfig_U_ByInfoInsert 485,5
GO
EXECUTE MMInfo_Insert 490,19037,'超期最多人员排名表','/workflow/flowReport/MostExceedPerson.jsp','mainFrame',485,3,5,0,'',0,'',0,'','',0,'','',3
GO

EXECUTE MMConfig_U_ByInfoInsert 485,2
GO
EXECUTE MMInfo_Insert 487,19034,'耗时最长流程排名表','/workflow/flowReport/MostSpendTime.jsp','mainFrame',485,3,2,0,'',0,'',0,'','',0,'','',2
GO

EXECUTE MMConfig_U_ByInfoInsert 485,4
GO
EXECUTE MMInfo_Insert 489,19036,'超期最多流程排名表','/workflow/flowReport/MostExceedFlow.jsp','mainFrame',485,3,4,0,'',0,'',0,'','',0,'','',3
GO





/******索引******/
CREATE  INDEX workflow_requestid ON workflow_requestbase
(
	requestid  ASC
	) 
go

CREATE  INDEX hrmresource_id ON hrmresource
(
	id  ASC,
	departmentid asc
	) 
go

CREATE  INDEX idandstatus ON workflow_requestbase
(
	requestid  ASC,
	status asc
	) 
go

CREATE  INDEX workflowUserAndId ON workflow_currentoperator
(
	requestid  ASC,
	userid  ASC,
	workflowid asc
	) 
go

create  INDEX UserAndRequestId ON workflow_currentoperator
(   userid  ASC,
	requestid  ASC
	
	
	) 
go


create view WorkFlowPending (uerid,counts) as 
SELECT     TOP 100 PERCENT userid, COUNT(requestid) AS Expr1
FROM        workflow_currentoperator
WHERE     (isremark IN ('0', '1', '5')) AND (islasttimes = 1) AND (usertype = 0) and exists (select 1 from hrmresource where hrmresource.id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3) )
GROUP BY userid
ORDER BY COUNT(requestid) desc
go


create view MostExceedPerson as 

select top  100 percent userid,count(distinct workflow_requestbase.requestid) as counts,
(select count(requestid) from workflow_requestbase b 
where exists (select 1 from workflow_currentoperator  a 
where a.requestid=b.requestid 
and a.userid=workflow_currentoperator.userid) 
and b.status is not null and b.status!='') as countall,

convert(float,count(distinct workflow_requestbase.requestid)*100)/convert(float,(select count(requestid) from workflow_requestbase b 
where exists (select 1 from workflow_currentoperator  a 
where a.requestid=b.requestid 
and a.userid=workflow_currentoperator.userid) 
and b.status is not null and b.status!='') ) as percents

from workflow_currentoperator,workflow_requestbase 
where  workflow_currentoperator.requestid=workflow_requestbase.requestid  and (24*(convert(float,convert(datetime,isnull(lastoperatedate ,convert(char(10),getdate(),20)) 
+' '+isnull(lastoperatetime,convert(char(10),getdate(),108))))-convert(float,convert(datetime,createdate+' '+createtime)))
-
(select 
sum(isnull(convert(float,nodepasshour),0)+isnull(convert(float,nodepassminute),0)/24) 
from workflow_nodelink where workflowid=workflow_requestbase.workflowid))>0 
and   workflow_requestbase.status is not null and workflow_requestbase.status!=''  
and exists (select 1 from workflow_nodelink where workflowid=workflow_requestbase.workflowid
and  (workflow_currentoperator.usertype = 0) and exists (select 1 from hrmresource where hrmresource.id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))  
and (convert(float,nodepasshour)>0 or convert(float,nodepassminute)>0))
group by userid
order by percents desc
go


create   PROCEDURE MostExceedFlow_Get 
@sqlStr_1	varchar(4000),
@sqlStr_2	varchar(4000), 
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
exec ('select requestname,workflow_requestbase.requestid,workflow_requestbase.workflowid,
(24*(convert(float,convert(datetime,isnull(lastoperatedate ,convert(char(10),getdate(),20)) 
+'' ''+isnull(lastoperatetime,convert(char(10),getdate(),108))))-convert(float,convert(datetime,createdate+'' ''+createtime)))
-
(select 
sum(isnull(convert(float,nodepasshour),0)+isnull(convert(float,nodepassminute),0)/24) 
from workflow_nodelink where workflowid=workflow_requestbase.workflowid))
 as spends
	 from workflow_requestbase where  (24*(convert(float,convert(datetime,isnull(lastoperatedate ,convert(char(10),getdate(),20)) 
+'' ''+isnull(lastoperatetime,convert(char(10),getdate(),108))))-convert(float,convert(datetime,createdate+'' ''+createtime)))
-
(select 
sum(isnull(convert(float,nodepasshour),0)+isnull(convert(float,nodepassminute),0)/24) 
from workflow_nodelink where workflowid=workflow_requestbase.workflowid))>0 and 
	  exists (select 1 from workflow_currentoperator where requestid=workflow_requestbase.requestid '+@sqlStr_1+') and status is not null and status!=''''  and exists (select 1 from workflow_nodelink where workflowid=workflow_requestbase.workflowid and (convert(float,nodepasshour)>0 or convert(float,nodepassminute)>0))
'+@sqlStr_2+' order by spends desc')

GO


create   PROCEDURE MostSpendTime_Get 
@sqlStr_1	varchar(4000), 
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
exec ('select * 
	 from SpendTimeStat where 1=1  '+@sqlStr_1+'
	')

GO

create  PROCEDURE NodeOperatorTime 
@sqlStr_1	varchar(4000), 
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
exec('select userid,24*avg(convert(float,convert(datetime,
case isremark when  ''2'' then operatedate  else 
isnull(operatedate ,convert(char(10),getdate(),20)) end  +'' ''+case isremark when ''2'' then operatetime else  isnull(operatetime,
convert(char(10),getdate(),108)) end ))
-convert(float,convert(datetime,receivedate+'' ''+receivetime))) as spends
from workflow_currentoperator where exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid 
and status is not null and status!='''' )
'+@sqlStr_1+'  group by userid order by spends desc')

go

create  PROCEDURE PersonNodeTime_Get 
@sqlStr_1	varchar(4000), 
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
exec ('select workflow_currentoperator.userid,workflow_currentoperator.workflowid, workflow_currentoperator.nodeid,(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid),
 24*avg(convert(float,convert(datetime,
case isremark when  ''2'' then operatedate  else 
 isnull(operatedate ,convert(char(10),getdate(),20)) end  
 +'' ''+
case isremark when ''2'' then operatetime else  isnull(operatetime,
convert(char(10),getdate(),108)) end ))
-convert(float,convert(datetime,receivedate+'' ''+receivetime)))
 from workflow_currentoperator,workflow_requestbase 
where workflow_requestbase.requestid=workflow_currentoperator.requestid and (workflow_requestbase.status is not null and workflow_requestbase.status!='''') and workflowtype>1  and isremark<4 '+@sqlStr_1+'
and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and  workflowid=workflow_currentoperator.workflowid and nodetype<3) 
group by  workflow_currentoperator.userid,workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid
order by  workflow_currentoperator.userid,workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid')

GO

create   PROCEDURE SpendTimeStat_Get 
@sqlStr_1	varchar(4000),
@sqlStr_2	varchar(4000), 
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
exec ('select  requestname,workflow_requestbase.requestid,workflow_requestbase.workflowid,status,24*(convert(float,convert(datetime,isnull(lastoperatedate ,convert(char(10),getdate(),20)) 
	 +'' ''+isnull(lastoperatetime,convert(char(10),getdate(),108))))-convert(float,convert(datetime,createdate+'' ''+createtime))) as spends 
	 from workflow_requestbase where  
	  exists (select 1 from workflow_currentoperator where requestid=workflow_requestbase.requestid '+@sqlStr_1+' ) and status is not null and status!='''' '+@sqlStr_2+'
	 order by spends desc,workflow_requestbase.workflowid asc')

GO

create  PROCEDURE WorkFlowNodeTime_Get 
@sqlStr_1	varchar(4000), 
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
exec ('select workflow_currentoperator.workflowid, workflow_currentoperator.nodeid,(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid),
 24*avg(convert(float,convert(datetime,
case isremark when  ''2'' then operatedate  else 
 isnull(operatedate ,convert(char(10),getdate(),20)) end  
 +'' ''+
case isremark when ''2'' then operatetime else  isnull(operatetime,
convert(char(10),getdate(),108)) end ))
-convert(float,convert(datetime,receivedate+'' ''+receivetime)))
 from workflow_currentoperator,workflow_requestbase 
where workflow_requestbase.requestid=workflow_currentoperator.requestid and (workflow_requestbase.status is not null and workflow_requestbase.status!='''') and workflowtype>1  and isremark<4 '+@sqlStr_1+'
and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and  workflowid=workflow_currentoperator.workflowid and nodetype<3) 
group by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid
order by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid')



GO


create  PROCEDURE WorkFlowSysNodeTime_Get 
@sqlStr_1	varchar(4000), 
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
exec ('select workflow_currentoperator.workflowid, workflow_currentoperator.nodeid,(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid),
 24*avg(convert(float,convert(datetime,
case isremark when  ''2'' then operatedate  else 
 isnull(operatedate ,convert(char(10),getdate(),20)) end  
 +'' ''+
case isremark when ''2'' then operatetime else  isnull(operatetime,
convert(char(10),getdate(),108)) end ))
-convert(float,convert(datetime,receivedate+'' ''+receivetime)))
 from workflow_currentoperator,workflow_requestbase 
where workflow_requestbase.requestid=workflow_currentoperator.requestid and (workflow_requestbase.status is not null and workflow_requestbase.status!='''') and workflowtype>1  and isremark<4 
and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and  workflowid=workflow_currentoperator.workflowid and nodetype<3) 
group by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid
order by  workflow_currentoperator.workflowid ,workflow_currentoperator.nodeid')



GO



create   PROCEDURE WorkFlowTypeNodeTime_Get 
@sqlStr_1	varchar(4000), 
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
exec ('select workflow_currentoperator.requestid, workflow_currentoperator.nodeid,(select requestname from workflow_requestbase where requestid=workflow_currentoperator.requestid ),(select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid),
 24*avg(convert(float,convert(datetime,
case isremark when  ''2'' then operatedate  else 
 isnull(operatedate ,convert(char(10),getdate(),20)) end  
 +'' ''+
case isremark when ''2'' then operatetime else  isnull(operatetime,
convert(char(10),getdate(),108)) end ))
-convert(float,convert(datetime,receivedate+'' ''+receivetime)))
 from workflow_currentoperator,workflow_requestbase 
where workflow_requestbase.requestid=workflow_currentoperator.requestid and (workflow_requestbase.status is not null and workflow_requestbase.status!='''') and workflowtype>1  and isremark<4 '+@sqlStr_1+'
and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and  workflowid=workflow_currentoperator.workflowid and nodetype<3) 
group by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid
order by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid')



GO

alter   PROCEDURE MostExceedFlow_Get 
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
exec ('select top '+@prepage+' * from (select requestname,workflow_requestbase.requestid,workflow_requestbase.workflowid,
(24*(convert(float,convert(datetime,isnull(lastoperatedate ,convert(char(10),getdate(),20)) 
+'' ''+isnull(lastoperatetime,convert(char(10),getdate(),108))))-convert(float,convert(datetime,createdate+'' ''+createtime)))
-
(select 
sum(isnull(convert(float,nodepasshour),0)+isnull(convert(float,nodepassminute),0)/24) 
from workflow_nodelink where workflowid=workflow_requestbase.workflowid))
 as spends
	 from workflow_requestbase where  (24*(convert(float,convert(datetime,isnull(lastoperatedate ,convert(char(10),getdate(),20)) 
+'' ''+isnull(lastoperatetime,convert(char(10),getdate(),108))))-convert(float,convert(datetime,createdate+'' ''+createtime)))
-
(select 
sum(isnull(convert(float,nodepasshour),0)+isnull(convert(float,nodepassminute),0)/24) 
from workflow_nodelink where workflowid=workflow_requestbase.workflowid))>0 and 
	  exists (select 1 from workflow_currentoperator where requestid=workflow_requestbase.requestid '+@sqlStr_1+') and status is not null and status!=''''  and exists (select 1 from workflow_nodelink where workflowid=workflow_requestbase.workflowid and (convert(float,nodepasshour)>0 or convert(float,nodepassminute)>0))
'+@sqlStr_2+') as t  order by spends desc')
else
exec ('select * from (select top '+@countss+' * from (select top '+@num+' * from (select requestname,workflow_requestbase.requestid,workflow_requestbase.workflowid,
(24*(convert(float,convert(datetime,isnull(lastoperatedate ,convert(char(10),getdate(),20)) 
+'' ''+isnull(lastoperatetime,convert(char(10),getdate(),108))))-convert(float,convert(datetime,createdate+'' ''+createtime)))
-
(select 
sum(isnull(convert(float,nodepasshour),0)+isnull(convert(float,nodepassminute),0)/24) 
from workflow_nodelink where workflowid=workflow_requestbase.workflowid))
 as spends
	 from workflow_requestbase where  (24*(convert(float,convert(datetime,isnull(lastoperatedate ,convert(char(10),getdate(),20)) 
+'' ''+isnull(lastoperatetime,convert(char(10),getdate(),108))))-convert(float,convert(datetime,createdate+'' ''+createtime)))
-
(select 
sum(isnull(convert(float,nodepasshour),0)+isnull(convert(float,nodepassminute),0)/24) 
from workflow_nodelink where workflowid=workflow_requestbase.workflowid))>0 and 
	  exists (select 1 from workflow_currentoperator where requestid=workflow_requestbase.requestid '+@sqlStr_1+') and status is not null and status!=''''  and exists (select 1 from workflow_nodelink where workflowid=workflow_requestbase.workflowid and (convert(float,nodepasshour)>0 or convert(float,nodepassminute)>0))
'+@sqlStr_2+') as t  order by spends desc) as tt order by spends) as temp order by spends desc')

go

create PROCEDURE MostSpendFlowStat_count 

@sqlStr_1	varchar(4000),
@sqlStr_2	varchar(4000), 
@num     int,
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS

BEGIN

exec ('select count(*)  from (select top '+@num+' * from (select requestname,workflow_requestbase.requestid,workflow_requestbase.workflowid,
(24*(convert(float,convert(datetime,isnull(lastoperatedate ,convert(char(10),getdate(),20)) 
+'' ''+isnull(lastoperatetime,convert(char(10),getdate(),108))))-convert(float,convert(datetime,createdate+'' ''+createtime)))
-
(select 
sum(isnull(convert(float,nodepasshour),0)+isnull(convert(float,nodepassminute),0)/24) 
from workflow_nodelink where workflowid=workflow_requestbase.workflowid))
 as spends
	 from workflow_requestbase where  (24*(convert(float,convert(datetime,isnull(lastoperatedate ,convert(char(10),getdate(),20)) 
+'' ''+isnull(lastoperatetime,convert(char(10),getdate(),108))))-convert(float,convert(datetime,createdate+'' ''+createtime)))
-
(select 
sum(isnull(convert(float,nodepasshour),0)+isnull(convert(float,nodepassminute),0)/24) 
from workflow_nodelink where workflowid=workflow_requestbase.workflowid))>0 and 
	  exists (select 1 from workflow_currentoperator where requestid=workflow_requestbase.requestid '+@sqlStr_1+') and status is not null and status!=''''  and exists (select 1 from workflow_nodelink where workflowid=workflow_requestbase.workflowid and (convert(float,nodepasshour)>0 or convert(float,nodepassminute)>0))
'+@sqlStr_2+' ) as temp order by spends desc ) as t ')
end
Go

create PROCEDURE SpendTimeStat_count  
@sqlStr_1	varchar(4000),
@sqlStr_2	varchar(4000), 
@num     int,
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS
BEGIN
exec ('select count(*)  from (select top '+@num+' * from (select  requestname,workflow_requestbase.requestid,workflow_requestbase.workflowid,status,24*(convert(float,convert(datetime,isnull(lastoperatedate ,convert(char(10),getdate(),20)) 
	 +'' ''+isnull(lastoperatetime,convert(char(10),getdate(),108))))-convert(float,convert(datetime,createdate+'' ''+createtime))) as spends 
	 from workflow_requestbase where  
	  exists (select 1 from workflow_currentoperator where requestid=workflow_requestbase.requestid '+@sqlStr_1+' ) and status is not null and status!='''' '+@sqlStr_2+'
	 ) as temp order by spends desc ) as t ')

END
GO

INSERT INTO HtmlLabelIndex values(19026,'效率报表') 
GO
INSERT INTO HtmlLabelInfo VALUES(19026,'效率报表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19026,'EFFICIENCY REPORT FORM',8) 
GO

update htmllabelinfo set labelname='流程流转时间分析表' where indexid=19029 and languageid=7
go

update  SystemRights set rightdesc='报表共享设置' where id=646
GO
update SystemRightsLanguage set  rightdesc='效率报表共享设置' ,rightname='效率报表共享设置' where id=646 and languageid=7
GO
update SystemRightDetail set rightdetailname='报表共享设置' where id=4146
GO

UPDATE MainMenuInfo SET defaultIndex=1 WHERE id=480
GO
UPDATE MainMenuInfo SET defaultIndex=2 WHERE id=481
GO
UPDATE MainMenuInfo SET defaultIndex=3 WHERE id=482
GO
UPDATE MainMenuInfo SET defaultIndex=4 WHERE id=483
GO
UPDATE MainMenuInfo SET defaultIndex=5 WHERE id=484
GO
UPDATE MainMenuInfo SET defaultIndex=6 WHERE id=233
GO
UPDATE MainMenuInfo SET defaultIndex=7 WHERE id=234
GO
UPDATE MainMenuInfo SET defaultIndex=8 WHERE id=474
GO
UPDATE MainMenuInfo SET defaultIndex=9 WHERE id=485
GO
UPDATE MainMenuInfo SET defaultIndex=10 WHERE id=236
GO
DELETE FROM MainMenuInfo WHERE id=232 OR id=235
GO
