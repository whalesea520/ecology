delete from SystemRightDetail where rightid =806
GO
delete from SystemRightsLanguage where id =806
GO
delete from SystemRights where id =806
GO
delete from SystemRightDetail where rightid =1827
GO
delete from SystemRightsLanguage where id =1827
GO
delete from SystemRights where id =1827
GO
insert into SystemRights (id,rightdesc,righttype) values (1827,'系统信息批量维护','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1827,7,'系统信息批量维护','系统信息批量维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1827,10,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1827,8,'HrmResourceSys','HrmResourceSys') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1827,9,'系統信息批量維護','系統信息批量維護') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43059,'系统信息批量维护','HrmResourceSys:Mgr',1827) 
GO