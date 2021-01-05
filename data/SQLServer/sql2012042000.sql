delete from SystemRightDetail where rightid =1260
GO
delete from SystemRightsLanguage where id =1260
GO
delete from SystemRights where id =1260
GO
insert into SystemRights (id,rightdesc,righttype) values (1260,'测试流程删除','5') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1260,7,'测试流程删除','测试流程删除') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1260,9,'測試流程删除','測試流程删除') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1260,8,'Delete Test-Request','Delete Test-Request') 
GO