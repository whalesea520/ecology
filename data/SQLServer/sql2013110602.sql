delete from leftmenuinfo where id=217
GO
delete from leftmenuconfig where infoid=217
GO
EXECUTE LMConfig_U_ByInfoInsert 2,2,15
GO
EXECUTE LMInfo_Insert 217,20421,'/images/icon_balancelist.gif','/fullsearch/Search.jsp',2,2,15,1
GO

delete from mainmenuinfo where id=602
GO
delete from mainmenuconfig where infoid=602
GO
EXECUTE MMConfig_U_ByInfoInsert 2,24
GO
EXECUTE MMInfo_Insert 602,20422,'ËÑË÷Ë÷Òý¹ÜÀí','/fullsearch/IndexManager.jsp','mainFrame',2,1,24,0,'',0,'',0,'','',0,'','',1
GO

update mainmenuinfo set parentid=635,defaultparentid=635 where id =602
GO


Delete from LeftMenuInfo where id=559
GO
EXECUTE LMConfig_U_ByInfoInsert 1,0,0
GO
EXECUTE LMInfo_Insert 559,31953,NULL,NULL,1,0,0,9
GO

Delete from LeftMenuInfo where id=560
GO
EXECUTE LMConfig_U_ByInfoInsert 2,559,0
GO
EXECUTE LMInfo_Insert 560,31953,'/images_face/ecologyFace_2/LeftMenuIcon/SearchAssistance.gif','/fullsearch/Search.jsp',2,559,0,9 
GO