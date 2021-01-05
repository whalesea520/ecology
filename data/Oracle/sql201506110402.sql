Delete from MainMenuInfo where id=10202
/
call MMConfig_U_ByInfoInsert(0,9)
/
call MMInfo_Insert(10202,84641,'”Ô—‘÷––ƒ','/systeminfo/label/ManageLabel.jsp','mainFrame',0,0,9,0,'',0,'',0,'','',0,'','',9)
/

Delete from MainMenuInfo where id=10148
/
call MMConfig_U_ByInfoInsert(10202,0)
/
call MMInfo_Insert(10148,81485,'','','',10202,1,0,0,'',0,'',0,'','',0,'','',9)
/