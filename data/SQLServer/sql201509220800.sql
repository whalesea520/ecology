delete from SystemRightDetail where rightid =1914
GO
delete from SystemRightsLanguage where id =1914
GO
delete from SystemRights where id =1914
GO
insert into SystemRights (id,rightdesc,righttype) values (1914,'模块管理分权','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1914,8,'Module management decentralization','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1914,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1914,9,'模塊管理分權','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1914,7,'模块管理分权','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43140,'模块管理分权','HrmModuleManageDetach:Edit',1914) 
GO
 
delete from SystemRightDetail where rightid =1913
GO
delete from SystemRightsLanguage where id =1913
GO
delete from SystemRights where id =1913
GO
insert into SystemRights (id,rightdesc,righttype) values (1913,'功能管理赋权','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1913,7,'功能管理赋权','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1913,8,'Functional management empowerment','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1913,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1913,9,'功能管理賦權','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43139,'功能管理赋权','HrmEffectManageEmpower:Edit',1913) 
GO