delete from leftmenuinfo where id=94
go
delete from leftmenuinfo where parentid=94
go
delete from leftmenuconfig where infoid=94
go
delete from leftmenuconfig where infoid=95 or infoid=120 or infoid=124 or infoid=125 or infoid=126 or infoid=127 or infoid=141 or infoid=142 or infoid=143
go 


delete from mainmenuinfo where id=433
go
delete from mainmenuinfo where defaultparentid=433
go
delete from mainmenuconfig where infoid=433
go
delete from mainmenuconfig where infoid>=434 and infoid<=441
go
delete from mainmenuconfig where infoid=471
go


EXECUTE MMConfig_U_ByInfoInsert 3,5
GO
EXECUTE MMInfo_Insert 433,18041,'目标管理','','',3,1,5,0,'',0,'',0,'','',0,'','',2
GO

EXECUTE MMConfig_U_ByInfoInsert 433,1
GO
EXECUTE MMInfo_Insert 434,18042,'考核等级划分','/hrm/performance/maintenance/checkGrade/GradeList.jsp','mainFrame',433,2,1,0,'',1,'CheckGradeInfo:Maintenance',0,'','',0,'','',2
GO

EXECUTE MMConfig_U_ByInfoInsert 433,2
GO
EXECUTE MMInfo_Insert 435,18043,'审批流程关联','/hrm/performance/maintenance/checkFlow/checkFlowList.jsp','mainFrame',433,2,1,0,'',1,'CheckFlowInfo:Maintenance',0,'','',0,'','',2
GO

EXECUTE MMConfig_U_ByInfoInsert 433,3
GO
EXECUTE MMInfo_Insert 436,18044,'计划性质设定','/hrm/performance/maintenance/planKind/PlanList.jsp','mainFrame',433,2,1,0,'',1,'PlanKindInfo:Maintenance',0,'','',0,'','',2
GO

EXECUTE MMConfig_U_ByInfoInsert 433,4
GO
EXECUTE MMInfo_Insert 437,18046,'提醒时间设定','/hrm/performance/maintenance/alertTime/alertList.jsp','mainFrame',433,2,1,0,'',1,'AlertTimeInfo:Maintenance',0,'','',0,'','',2
GO

EXECUTE MMConfig_U_ByInfoInsert 433,5
GO
EXECUTE MMInfo_Insert 439,18048,'自定义考核表','/hrm/performance/maintenance/diyCheck/CheckList.jsp','mainFrame',433,2,2,0,'',1,'DiyCheck:Maintenance',0,'','',0,'','',2
GO

EXECUTE MMConfig_U_ByInfoInsert 433,8
GO
EXECUTE MMInfo_Insert 441,18050,'评分规则','/hrm/performance/pointRule/RuleView.jsp','mainFrame',433,2,2,0,'',1,'PointRule:Performance',0,'','',0,'','',2
GO

EXECUTE MMConfig_U_ByInfoInsert 433,6
GO
EXECUTE MMInfo_Insert 438,18047,'指标库','/hrm/performance/maintenance/targetType/TargetTypeList.jsp','mainFrame',433,2,1,0,'',1,'TargetTypeInfo:Maintenance',0,'','',0,'','',2
GO

EXECUTE MMConfig_U_ByInfoInsert 433,7
GO
EXECUTE MMInfo_Insert 440,18049,'考核方案设定','/hrm/performance/checkScheme/CheckSchemeList.jsp','mainFrame',433,2,2,0,'',1,'CheckScheme:Performance',0,'','',0,'','',2
GO

EXECUTE MMConfig_U_ByInfoInsert 433,9
GO
EXECUTE MMInfo_Insert 471,18522,'计量单位自定义','/hrm/performance/maintenance/custom/CustomList.jsp','mainFrame',433,2,9,0,'',1,'Custom:Performance',0,'','',0,'','',2
GO


EXECUTE LMConfig_U_ByInfoInsert 1,NULL,2
GO
EXECUTE LMInfo_Insert 94,18027,NULL,NULL,1,NULL,2,9
GO

EXECUTE LMConfig_U_ByInfoInsert 2,94,1
GO
EXECUTE LMInfo_Insert 95,18028,'/images_face/ecologyFace_2/LeftMenuIcon/MyKPI.gif','/hrm/performance/goal/myGoalFrame.jsp',2,94,1,9 
GO

EXECUTE LMConfig_U_ByInfoInsert 2,94,3
GO
EXECUTE LMInfo_Insert 120,18220,'/images_face/ecologyFace_2/LeftMenuIcon/MyKPI.gif','/hrm/performance/targetPlan/PlanModulList.jsp',2,94,3,2 
GO

EXECUTE LMConfig_U_ByInfoInsert 2,94,2
GO
EXECUTE LMInfo_Insert 125,18408,'/images_face/ecologyFace_2/LeftMenuIcon/MyPlan.gif','/hrm/performance/targetPlan/PlanMain.jsp',2,94,2,2 
GO

EXECUTE LMConfig_U_ByInfoInsert 2,94,4
GO
EXECUTE LMInfo_Insert 126,16434,'/images_face/ecologyFace_2/LeftMenuIcon/MyAssess.gif','/hrm/performance/targetCheck/CheckMain.jsp',2,94,4,2 
GO

EXECUTE LMConfig_U_ByInfoInsert 2,94,6
GO
EXECUTE LMInfo_Insert 124,18267,'/images_face/ecologyFace_2/LeftMenuIcon/MyKPI.gif','/hrm/performance/targetCheck/PointSort.jsp',2,94,6,2 
GO

EXECUTE LMConfig_U_ByInfoInsert 2,94,5
GO
EXECUTE LMInfo_Insert 127,18409,'/images_face/ecologyFace_2/LeftMenuIcon/MyReport.gif','/hrm/performance/targetReport/ReportMain.jsp',2,94,5,2 
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