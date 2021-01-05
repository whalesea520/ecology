delete from MainMenuConfig  where  infoId IN  (1263,715,10077)
/ 
Delete from MainMenuInfo where id=715
/
call  MMConfig_U_ByInfoInsert (1297,3)
/
call MMInfo_Insert (715,21885,'文档弹出窗口设置','/docs/search/DocMain.jsp?urlType=12','mainFrame',1297,2,3,0,'',0,'',0,'','',0,'','',1)
/

Delete from MainMenuInfo where id=1263
/
call MMConfig_U_ByInfoInsert (1288,5)
/
call MMInfo_Insert (1263,31811,'应用配置','/docs/docs/DocOtherTab.jsp?_fromURL=3','mainFrame',1288,2,5,0,'',0,'',0,'','',0,'','',1)
/