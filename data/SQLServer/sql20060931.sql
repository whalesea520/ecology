INSERT INTO HtmlLabelIndex values(19709,'上级目标') 
GO
INSERT INTO HtmlLabelInfo VALUES(19709,'上级目标',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19709,'Parent KPI',8) 
GO

INSERT INTO HtmlLabelIndex values(19765,'变更记录') 
GO
INSERT INTO HtmlLabelInfo VALUES(19765,'变更记录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19765,'Revision',8) 
GO
INSERT INTO HtmlLabelIndex values(19766,'原始数据') 
GO
INSERT INTO HtmlLabelIndex values(19767,'更新数据') 
GO
INSERT INTO HtmlLabelInfo VALUES(19766,'原始数据',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19766,'Original Value',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19767,'更新数据',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19767,'Updated Value',8) 
GO

INSERT INTO HtmlLabelIndex values(19775,'您确定批准变更吗？') 
GO
INSERT INTO HtmlLabelInfo VALUES(19775,'您确定批准变更吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19775,'Are you sure?',8) 
GO
INSERT INTO HtmlLabelIndex values(19776,'您确定取消变更吗？') 
GO
INSERT INTO HtmlLabelInfo VALUES(19776,'您确定取消变更吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19776,'Are you sure?',8) 
GO


create table HrmKPIRevision (
    id int identity,
    goalId int,
    operator int,
    operateTime varchar(20),
    operateType char(1),
    clientIP varchar(20)
)
go

create table HrmKPIRevisionDetail (
    id int identity,
    goalId int,
    operator int,
    operateTime varchar(20),
    operateType char(1),
    clientIP varchar(20),
    fieldName varchar(100),
    originalValue varchar(500),
    updatedValue varchar(500)
)
go

alter table HrmPerformanceGoal add modifyStatus char(1)
go
alter table HrmPerformanceGoal add modifyUser int
go
alter table workplan add modifyStatus char(1)
go
alter table workplan add modifyUser int
go

create table WorkplanRevision(
    id int identity,
    planId int,
    operator int,
    operateTime varchar(20),
    operateType char(1),
    clientIP varchar(20)
)
go

create table WorkplanRevisionLog(
id int,
groupId int,
type_n char (1),
name varchar (200),
objId int,
resourceid varchar (200),
oppositeGoal int,
begindate char (10),
planProperty int,
principal varchar (200),
cowork varchar (200),
upPrincipal varchar (400),
downPrincipal varchar (400),
teamRequest text,
begintime char (8),
enddate char (10),
endtime char (8),
rbeginDate char (10),
rendDate char (10),
rbeginTime char (8),
rendTime char (8),
cycle char (1),
planType char (1),
percent_n varchar (5),
color char (6),
description text,
requestIdn int,
requestid varchar (500),
projectid varchar (500),
crmid varchar (500),
docid varchar (500),
meetingid varchar (100),
status char (1),
isremind int NULL ,
waketime int NULL ,
createrid int NULL ,
createdate char (10),
createtime char (8),
deleted char (1),
taskid varchar (500),
urgentLevel char (1),
agentId int NULL ,
deptId int NULL ,
subcompanyId int NULL ,
createrType char (1),
finishRemind int NULL ,
relatedprj varchar (500),
relatedcus varchar (500),
relatedwf varchar (500),
relateddoc varchar (500),
allShare char (1),
planDate varchar (20)
)
go

alter table WorkplanRevisionLog add modifyStatus char(1),modifyUser int
go


create table HrmKPIRevisionLog(
id int NOT NULL ,
goalName varchar (100),
objId int NULL ,
goalCode varchar (25),
parentId int NULL ,
goalDate varchar (10),
workUnit int NULL ,
operations int NULL ,
type_t int NULL ,
startDate varchar (50),
endDate varchar (50),
goalType char (1),
cycle char (1),
property char (1),
unit varchar (10),
targetValue decimal(15, 3) NULL ,
previewValue decimal(15, 3) NULL ,
memo varchar (1000),
percent_n varchar (5),
pointStdId int NULL ,
status char (1),
allShare char (1),
requestId int NULL ,
groupId int NULL ,
beExported char (1),
modifyStatus char (1),
modifyUser int
)
go



CREATE PROCEDURE KPI_SelectAll(
    @flag int output, 
    @msg varchar(80) output
)AS 
SELECT * FROM HrmPerformanceGoal
SET @flag = 1 
SET @msg = 'OK!'
GO