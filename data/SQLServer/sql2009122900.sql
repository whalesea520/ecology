delete from SystemRightDetail where rightid = 873
GO
delete from SystemRightsLanguage where id = 873
GO
delete from SystemRights where id = 873
GO

insert into SystemRights (id,rightdesc,righttype) values (873,'文档日志查看','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (873,7,'文档日志查看','文档日志查看') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (873,8,'File log view','File log view') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (873,9,'文?日?查看','文?日?查看') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4395,'文档日志查看权限','FileLogView:View',873) 
GO
