delete from SystemRightDetail where rightid =1731
GO
delete from SystemRightsLanguage where id =1731
GO
delete from SystemRights where id =1731
GO
insert into SystemRights (id,rightdesc,righttype) values (1731,'矩阵管理权限','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1731,8,'Matrix management authority','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1731,7,'矩阵管理权限','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1731,9,'矩陣管理權限','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42965,'矩阵维护权限','Matrix:Maint',1731) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42960,'矩阵批量维护权限','Matrix:MassMaint',1731) 
GO
