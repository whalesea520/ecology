Delete from MainMenuInfo where id=1436
/
call MMInfo_Insert (1436,16484,'基础设置','javascript:void(0)','mainFrame',502,2,1,0,'',0,'',0,'','',0,'','',9)
/
call MMConfig_U_ByInfoInsert (502,1)
/

update MainMenuInfo set defaultParentId=1436,parentId=1436 where id=356
/
update MainMenuInfo set defaultParentId=1436,parentId=1436 where id=357
/

Delete from MainMenuInfo where id=1442
/
call MMInfo_Insert (1442,81892,'会议服务设置','/meeting/Maint/meetingServiceTab.jsp','mainFrame',1436,2,6,0,'',0,'',0,'','',0,'','',9)
/
call MMConfig_U_ByInfoInsert (1436,6)
/

Delete from MainMenuInfo where id=1437
/
call MMInfo_Insert (1437,32470,'自定义设置','javascript:void(0)','mainFrame',502,2,5,0,'',0,'',0,'','',0,'','',9)
/
call MMConfig_U_ByInfoInsert (502,5)
/

Delete from MainMenuInfo where id=1438
/
call MMInfo_Insert (1438,81893,'会议信息字段定义','/meeting/defined/meetingInfoTab.jsp','mainFrame',1437,2,1,0,'',0,'',0,'','',0,'','',9)
/
call MMConfig_U_ByInfoInsert (1437,1)
/

Delete from MainMenuInfo where id=1440
/
call MMInfo_Insert (1440,81894,'会议议程字段定义','/meeting/defined/meetingAgendaTab.jsp','mainFrame',1437,2,2,0,'',0,'',0,'','',0,'','',9)
/
call MMConfig_U_ByInfoInsert (1437,2)
/

Delete from MainMenuInfo where id=1439
/
call MMInfo_Insert (1439,81895,'会议服务字段定义','/meeting/defined/meetingServiceTab.jsp','mainFrame',1437,2,3,0,'',0,'',0,'','',0,'','',9)
/
call MMConfig_U_ByInfoInsert (1437,3)
/

Delete from MainMenuInfo where id=1441
/
call MMInfo_Insert (1441,81896,'会议流程设置','/meeting/defined/meetingWfTab.jsp','mainFrame',502,2,11,0,'',0,'',0,'','',0,'','',9)
/
call MMConfig_U_ByInfoInsert (502,11)
/

Delete from MainMenuInfo where id=1443
/
call MMInfo_Insert (1443,30425,'会议提醒模板','/meeting/defined/remindListTab.jsp','mainFrame',502,2,13,0,'',0,'',0,'','',0,'','',9)
/
call MMConfig_U_ByInfoInsert (502,13)
/
