Delete from MainMenuInfo where id=10269
GO
EXECUTE MMConfig_U_ByInfoInsert 10008,3
GO
EXECUTE MMInfo_Insert 10269,17530,'','/jsp/index.jsp','',10008,1,3,0,'',0,'',0,'','',0,'','',9
GO
Delete from MainMenuInfo where id=10272
GO
EXECUTE MMConfig_U_ByInfoInsert 10269,0
GO
EXECUTE MMInfo_Insert 10272,17632,'','/jsp/index.jsp?type=4','mainFrame',10269,2,0,0,'',0,'',0,'','',0,'','',9
GO
Delete from MainMenuInfo where id=10268
GO
EXECUTE MMConfig_U_ByInfoInsert 10269,1
GO
EXECUTE MMInfo_Insert 10268,127349,'','/jsp/index.jsp?type=1','mainFrame',10269,2,1,0,'',0,'',0,'','',0,'','',9
GO
Delete from MainMenuInfo where id=10291
GO
EXECUTE MMConfig_U_ByInfoInsert 10269,4
GO
EXECUTE MMInfo_Insert 10291,33728,'升级日志','/jsp/index.jsp?type=5','mainFrame',10269,2,4,0,'',0,'',0,'','',0,'','',9
GO
Delete from MainMenuInfo where id=10304
GO
EXECUTE MMConfig_U_ByInfoInsert 10269,5
GO
EXECUTE MMInfo_Insert 10304,127698,'代码认证','/jsp/index.jsp?type=6','mainFrame',10269,2,5,0,'',0,'',0,'','',0,'','',9
GO