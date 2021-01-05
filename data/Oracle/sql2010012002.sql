delete from MainMenuInfo where labelId = 17599
/
delete from MainMenuInfo where labelId = 24090
/

call MMConfig_U_ByInfoInsert(2,12)
/
call MMInfo_Insert(882,16514,'调查设置','','mainFrame',2,1,12,0,'',0,'',0,'','',0,'','',1)
/
call MMConfig_U_ByInfoInsert(882,1)
/
call MMInfo_Insert(883,17599,'网上调查','/voting/VotingList.jsp','mainFrame',882,2,1,0,'',0,'',0,'','',0,'','',1)
/
call MMConfig_U_ByInfoInsert(882,2)
/
call MMInfo_Insert(884,24090,'调查类型设置','/voting/VotingType.jsp','mainFrame',882,2,2,0,'',0,'',0,'','',0,'','',1)
/
