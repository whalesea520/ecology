Delete from MainMenuInfo where id=10015
/
CALL MMConfig_U_ByInfoInsert (10014,0)
/
CALL MMInfo_Insert (10015,24326,'管理分权','/system/DetachMSetTab.jsp?_fromURL=DetachMSetEdit','mainFrame',10014,3,0,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=10017
/
CALL MMConfig_U_ByInfoInsert (10014,1)
/
CALL MMInfo_Insert (10017,33653,'','/system/sysdetach/AppDetachTab.jsp?_fromURL=AppDetachList','',10014,1,2,0,'',0,'',0,'','',0,'','',2)
/
