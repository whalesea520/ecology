Delete from MainMenuInfo where id=1166
/
Delete from MainMenuInfo where id=1207
/
call MMConfig_U_ByInfoInsert (11,15)
/
call MMInfo_Insert (1207,30235,'������ģ','','mainFrame',11,1,15,0,'',0,'',0,'','',0,'','',9)
/
Delete from MainMenuInfo where id=1209
/
call MMConfig_U_ByInfoInsert (1207,2)
/
call MMInfo_Insert (1209,30208,'��������','/formmode/tree/CustomTreeList.jsp','mainFrame',1207,2,2,0,'',0,'',0,'','',0,'','',9)
/
Delete from MainMenuInfo where id=1208
/
call MMConfig_U_ByInfoInsert (1207,1)
/
call MMInfo_Insert (1208,30235,'������ģ','/formmode/setup/ModeSettings.jsp','mainFrame',1207,2,1,0,'',0,'',0,'','',0,'','',9)
/