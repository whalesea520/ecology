
Delete from MainMenuInfo where id=10352
/
call  MMConfig_U_ByInfoInsert (10004,19)
/
call MMInfo_Insert (10352,128696,'小E助手','','mainFrame',10004,1,19,0,'',0,'',0,'','',0,'','',9)
/

Delete from MainMenuInfo where id=10358
/
call MMConfig_U_ByInfoInsert (10352,6)
/
call MMInfo_Insert (10358,128702,'固定指令设置','/fullsearch/ViewFixedInstLibTab.jsp','mainFrame',10352,2,6,0,'',0,'',0,'','',0,'','',9)
/

Delete from MainMenuInfo where id=10356
/
call MMConfig_U_ByInfoInsert (10352,4)
/
call MMInfo_Insert (10356,128700,'人员库','/fullsearch/ViewHrmLibFrame.jsp','mainFrame',10352,2,4,0,'',0,'',0,'','',0,'','',9)
/

Delete from MainMenuInfo where id=10357
/
call MMConfig_U_ByInfoInsert (10352,5)
/
call MMInfo_Insert (10357,128701,'客服设置','/fullsearch/ViewServiceLibTab.jsp','mainFrame',10352,2,5,0,'',0,'',0,'','',0,'','',9)
/

Delete from MainMenuInfo where id=10354
/
call MMConfig_U_ByInfoInsert (10352,2)
/
call MMInfo_Insert (10354,128698,'文档库','/fullsearch/ViewDocLibTab.jsp','mainFrame',10352,2,2,0,'',0,'',0,'','',0,'','',9)
/

Delete from MainMenuInfo where id=10353
/
call MMConfig_U_ByInfoInsert (10352,1)
/
call MMInfo_Insert (10353,128697,'问题库','/fullsearch/ViewFaqLibTab.jsp','mainFrame',10352,2,1,0,'',0,'',0,'','',0,'','',9)
/

Delete from MainMenuInfo where id=10355
/
call MMConfig_U_ByInfoInsert (10352,3)
/
call MMInfo_Insert (10355,128699,'客户库','/fullsearch/ViewCrmLibTab.jsp','mainFrame',10352,2,3,0,'',0,'',0,'','',0,'','',9)
/
