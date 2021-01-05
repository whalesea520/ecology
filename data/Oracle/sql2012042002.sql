update MainMenuInfo set linkAddress='' where id=989
/
Delete from MainMenuInfo where id=1135
/
CALL MMConfig_U_ByInfoInsert (989,1)
/
CALL MMInfo_Insert (1135,28057,'测试流程新建','/workflow/request/RequestTypeByTest.jsp','mainFrame',989,2,1,0,'',0,'',0,'','',0,'','',3)
/
Delete from MainMenuInfo where id=1136
/
CALL MMConfig_U_ByInfoInsert (989,2)
/
CALL MMInfo_Insert (1136,28056,'测试流程删除','/workflow/search/RequestTestList.jsp','mainFrame',989,2,2,0,'',0,'',0,'','',0,'','',3)
/