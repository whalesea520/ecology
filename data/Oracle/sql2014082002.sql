Delete from LeftMenuInfo where id=573
/
call LMConfig_U_ByInfoInsert (2,6,0)
/
call LMInfo_Insert (573,32483,'/images_face/ecologyFace_2/LeftMenuIcon/MEET_573.png','/meeting/data/MeetingCalView.jsp',2,6,0,9 )
/

Delete from LeftMenuInfo where id=573
/
call LMConfig_U_ByInfoInsert (2,6,0)
/
call LMInfo_Insert (573,32483,'/images_face/ecologyFace_2/LeftMenuIcon/MEET_573.png','/meeting/data/MeetingCalView.jsp',2,6,0,9 )
/

UPDATE LeftMenuInfo SET linkaddress = '/meeting/search/MeetingSearchTab.jsp' WHERE id = 55
/

Delete from LeftMenuInfo where id IN (50,51,52,53)
/

Delete from LeftMenuInfo where id=575
/
call LMConfig_U_ByInfoInsert (2,6,4)
/
call LMInfo_Insert (575,32529,'/images_face/ecologyFace_2/LeftMenuIcon/MEET_575.png','/meeting/search/MeetingDecisionTab.jsp',2,6,4,9)
/

Delete from LeftMenuInfo where id=575
/
call LMConfig_U_ByInfoInsert (2,6,4)
/
call LMInfo_Insert (575,32529,'/images_face/ecologyFace_2/LeftMenuIcon/MEET_575.png','/meeting/search/MeetingDecisionTab.jsp',2,6,4,9)
/

Delete from LeftMenuInfo where id=574
/
call LMConfig_U_ByInfoInsert (2,6,15)
/
call LMInfo_Insert (574,16613,'/images_face/ecologyFace_2/LeftMenuIcon/MEET_574.png','/meeting/report/StatisticsTab.jsp',2,6,15,9 )
/

Delete from LeftMenuInfo where id=574
/
call LMConfig_U_ByInfoInsert (2,6,15)
/
call LMInfo_Insert (574,16613,'/images_face/ecologyFace_2/LeftMenuIcon/MEET_574.png','/meeting/report/StatisticsTab.jsp',2,6,15,9 )
/

UPDATE MainMenuInfo SET linkaddress = '/meeting/report/StatisticsMeetingUsedTab.jsp' WHERE id = 271
/

UPDATE MainMenuInfo SET linkAddress = '/meeting/report/MeetingForTypeRpt.jsp',labelid = 32592, menuName = '' WHERE id = 1307
/

UPDATE LeftMenuInfo SET linkAddress='/sms/ViewMessageTab.jsp' WHERE id = 77
/

UPDATE LeftMenuInfo SET linkAddress='/sms/SmsManageTab.jsp' WHERE id = 79
/

UPDATE LeftMenuInfo SET linkAddress='/sms/SmsMessageEditTab.jsp' WHERE id = 78
/

UPDATE LeftMenuInfo SET linkAddress='/sms/voting/SmsVotingListTab.jsp' WHERE id = 274
/

UPDATE LeftMenuInfo SET linkAddress='/workplan/config/global/WorkPlanSharePersonalTab.jsp' WHERE id = 242
/

Delete from LeftMenuInfo where id=611
/
call LMConfig_U_ByInfoInsert (2,6,14)
/
call LMInfo_Insert (611,33171,'/images_face/ecologyFace_2/LeftMenuIcon/MEET_611.png','/meeting/search/MeetingSearchTab.jsp?isInterval=1',2,6,14,9 )
/

Delete from LeftMenuInfo where id=611
/
call LMConfig_U_ByInfoInsert (2,6,14)
/
call LMInfo_Insert (611,33171,'/images_face/ecologyFace_2/LeftMenuIcon/MEET_611.png','/meeting/search/MeetingSearchTab.jsp?isInterval=1',2,6,14,9 )
/

UPDATE LeftMenuInfo SET labelId = 33277 WHERE id=611
/

UPDATE LeftMenuInfo SET labelId = 15881 WHERE id = 54
/


Delete from MainMenuInfo where id=1306
/
call MMInfo_Insert (1306,31811,'应用配置','/meeting/Maint/MeetingSetTab.jsp','mainFrame',502,2,15,0,'',0,'',0,'','',0,'','',9)
/
call MMConfig_U_ByInfoInsert (502,15)
/

UPDATE MainMenuInfo SET linkAddress = '/meeting/Maint/MeetingMonitorTab.jsp' WHERE id = 358
/

UPDATE MainMenuInfo SET linkAddress='/workplan/config/global/WorkPlanTypeSetTab.jsp' WHERE id = 547
/

UPDATE MainMenuInfo SET linkAddress='/system/systemmonitor/workplan/WorkPlanMonitorStaticTab.jsp' WHERE id = 580
/

UPDATE MainMenuInfo SET linkAddress='/system/systemmonitor/workplan/WorkPlanMonitorTab.jsp' WHERE id = 581
/

UPDATE MainMenuInfo SET linkAddress='/workplan/config/global/WorkPlanShareSetTab.jsp' WHERE id = 583
/

UPDATE MainMenuInfo SET defaultParentId = 0 , defaultLevel = 0, parentId = 0 WHERE id = 502
/
UPDATE MainMenuInfo SET defaultLevel = 1 WHERE  parentId = 502
/
UPDATE MainMenuInfo SET labelid = 18442, menuName='会议管理' WHERE id = 502
/

UPDATE MainMenuInfo SET defaultLevel = 1, defaultParentId = 0 ,  parentId = 0 WHERE id = 546
/

UPDATE MainMenuInfo SET labelid = 33433, menuName='日程管理' WHERE id = 546
/
