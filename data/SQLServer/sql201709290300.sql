delete from SystemRightDetail where rightid =2150
GO
delete from SystemRightsLanguage where id =2150
GO
delete from SystemRights where id =2150
GO
insert into SystemRights (id,rightdesc,righttype) values (2150,'日志监控','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2150,7,'日志监控','日志监控') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2150,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2150,8,'tail:log','tail:log') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2150,9,'日誌監控','日誌監控') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2150,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2150,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2150,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2150,16,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43376,'日志监控','tail:log',2150) 
GO