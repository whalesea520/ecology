delete mainmenuconfig where infoid=353
/
delete mainmenuinfo where id=353
/
call MMConfig_U_ByInfoInsert(11,7)
/
call MMInfo_Insert(353,16527,'','/hrm/roles/HrmRoles_frm.jsp','mainFrame',11,1,7,0,'',0,'',0,'','',0,'','',9)
/

update mainmenuinfo set parentid=500 where id=353
/