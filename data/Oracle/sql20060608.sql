INSERT INTO HtmlLabelIndex values(19023,'报表共享设置') 
/
INSERT INTO HtmlLabelInfo VALUES(19023,'报表共享设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19023,'set the Share of report',8) 
/

INSERT INTO HtmlLabelIndex values(19024,'工作流 － 效率报表') 
/
INSERT INTO HtmlLabelInfo VALUES(19024,'工作流 － 效率报表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19024,'WORKFLOW - EFFICIENCY REPORT FORM',8) 
/

INSERT INTO HtmlLabelIndex values(19059,'平均耗时') 
/
INSERT INTO HtmlLabelInfo VALUES(19059,'平均耗时',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19059,'average spending',8) 
/

INSERT INTO HtmlLabelIndex values(19025,'共享设置') 
/
INSERT INTO HtmlLabelInfo VALUES(19025,'共享设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19025,'SET SHARE',8) 
/
INSERT INTO HtmlLabelIndex values(19101,'超期率') 
/
INSERT INTO HtmlLabelInfo VALUES(19101,'超期率',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19101,'percent of overTime',8) 
/
INSERT INTO HtmlLabelIndex values(19045,'待提交') 
/
INSERT INTO HtmlLabelIndex values(19044,'待批准') 
/
INSERT INTO HtmlLabelInfo VALUES(19044,'待批准',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19044,'approving',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19045,'待提交',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19045,'submiting',8) 
/

INSERT INTO HtmlLabelIndex values(19060,'具体流程') 
/
INSERT INTO HtmlLabelInfo VALUES(19060,'具体流程',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19060,'request',8) 
/

INSERT INTO HtmlLabelIndex values(19081,'超时') 
/
INSERT INTO HtmlLabelInfo VALUES(19081,'超时',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19081,'Overtime',8) 
/

INSERT INTO HtmlLabelIndex values(19079,'耗时') 
/
INSERT INTO HtmlLabelInfo VALUES(19079,'耗时',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19079,'spendtime',8) 
/
INSERT INTO HtmlLabelIndex values(19061,'流程状态') 
/
INSERT INTO HtmlLabelInfo VALUES(19061,'流程状态',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19061,'request status',8) 
/
INSERT INTO HtmlLabelIndex values(19062,'流转中') 
/
INSERT INTO HtmlLabelInfo VALUES(19062,'流转中',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19062,'flowing',8) 
/
INSERT INTO HtmlLabelIndex values(19027,'流程类型统计表') 
/
INSERT INTO HtmlLabelIndex values(19028,'待办事宜统计表') 
/
INSERT INTO HtmlLabelIndex values(19032,'待办事宜最多人员排名表') 
/
INSERT INTO HtmlLabelIndex values(19037,'超期最多人员排名表') 
/
INSERT INTO HtmlLabelIndex values(19030,'人员办理时间分析表') 
/
INSERT INTO HtmlLabelIndex values(19033,'流程效率排名') 
/
INSERT INTO HtmlLabelIndex values(19036,'超期最多流程排名表') 
/
INSERT INTO HtmlLabelIndex values(19035,'节点操作效率人员排名表') 
/
INSERT INTO HtmlLabelIndex values(19029,'流程流程时间分析表') 
/
INSERT INTO HtmlLabelIndex values(19034,'耗时最长流程排名表') 
/
INSERT INTO HtmlLabelIndex values(19031,'流程耗时统计表') 
/
INSERT INTO HtmlLabelInfo VALUES(19027,'流程类型统计表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19027,'statistical table of Flow type',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19028,'待办事宜统计表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19028,'statistical table of treats manages the matters concerned',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19029,'流程流程时间分析表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19029,'Analytical table of flow flow time',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19030,'人员办理时间分析表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19030,'Analytical table of the time that personnel handles',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19031,'流程耗时统计表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19031,'Statistical table of the flow consumes time',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19032,'待办事宜最多人员排名表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19032,'Order table of most personnel that treats manages matters concerned',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19033,'流程效率排名',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19033,'the oder of Flow efficiency',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19034,'耗时最长流程排名表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19034,'Order table of Consumes when longest flow',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19035,'节点操作效率人员排名表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19035,'Order table of node operating efficiency personnel',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19036,'超期最多流程排名表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19036,'Order table of most flows of Goes over the time limit',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19037,'超期最多人员排名表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19037,'Order table of most personnel of Goes over the time limit',8) 
/

INSERT INTO HtmlLabelIndex values(19083,'总') 
/
INSERT INTO HtmlLabelIndex values(19082,'排名') 
/
INSERT INTO HtmlLabelInfo VALUES(19082,'排名',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19082,'sort',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19083,'总',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19083,'total',8) 
/

CALL MMConfig_U_ByInfoInsert (4,15)
/
CALL MMInfo_Insert (479,19023,'报表共项设置','/workflow/flowReport/ReportShareSet.jsp','mainFrame',4,1,15,0,'',0,'',0,'','',0,'','',3)
/


insert into SystemRights (id,rightdesc,righttype) values (646,'报表共项设置','5') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (646,8,'SET WORKFLOW - EFFICIENCY REPORT FORM','SET WORKFLOW - EFFICIENCY REPORT FORM') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (646,7,'效率报表共项设置','效率报表共项设置') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4146,'报表共项设置','REPORTSHARE:WORKFLOW',646) 
/



CALL MMConfig_U_ByInfoInsert (203,3)
/
CALL MMInfo_Insert (482,19029,'流程流转时间分析表','/workflow/flowReport/FlowTimeAnalyse.jsp','mainFrame',203,2,3,0,'',0,'',0,'','',0,'','',3)
/

CALL MMConfig_U_ByInfoInsert (203,4)
/
CALL MMInfo_Insert (483,19030,'人员办理时间分析表','/workflow/flowReport/HandleRequestAnalyse.jsp','mainFrame',203,2,4,0,'',0,'',0,'','',0,'','',3)
/

CALL MMConfig_U_ByInfoInsert (203,9)
/
CALL MMInfo_Insert (485,19033,'流程效率排名','','',203,2,9,0,'',0,'',0,'','',0,'','',3)
/

CALL MMConfig_U_ByInfoInsert (203,1)
/
CALL MMInfo_Insert (480,19027,'流程类型统计表','/workflow/flowReport/FlowTypeStat.jsp','mainFrame',203,2,1,0,'',0,'',0,'','',0,'','',3)
/

CALL MMConfig_U_ByInfoInsert (203,5)
/
CALL MMInfo_Insert (484,19031,'流程耗时时间统计表','/workflow/flowReport/SpendTimeStat.jsp','mainFrame',203,2,5,0,'',0,'',0,'','',0,'','',3)
/

CALL MMConfig_U_ByInfoInsert (203,2)
/
CALL MMInfo_Insert (481,19028,'待办事宜统计表','/workflow/flowReport/PendingRequestStat.jsp','mainFrame',203,2,2,0,'',0,'',0,'','',0,'','',3)
/

CALL MMConfig_U_ByInfoInsert (485,1)
/
CALL MMInfo_Insert (486,19032,'待办事宜最多人员排名表','/workflow/flowReport/MostPendingRequest.jsp','mainFrame',485,3,1,0,'',0,'',0,'','',0,'','',3)
/

CALL MMConfig_U_ByInfoInsert (485,3)
/
CALL MMInfo_Insert (488,19035,'节点操作效率人员排名表','/workflow/flowReport/NodeOperatorfficiency.jsp','mainFrame',485,3,3,0,'',0,'',0,'','',0,'','',3)
/

CALL MMConfig_U_ByInfoInsert (485,5)
/
CALL MMInfo_Insert (490,19037,'超期最多人员排名表','/workflow/flowReport/MostExceedPerson.jsp','mainFrame',485,3,5,0,'',0,'',0,'','',0,'','',3)
/

CALL MMConfig_U_ByInfoInsert (485,2)
/
CALL MMInfo_Insert (487,19034,'耗时最长流程排名表','/workflow/flowReport/MostSpendTime.jsp','mainFrame',485,3,2,0,'',0,'',0,'','',0,'','',2)
/

CALL MMConfig_U_ByInfoInsert (485,4)
/
CALL MMInfo_Insert (489,19036,'超期最多流程排名表','/workflow/flowReport/MostExceedFlow.jsp','mainFrame',485,3,4,0,'',0,'',0,'','',0,'','',3)
/


/******索引******/
CREATE UNIQUE  INDEX workflow_requestid ON workflow_requestbase
(
	requestid  ASC
	) 
/

CREATE  INDEX hrmresource_id ON hrmresource
(
	id  ASC,
	departmentid asc
	) 
/

CREATE  INDEX idandstatus ON workflow_requestbase
(
	requestid  ASC,
	status asc
	) 
/

CREATE  INDEX workflowUserAndId ON workflow_currentoperator
(
	requestid  ASC,
	userid  ASC,
	workflowid asc
	) 
/

create  INDEX UserAndRequestId ON workflow_currentoperator
(   userid  ASC,
	requestid  ASC
	
	
	) 
/





create or replace view WorkFlowPending (uerid,counts) as 
SELECT      userid, COUNT(requestid) AS Expr1
FROM        workflow_currentoperator
WHERE     (isremark IN ('0', '1', '5')) 
AND (islasttimes = 1) AND (usertype = 0) and exists (select 1 from hrmresource where hrmresource.id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3) )
GROUP BY userid
ORDER BY COUNT(requestid) desc
/

create or replace view MostExceedPerson as 

select   userid,count(distinct workflow_requestbase.requestid) as counts,
(select count(requestid) from workflow_requestbase b 
where exists (select 1 from workflow_currentoperator  a 
where a.requestid=b.requestid 
and a.userid=workflow_currentoperator.userid) 
and b.status is not null ) as countall,

to_number(count(distinct workflow_requestbase.requestid)*100)/to_number((select count(requestid) from workflow_requestbase b 
where exists (select 1 from workflow_currentoperator  a 
where a.requestid=b.requestid 
and a.userid=workflow_currentoperator.userid) 
and b.status is not null ) ) as percents

from workflow_currentoperator,workflow_requestbase 
where  workflow_currentoperator.requestid=workflow_requestbase.requestid  
and (24*
(
to_date(NVL2(lastoperatedate ,lastoperatedate||' '||lastoperatetime,to_char(sysdate,'YYYY-MM-DD HH24:MI:SS')),'YYYY-MM-DD HH24:MI:SS') - 
to_date(createdate||' '||createtime,'YYYY-MM-DD HH24:MI:SS')
)
-
(
select 
sum(NVL(to_number(nodepasshour),0)+NVL(to_number(nodepassminute),0)/24) 
from workflow_nodelink where workflowid=workflow_requestbase.workflowid
)

)>0 
and   workflow_requestbase.status is not null   
and exists (select 1 from workflow_nodelink where workflowid=workflow_requestbase.workflowid
and  (workflow_currentoperator.usertype = 0) and exists (select 1 from hrmresource where hrmresource.id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))  
and (to_number(NVL(nodepasshour,0))>0 or to_number(nvl(nodepassminute,0))>0))
group by userid
order by percents desc
/

INSERT INTO HtmlLabelIndex values(19026,'效率报表') 
/
INSERT INTO HtmlLabelInfo VALUES(19026,'效率报表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19026,'EFFICIENCY REPORT FORM',8) 
/

update htmllabelinfo set labelname='流程流转时间分析表' where indexid=19029 and languageid=7
/

update  SystemRights set rightdesc='报表共享设置' where id=646
/
update SystemRightsLanguage set  rightdesc='效率报表共享设置' ,rightname='效率报表共享设置' where id=646 and languageid=7
/
update SystemRightDetail set rightdetailname='报表共享设置' where id=4146
/

UPDATE MainMenuInfo SET defaultIndex=1 WHERE id=480
/
UPDATE MainMenuInfo SET defaultIndex=2 WHERE id=481
/
UPDATE MainMenuInfo SET defaultIndex=3 WHERE id=482
/
UPDATE MainMenuInfo SET defaultIndex=4 WHERE id=483
/
UPDATE MainMenuInfo SET defaultIndex=5 WHERE id=484
/
UPDATE MainMenuInfo SET defaultIndex=6 WHERE id=233
/
UPDATE MainMenuInfo SET defaultIndex=7 WHERE id=234
/
UPDATE MainMenuInfo SET defaultIndex=8 WHERE id=474
/
UPDATE MainMenuInfo SET defaultIndex=9 WHERE id=485
/
UPDATE MainMenuInfo SET defaultIndex=10 WHERE id=236
/
DELETE FROM MainMenuInfo WHERE id=232 OR id=235
/












