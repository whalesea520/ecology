delete from SystemRightDetail where rightid =1726
GO
delete from SystemRightsLanguage where id =1726
GO
delete from SystemRights where id =1726
GO
insert into SystemRights (id,rightdesc,righttype) values (1726,'邮件监控权限','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1726,7,'邮件监控权限','邮件监控权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1726,8,'E-mail monitoring right','E-mail monitoring right') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1726,9,'郵件監控權限','郵件監控權限') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42951,'邮件监控权限','Email:monitor',1726) 
GO
