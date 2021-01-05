Delete from MainMenuInfo where id=10015
GO
EXECUTE MMConfig_U_ByInfoInsert 10014,0
GO
EXECUTE MMInfo_Insert 10015,24326,'管理分权','/system/DetachMSetTab.jsp?_fromURL=DetachMSetEdit','mainFrame',10014,3,0,0,'',0,'',0,'','',0,'','',2
GO
Delete from MainMenuInfo where id=10017
GO
EXECUTE MMConfig_U_ByInfoInsert 10014,1
GO
EXECUTE MMInfo_Insert 10017,33653,'','/system/sysdetach/AppDetachTab.jsp?_fromURL=AppDetachList','',10014,1,2,0,'',0,'',0,'','',0,'','',2
GO
