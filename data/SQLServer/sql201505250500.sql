delete from SystemRightDetail where rightid =1865
GO
delete from SystemRightsLanguage where id =1865
GO
delete from SystemRights where id =1865
GO
insert into SystemRights (id,rightdesc,righttype) values (1865,'协同区维护权限','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1865,7,'协同区维护权限','协同区维护权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1865,8,'Synergy Maintenance','Synergy Maintenance') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1865,9,'協同區維護權限','協同區維護權限') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43094,'协同区维护权限','Synergy:Maint',1865) 
GO