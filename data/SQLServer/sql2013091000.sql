delete from SystemRightDetail where rightid =1547
GO
delete from SystemRightsLanguage where id =1547
GO
delete from SystemRights where id =1547
GO
insert into SystemRights (id,rightdesc,righttype) values (1547,'知识管理应用设置','1') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1547,8,'Knowledge management applications settings','Knowledge management applications settings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1547,7,'知识管理应用设置','知识管理应用设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1547,9,'知識管理應用設置','知識管理應用設置') 
GO

