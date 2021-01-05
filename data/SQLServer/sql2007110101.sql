delete from SystemRights where id =684
GO
delete from SystemRightsLanguage where id =684
GO
delete from SystemRightDetail where id =4192
GO
insert into SystemRights (id,rightdesc,righttype) values (684,'新闻类型维护','1') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (684,8,'NewTypeMaintenance','NewTypeMaintenance') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (684,7,'新闻类型维护','新闻类型维护') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4192,'新闻类型维护','newstype:maint',684) 
GO
