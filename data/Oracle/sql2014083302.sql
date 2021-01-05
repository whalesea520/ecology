Delete from MainMenuInfo where id=1336
/
call MMConfig_U_ByInfoInsert(0,1)
/
call MMInfo_Insert(1336,32768,'','','mainFrame',0,0,1,0,'',0,'',0,'','',0,'','',9)
/
Delete from MainMenuInfo where id=1336
/
call MMConfig_U_ByInfoInsert(0,12)
/
call MMInfo_Insert(1336,32768,'协同管理','','mainFrame',0,0,12,0,'',0,'',0,'','',0,'','',9)
/
Delete from MainMenuInfo where id=1340
/
call MMConfig_U_ByInfoInsert(1336,2)
/
call MMInfo_Insert(1340,33037,'流程协同','/synergy/maintenance/Synergy.jsp?stype=wf','mainFrame',1336,1,2,0,'',0,'',0,'','',0,'','',9)
/
Delete from MainMenuInfo where id=1341
/
call MMConfig_U_ByInfoInsert(1336,1)
/
call MMInfo_Insert(1341,33038,'知识协同','/synergy/maintenance/Synergy.jsp?stype=doc','mainFrame',1336,1,1,0,'',0,'',0,'','',0,'','',9)
/