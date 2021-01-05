delete from mainmenuinfo where id=661
/
delete from mainmenuconfig where infoid=661
/

call MMConfig_U_ByInfoInsert (11,35)
/
call MMInfo_Insert (661,20960,'¼¯³ÉµÇÂ½','/interface/outter/OutterSys.jsp','mainFrame',11,1,35,0,'',0,'',0,'','',0,'','',9)
/