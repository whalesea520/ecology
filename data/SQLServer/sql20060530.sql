INSERT INTO HtmlLabelIndex values(19038,'被统计人员') 
GO
INSERT INTO HtmlLabelIndex values(19039,'被统计人员类型') 
GO
INSERT INTO HtmlLabelIndex values(19040,'可查看人员')
GO
INSERT INTO HtmlLabelIndex values(19041,'可查看人员类型') 
GO


INSERT INTO HtmlLabelIndex values(19042,'日程统计设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(19038,'被统计人员',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19038,'member to be statistic',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19039,'被统计人员类型',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19039,'the type of the member to be statistic',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19040,'可查看人员',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19040,'member to visit',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19041,'可查看人员类型',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19041,'the type of the member to visit',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19042,'日程统计设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19042,'Work Pan Report Setting',8) 
GO

INSERT INTO HtmlLabelIndex values(19043,'日程统计报表查看范围') 
GO
INSERT INTO HtmlLabelInfo VALUES(19043,'日程统计报表查看范围',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19043,'Range of Work Plan Report Tracing',8) 
GO



insert into SystemRights (id,rightdesc,righttype) values (647,'日程统计设置','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (647,7,'日程统计设置','日程统计设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (647,8,'Work Plan Report Setting','Work Plan Report Setting') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4147,'日程统计设置','WorkPlanReportSet:Set',647) 
GO



INSERT INTO HtmlLabelIndex values(19057,'日程周统计') 
GO
INSERT INTO HtmlLabelIndex values(19058,'日程月统计') 
GO
INSERT INTO HtmlLabelInfo VALUES(19057,'日程周统计',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19057,'Work Plan Weekly Report',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19058,'日程月统计',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19058,'Work Plan Monthly Report',8) 
GO

INSERT INTO HtmlLabelIndex values(19080,'日程统计') 
GO
INSERT INTO HtmlLabelInfo VALUES(19080,'日程统计',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19080,'Work Plan Report',8) 
GO


EXECUTE MMConfig_U_ByInfoInsert 3,15
GO
EXECUTE MMInfo_Insert 491,19042,'','/workplan/config/WorkPlanReportSetOperation.jsp','mainFrame',3,1,15,0,'',1,'WorkPlanReportSet:Set',0,'','',0,'','',2
GO

EXECUTE LMConfig_U_ByInfoInsert 2,140,0
GO
EXECUTE LMInfo_Insert 150,19057,'/images_face/ecologyFace_2/LeftMenuIcon/level3.gif','/workplan/report/WorkPlanReportListOperation.jsp?type=1',2,140,0,2 
GO

EXECUTE LMConfig_U_ByInfoInsert 2,140,1
GO
EXECUTE LMInfo_Insert 151,19058,'/images_face/ecologyFace_2/LeftMenuIcon/level3.gif','/workplan/report/WorkPlanReportListOperation.jsp?type=2',2,140,1,2 
GO


CREATE TABLE WorkPlanVisitSet 
(
    WorkPlanVisitSetID int IDENTITY (1, 1) PRIMARY KEY NOT NULL ,
    WorkPlanReportType int NULL ,
    WorkPlanReportContentID varchar (400) ,
    WorkPlanReportSec int NULL ,
    WorkPlanVisitType int NULL ,
    WorkPlanVisitContentID varchar (400) ,
    WorkPlanVisitSec int NULL 
)
GO

CREATE TABLE WorkPlanVisitSetDetail 
(
    WorkPlanVisitSetDetailID int IDENTITY (1, 1) PRIMARY KEY NOT NULL ,
    WorkPlanReportType int NULL ,
    WorkPlanReportContentID int NULL ,
    WorkPlanReportSec int NULL ,
    WorkPlanVisitType int NULL ,
    WorkPlanVisitContentID int NULL ,
    WorkPlanVisitSec int NULL ,
    WorkPlanVisitSetID int NULL 
)
GO