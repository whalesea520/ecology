delete from leftmenuinfo where id=217
/
delete from mainmenuinfo where id=602
/
call LMConfig_U_ByInfoInsert(2,2,15)
/
call MMInfo_Insert(602,20422,'ËÑË÷Ë÷Òý¹ÜÀí','/fullsearch/IndexManager.jsp','mainFrame',2,1,22,0,'',0,'',0,'','',0,'','',1)
/


Delete from LeftMenuInfo where id=559
/
call LMConfig_U_ByInfoInsert (1,0,0)
/
call LMInfo_Insert (559,31953,NULL,NULL,1,0,0,9)
/

Delete from LeftMenuInfo where id=560
/
call LMConfig_U_ByInfoInsert (2,559,0)
/
call LMInfo_Insert (560,31953,'/images_face/ecologyFace_2/LeftMenuIcon/SearchAssistance.gif','/fullsearch/Search.jsp',2,559,0,9)
/