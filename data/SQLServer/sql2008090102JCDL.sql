delete from mainmenuinfo where id=661
GO
delete from mainmenuconfig where infoid=661
GO

EXECUTE MMConfig_U_ByInfoInsert 11,35
GO
EXECUTE MMInfo_Insert 661,20960,'¼¯³ÉµÇÂ½','/interface/outter/OutterSys.jsp','mainFrame',11,1,35,0,'',0,'',0,'','',0,'','',9
GO
