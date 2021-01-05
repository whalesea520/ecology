delete from SystemRightDetail where rightid =1803
GO
delete from SystemRightsLanguage where id =1803
GO
delete from SystemRights where id =1803
GO
insert into SystemRights (id,rightdesc,righttype) values (1803,'项目导入权限','6') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1803,9,'項目導入','項目導入') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1803,7,'项目导入权限','项目导入权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1803,8,'Project Import','Project Import') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1803,10,'','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (41803,'项目导入权限','Prj:Imp',1803) 
GO