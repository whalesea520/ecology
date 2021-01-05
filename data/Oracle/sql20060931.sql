INSERT INTO HtmlLabelIndex values(19709,'上级目标') 
/
INSERT INTO HtmlLabelInfo VALUES(19709,'上级目标',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19709,'Parent KPI',8) 
/

INSERT INTO HtmlLabelIndex values(19765,'变更记录') 
/
INSERT INTO HtmlLabelInfo VALUES(19765,'变更记录',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19765,'Revision',8) 
/
INSERT INTO HtmlLabelIndex values(19766,'原始数据') 
/
INSERT INTO HtmlLabelIndex values(19767,'更新数据') 
/
INSERT INTO HtmlLabelInfo VALUES(19766,'原始数据',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19766,'Original Value',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19767,'更新数据',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19767,'Updated Value',8) 
/

INSERT INTO HtmlLabelIndex values(19775,'您确定批准变更吗？') 
/
INSERT INTO HtmlLabelInfo VALUES(19775,'您确定批准变更吗？',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19775,'Are you sure?',8) 
/
INSERT INTO HtmlLabelIndex values(19776,'您确定取消变更吗？') 
/
INSERT INTO HtmlLabelInfo VALUES(19776,'您确定取消变更吗？',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19776,'Are you sure?',8) 
/


create table HrmKPIRevision (
    id integer ,
    goalId integer,
    operator integer,
    operateTime varchar2(20),
    operateType char(1),
    clientIP varchar2(20)
)
/
create sequence HrmKPIRevision_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmKPIRevision_Trigger
before insert on HrmKPIRevision
for each row
begin
select HrmKPIRevision_id.nextval into :new.id from dual;
end;
/

create table HrmKPIRevisionDetail (
    id integer ,
    goalId integer,
    operator integer,
    operateTime varchar2(20),
    operateType char(1),
    clientIP varchar2(20),
    fieldName varchar2(100),
    originalValue varchar2(500),
    updatedValue varchar2(500)
)
/
create sequence HrmKPIReviDeta_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmKPIReviDeta_Trigger
before insert on HrmKPIRevisionDetail
for each row
begin
select HrmKPIReviDeta_id.nextval into :new.id from dual;
end;
/


alter table HrmPerformanceGoal add modifyStatus char(1)
/
alter table HrmPerformanceGoal add modifyUser integer
/
alter table workplan add modifyStatus char(1)
/
alter table workplan add modifyUser integer
/

create table WorkplanRevision(
    id integer ,
    planId integer,
    operator integer,
    operateTime varchar2(20),
    operateType char(1),
    clientIP varchar2(20)
)
/
create sequence WorkplanRevision_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WorkplanRevision_Trigger
before insert on WorkplanRevision
for each row
begin
select WorkplanRevision_id.nextval into :new.id from dual;
end;
/

create table WorkplanRevisionLog(
id integer,
groupId integer,
type_n char (1),
name varchar2 (200),
objId integer,
resourceid varchar2 (200),
oppositeGoal integer,
begindate char (10),
planProperty integer,
principal varchar2 (200),
cowork varchar2 (200),
upPrincipal varchar2 (400),
downPrincipal varchar2 (400),
teamRequest clob,
begintime char (8),
enddate char (10),
endtime char (8),
rbeginDate char (10),
rendDate char (10),
rbeginTime char (8),
rendTime char (8),
cycle char (1),
planType char (1),
percent_n varchar2 (5),
color char (6),
description clob,
requestIdn integer,
requestid varchar2 (500),
projectid varchar2 (500),
crmid varchar2 (500),
docid varchar2 (500),
meetingid varchar2 (100),
status char (1),
isremind integer NULL ,
waketime integer NULL ,
createrid integer NULL ,
createdate char (10),
createtime char (8),
deleted char (1),
taskid varchar2 (500),
urgentLevel char (1),
agentId integer NULL ,
deptId integer NULL ,
subcompanyId integer NULL ,
createrType char (1),
finishRemind integer NULL ,
relatedprj varchar2 (500),
relatedcus varchar2 (500),
relatedwf varchar2 (500),
relateddoc varchar2 (500),
allShare char (1),
planDate varchar2 (20)
)
/

alter table WorkplanRevisionLog add modifyStatus char(1)
/

alter table WorkplanRevisionLog add modifyUser integer
/

create table HrmKPIRevisionLog(
id integer NOT NULL ,
goalName varchar2 (100),
objId integer NULL ,
goalCode varchar2 (25),
parentId integer NULL ,
goalDate varchar2 (10),
workUnit integer NULL ,
operations integer NULL ,
type_t integer NULL ,
startDate varchar2 (50),
endDate varchar2 (50),
goalType char (1),
cycle char (1),
property char (1),
unit varchar2 (10),
targetValue number(15, 3) NULL ,
previewValue number(15, 3) NULL ,
memo varchar2 (1000),
percent_n varchar2 (5),
pointStdId integer NULL ,
status char (1),
allShare char (1),
requestId integer NULL ,
groupId integer NULL ,
beExported char (1),
modifyStatus char (1),
modifyUser integer
)
/



CREATE or replace  PROCEDURE KPI_SelectAll
( flag out integer ,
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor)

AS 
begin
open thecursor for
SELECT * FROM HrmPerformanceGoal;
end;
/