CALL MMConfig_U_ByInfoInsert (11,8)
/
CALL MMInfo_Insert (546,19772,'日程设置','','mainFrame',11,1,8,0,'',0,'',0,'','',0,'','',9)
/

CALL MMConfig_U_ByInfoInsert (546,1)
/
CALL MMInfo_Insert (547,19773,'日程类型设置','/workplan/config/global/WorkPlanTypeSet.jsp','mainFrame',546,2,1,0,'',0,'',0,'','',0,'','',9)
/


CALL MMConfig_U_ByInfoInsert (3,15)
/
CALL MMInfo_Insert (548,19792,'日程监控','/system/systemmonitor/workplan/WorkPlanMonitor.jsp','mainFrame',3,1,15,0,'',0,'',0,'','',0,'','',2)
/

CALL MMConfig_U_ByInfoInsert (3,16)
/
CALL MMInfo_Insert (549,19793,'日程监控设置','/system/systemmonitor/workplan/WorkPlanMonitorStatic.jsp','mainFrame',3,1,16,0,'',0,'',0,'','',0,'','',2)
/

UPDATE LeftMenuInfo SET linkAddress = '/hrm/performance/targetPlan/PlanModulList.jsp?target=workplan' WHERE id = 209
/
