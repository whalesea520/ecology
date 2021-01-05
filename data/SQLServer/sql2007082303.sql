delete mainmenuconfig where infoid=353
GO
delete mainmenuinfo where id=353
GO
EXECUTE MMConfig_U_ByInfoInsert 11,7
GO
EXECUTE MMInfo_Insert 353,16527,'','/hrm/roles/HrmRoles_frm.jsp','mainFrame',11,1,7,0,'',0,'',0,'','',0,'','',9
GO
update mainmenuinfo set parentid=500 where id=353
go