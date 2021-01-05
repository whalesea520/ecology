Delete from MainMenuInfo where id=10269
/
call MMConfig_U_ByInfoInsert(10008,3)
/
call MMInfo_Insert(10269,17530,'','/jsp/index.jsp','',10008,1,3,0,'',0,'',0,'','',0,'','',9)
/
Delete from MainMenuInfo where id=10272
/
call MMConfig_U_ByInfoInsert(10269,0)
/
call MMInfo_Insert(10272,17632,'','/jsp/index.jsp?type=4','mainFrame',10269,2,0,0,'',0,'',0,'','',0,'','',9)
/
Delete from MainMenuInfo where id=10268
/
call MMConfig_U_ByInfoInsert(10269,1)
/
call MMInfo_Insert(10268,127349,'','/jsp/index.jsp?type=1','mainFrame',10269,2,1,0,'',0,'',0,'','',0,'','',9)
/
Delete from MainMenuInfo where id=10291
/
call MMConfig_U_ByInfoInsert(10269,4)
/
call MMInfo_Insert(10291,33728,'升级日志','/jsp/index.jsp?type=5','mainFrame',10269,2,4,0,'',0,'',0,'','',0,'','',9)
/
Delete from MainMenuInfo where id=10304
/
call MMConfig_U_ByInfoInsert(10269,5)
/
call MMInfo_Insert(10304,127698,'代码认证','/jsp/index.jsp?type=6','mainFrame',10269,2,5,0,'',0,'',0,'','',0,'','',9)
/