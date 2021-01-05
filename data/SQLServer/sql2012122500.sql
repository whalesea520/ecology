delete from SystemRightDetail where rightid =1417
GO
delete from SystemRightsLanguage where id =1417
GO
delete from SystemRights where id =1417
GO
insert into SystemRights (id,rightdesc,righttype) values (1417,'财务设置权限','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1417,7,'财务设置权限','财务设置权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1417,8,'Financial set permissions','Financial set permissions') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1417,9,'財務設置權限','財務設置權限') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42672,'财务设置权限','FnaSystemSetEdit:Edit',1417) 
GO