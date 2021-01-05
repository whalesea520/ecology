Delete from MainMenuInfo where id=1166
GO
Delete from MainMenuInfo where id=1207
GO
EXECUTE MMConfig_U_ByInfoInsert 11,15
GO
EXECUTE MMInfo_Insert 1207,30235,'表单建模','','mainFrame',11,1,15,0,'',0,'',0,'','',0,'','',9
GO
Delete from MainMenuInfo where id=1209
GO
EXECUTE MMConfig_U_ByInfoInsert 1207,2
GO
EXECUTE MMInfo_Insert 1209,30208,'树形设置','/formmode/tree/CustomTreeList.jsp','mainFrame',1207,2,2,0,'',0,'',0,'','',0,'','',9
GO
Delete from MainMenuInfo where id=1208
GO
EXECUTE MMConfig_U_ByInfoInsert 1207,1
GO
EXECUTE MMInfo_Insert 1208,30235,'表单建模','/formmode/setup/ModeSettings.jsp','mainFrame',1207,2,1,0,'',0,'',0,'','',0,'','',9
GO