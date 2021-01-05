Delete from MainMenuInfo where id=10594
GO
EXECUTE MMConfig_U_ByInfoInsert 5,1
GO
EXECUTE MMInfo_Insert 10594,130819,'','','',5,2,1,0,'',0,'',0,'','',0,'','',4
GO
Delete from MainMenuInfo where id=10595
GO
EXECUTE MMConfig_U_ByInfoInsert 10594,1
GO
EXECUTE MMInfo_Insert 10595,130821,'','/CRM/Maint/CRMBusinessInfoSettings.jsp','mainFrame',10594,3,1,0,'',0,'',0,'','',0,'','',4
GO