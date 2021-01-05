Delete from MainMenuInfo where id=10863
/
CALL MMConfig_U_ByInfoInsert (5,18)
/
CALL MMInfo_Insert (10863,382309,'','','',5,2,18,0,'',0,'',0,'','',0,'','',4)
/

Delete from MainMenuInfo where id=10865
/
CALL MMConfig_U_ByInfoInsert (10863,0)
/
CALL MMInfo_Insert (10865,382310,'','/CRM/Maint/CRMCardRegSettings.jsp','mainFrame',10863,3,0,0,'',0,'',0,'','',0,'','',4)
/