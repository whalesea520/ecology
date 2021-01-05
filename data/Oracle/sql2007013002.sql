DELETE FROM MainMenuInfo WHERE id = 549
/
DELETE FROM MainMenuInfo WHERE id = 548
/
DELETE FROM MainMenuInfo WHERE id = 491
/

CALL MMConfig_U_ByInfoInsert (546,2)
/
CALL MMInfo_Insert (580,19793,'日程监控设置','/system/systemmonitor/workplan/WorkPlanMonitorStatic.jsp','mainFrame',546,2,2,0,'',0,'',0,'','',0,'','',2)
/

CALL MMConfig_U_ByInfoInsert (546,3)
/
CALL MMInfo_Insert (581,19792,'日程监控','/system/systemmonitor/workplan/WorkPlanMonitor.jsp','mainFrame',546,2,3,0,'',0,'',0,'','',0,'','',2)
/

CALL MMConfig_U_ByInfoInsert (546,4)
/
CALL MMInfo_Insert (582,19042,'日程统计设置','/workplan/config/WorkPlanReportSet.jsp','mainFrame',546,2,4,0,'',0,'',0,'','',0,'','',2)
/