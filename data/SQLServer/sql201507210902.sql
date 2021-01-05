Delete from MainMenuInfo where id=1143
GO
Delete from MainMenuInfo where id=10205
GO
EXECUTE MMConfig_U_ByInfoInsert 10019,3
GO
EXECUTE MMInfo_Insert 10205,124876,'公共选择框维护','/workflow/selectItem/selectItemMain.jsp','mainFrame',10019,2,3,0,'WORKFLOWPUBLICCHOICE:VIEW',0,'',0,'','',0,'','',3
GO