delete from SystemRightDetail where rightid =90
GO
delete from SystemRightsLanguage where id =90
GO
delete from SystemRights where id =90
GO
insert into SystemRights (id,rightdesc,righttype) values (90,'系统设置','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (90,8,'SystemSet','SystemSet') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (90,7,'系统设置','系统设置') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (330,'系统设置','SystemSetEdit:Edit',90) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43370,'敏感字维护权限','SensitiveWord:Manage',90) 
GO