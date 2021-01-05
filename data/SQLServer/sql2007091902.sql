delete from SystemRights  where id=712
go
delete from SystemRightsLanguage  where id=712
go
delete from SystemRightDetail  where id=4220
go
insert into SystemRights (id,rightdesc,righttype) values (712,'管理索引权限','1')
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (712,8,'IndexManager','IndexManager')
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (712,7,'搜索索引管理','搜索索引管理')
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4220,'索引管理','searchIndex:manager',712)
GO

delete from leftmenuinfo where id=217
GO
delete from leftmenuconfig where infoid=217
GO
EXECUTE LMConfig_U_ByInfoInsert 2,2,15
GO
EXECUTE LMInfo_Insert 217,20421,'/images/icon_balancelist.gif','/docs/search/SearchDocuments.jsp',2,2,15,1
GO

delete from mainmenuinfo where id=602
GO
delete from mainmenuconfig where infoid=602
GO
EXECUTE MMConfig_U_ByInfoInsert 2,24
GO
EXECUTE MMInfo_Insert 602,20422,'搜索索引管理','/docs/search/IndexManager.jsp','mainFrame',2,1,24,0,'',0,'',0,'','',0,'','',1
GO

update mainmenuinfo set parentid=635,defaultparentid=635 where id =602
GO
