Delete from MainMenuInfo where id=10594
/
CALL MMConfig_U_ByInfoInsert (5,1)
/
CALL MMInfo_Insert (10594,130819,'','','',5,2,1,0,'',0,'',0,'','',0,'','',4)
/
Delete from MainMenuInfo where id=10595
/
CALL MMConfig_U_ByInfoInsert (10594,1)
/
CALL MMInfo_Insert (10595,130821,'','/CRM/Maint/CRMBusinessInfoSettings.jsp','mainFrame',10594,3,1,0,'',0,'',0,'','',0,'','',4)
/