delete from SystemRightDetail where rightid =2086
GO
delete from SystemRightsLanguage where id =2086
GO
delete from SystemRights where id =2086
GO
insert into SystemRights (id,rightdesc,righttype,detachable) values (2086,'文档回收站管理','1','1') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2086,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2086,9,'回收站文檔管理','回收站文檔管理') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2086,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2086,7,'回收站文档管理','回收站文档管理') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2086,8,'Recycle bin document management','Recycle bin document management') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2086,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2086,15,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43308,'回收站文档管理','DocumentRecycle:All',2086) 
GO

delete from SystemRightToGroup where rightid=2086
GO
insert into SystemRightToGroup(Groupid,Rightid) values (2,2086)
GO