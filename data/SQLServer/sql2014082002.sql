Delete from LeftMenuInfo where id=573
GO
EXECUTE LMConfig_U_ByInfoInsert 2,6,0
GO
EXECUTE LMInfo_Insert 573,32483,'/images_face/ecologyFace_2/LeftMenuIcon/MEET_573.png','/meeting/data/MeetingCalView.jsp',2,6,0,9 
GO

Delete from LeftMenuInfo where id=573
GO
EXECUTE LMConfig_U_ByInfoInsert 2,6,0
GO
EXECUTE LMInfo_Insert 573,32483,'/images_face/ecologyFace_2/LeftMenuIcon/MEET_573.png','/meeting/data/MeetingCalView.jsp',2,6,0,9 
GO

UPDATE LeftMenuInfo SET linkaddress = '/meeting/search/MeetingSearchTab.jsp' WHERE id = 55
GO

Delete from LeftMenuInfo where id IN (50,51,52,53)
GO

Delete from LeftMenuInfo where id=575
GO
EXECUTE LMConfig_U_ByInfoInsert 2,6,4
GO
EXECUTE LMInfo_Insert 575,32529,'/images_face/ecologyFace_2/LeftMenuIcon/MEET_575.png','/meeting/search/MeetingDecisionTab.jsp',2,6,4,9
GO

Delete from LeftMenuInfo where id=575
GO
EXECUTE LMConfig_U_ByInfoInsert 2,6,4
GO
EXECUTE LMInfo_Insert 575,32529,'/images_face/ecologyFace_2/LeftMenuIcon/MEET_575.png','/meeting/search/MeetingDecisionTab.jsp',2,6,4,9
GO

Delete from LeftMenuInfo where id=574
GO
EXECUTE LMConfig_U_ByInfoInsert 2,6,15
GO
EXECUTE LMInfo_Insert 574,16613,'/images_face/ecologyFace_2/LeftMenuIcon/MEET_574.png','/meeting/report/StatisticsTab.jsp',2,6,15,9 
GO

Delete from LeftMenuInfo where id=574
GO
EXECUTE LMConfig_U_ByInfoInsert 2,6,15
GO
EXECUTE LMInfo_Insert 574,16613,'/images_face/ecologyFace_2/LeftMenuIcon/MEET_574.png','/meeting/report/StatisticsTab.jsp',2,6,15,9 
GO

UPDATE MainMenuInfo SET linkaddress = '/meeting/report/StatisticsMeetingUsedTab.jsp' WHERE id = 271
GO

UPDATE MainMenuInfo SET linkAddress = '/meeting/report/MeetingForTypeRpt.jsp',labelid = 32592, menuName = '' WHERE id = 1307
GO

UPDATE LeftMenuInfo SET linkAddress='/sms/ViewMessageTab.jsp' WHERE id = 77
GO

UPDATE LeftMenuInfo SET linkAddress='/sms/SmsManageTab.jsp' WHERE id = 79
GO

UPDATE LeftMenuInfo SET linkAddress='/sms/SmsMessageEditTab.jsp' WHERE id = 78
GO

UPDATE LeftMenuInfo SET linkAddress='/sms/voting/SmsVotingListTab.jsp' WHERE id = 274
GO

UPDATE LeftMenuInfo SET linkAddress='/workplan/config/global/WorkPlanSharePersonalTab.jsp' WHERE id = 242
GO

Delete from LeftMenuInfo where id=611
GO
EXECUTE LMConfig_U_ByInfoInsert 2,6,14
GO
EXECUTE LMInfo_Insert 611,33171,'/images_face/ecologyFace_2/LeftMenuIcon/MEET_611.png','/meeting/search/MeetingSearchTab.jsp?isInterval=1',2,6,14,9 
GO

Delete from LeftMenuInfo where id=611
GO
EXECUTE LMConfig_U_ByInfoInsert 2,6,14
GO
EXECUTE LMInfo_Insert 611,33171,'/images_face/ecologyFace_2/LeftMenuIcon/MEET_611.png','/meeting/search/MeetingSearchTab.jsp?isInterval=1',2,6,14,9 
GO

UPDATE LeftMenuInfo SET labelId = 33277 WHERE id=611
GO

UPDATE LeftMenuInfo SET labelId = 15881 WHERE id = 54
GO


Delete from MainMenuInfo where id=1306
GO
EXECUTE MMInfo_Insert 1306,31811,'应用配置','/meeting/Maint/MeetingSetTab.jsp','mainFrame',502,2,15,0,'',0,'',0,'','',0,'','',9
GO
EXECUTE MMConfig_U_ByInfoInsert 502,15
GO

UPDATE MainMenuInfo SET linkAddress = '/meeting/Maint/MeetingMonitorTab.jsp' WHERE id = 358

UPDATE MainMenuInfo SET linkAddress='/workplan/config/global/WorkPlanTypeSetTab.jsp' WHERE id = 547
go

UPDATE MainMenuInfo SET linkAddress='/system/systemmonitor/workplan/WorkPlanMonitorStaticTab.jsp' WHERE id = 580
go

UPDATE MainMenuInfo SET linkAddress='/system/systemmonitor/workplan/WorkPlanMonitorTab.jsp' WHERE id = 581
go

UPDATE MainMenuInfo SET linkAddress='/workplan/config/global/WorkPlanShareSetTab.jsp' WHERE id = 583
go

UPDATE MainMenuInfo SET defaultParentId = 0 , defaultLevel = 0, parentId = 0 WHERE id = 502
go
UPDATE MainMenuInfo SET defaultLevel = 1 WHERE  parentId = 502
go
UPDATE MainMenuInfo SET labelid = 18442, menuName='会议管理' WHERE id = 502
go

UPDATE MainMenuInfo SET defaultLevel = 1, defaultParentId = 0 ,  parentId = 0 WHERE id = 546
go

UPDATE MainMenuInfo SET labelid = 33433, menuName='日程管理' WHERE id = 546
go
