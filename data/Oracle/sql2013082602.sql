update MainMenuInfo set labelId='31795' where id=22
/
Delete from MainMenuInfo where id=1262
/
call MMConfig_U_ByInfoInsert (2,22)
/
call MMInfo_Insert (1262,31794,'批量调整共享','/docs/search/DocSearchSharing.jsp?from=shareManageDoc','mainFrame',2,1,22,0,'',0,'',0,'','',0,'','',1)
/
Delete from MainMenuInfo where id=1263
/
call MMConfig_U_ByInfoInsert (2,23)
/
call MMInfo_Insert (1263,31811,'应用配置','/docs/search/DocProp.jsp','mainFrame',2,1,23,0,'',0,'',0,'','',0,'','',1)
/

