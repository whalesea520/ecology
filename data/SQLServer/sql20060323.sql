update HrmPerformanceTargetDetail set unit=''
go

INSERT INTO HtmlLabelIndex values(18522,'计量单位自定义') 
GO
INSERT INTO HtmlLabelInfo VALUES(18522,'计量单位自定义',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18522,'CUSTOM SET UNIT',8) 
GO


insert into SystemRights (id,rightdesc,righttype) values (641,'自定义计量单位','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (641,8,'custom set unit','custom set unit') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (641,7,'自定义计量单位','自定义计量单位') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4141,'自定义计量单位设置','Custom:Performance',641) 
GO


EXECUTE MMConfig_U_ByInfoInsert 433,9
GO
EXECUTE MMInfo_Insert 471,18522,'计量单位自定义','hrm/performance/maintenance/custom/CustomList.jsp','mainFrame',433,2,9,0,'',1,'Custom:Performance',0,'','',0,'','',2
GO

insert into SystemRightToGroup (groupid,rightid) select max(id),641 from SystemRightGroups
GO

CREATE TABLE [HrmPerformanceCustom] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[unitName] [varchar] (50)  NULL ,
	[memo] [varchar] (50)  NULL ,
	[status] [char] (1)  NULL 
) ON [PRIMARY]
GO
INSERT INTO HtmlLabelIndex values(18507,'计划审批') 
GO
INSERT INTO HtmlLabelIndex values(18508,'考核评分') 
GO
INSERT INTO HtmlLabelInfo VALUES(18507,'计划审批',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18507,'PLAN PROVE',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18508,'考核评分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18508,'SET POINT',8) 
GO
INSERT INTO HtmlLabelIndex values(18509,'目标审批') 
GO
INSERT INTO HtmlLabelInfo VALUES(18509,'目标审批',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18509,'GOAL PROVE',8) 
GO

EXECUTE LMConfig_U_ByInfoInsert 2,94,4
GO
EXECUTE LMInfo_Insert 141,18508,'/images_face/ecologyFace_2/LeftMenuIcon/MyAssess.gif','/hrm/performance/targetCheck/SetPoint.jsp',2,94,4,2 
GO

EXECUTE LMConfig_U_ByInfoInsert 2,94,5
GO
EXECUTE LMInfo_Insert 142,18507,'/images_face/ecologyFace_2/LeftMenuIcon/MyPlan.gif','/hrm/performance/targetPlan/PlanProve.jsp',2,94,5,2 
GO
EXECUTE LMConfig_U_ByInfoInsert 2,94,6
GO
EXECUTE LMInfo_Insert 143,18509,'/images_face/ecologyFace_2/LeftMenuIcon/MyAssess.gif','/hrm/performance/goal/GoalProve.jsp',2,94,6,2 
GO
