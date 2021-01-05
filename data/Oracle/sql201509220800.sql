delete from SystemRightDetail where rightid =1914
/
delete from SystemRightsLanguage where id =1914
/
delete from SystemRights where id =1914
/
insert into SystemRights (id,rightdesc,righttype) values (1914,'模块管理分权','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1914,8,'Module management decentralization','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1914,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1914,9,'模塊管理分權','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1914,7,'模块管理分权','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43140,'模块管理分权','HrmModuleManageDetach:Edit',1914) 
/
 
delete from SystemRightDetail where rightid =1913
/
delete from SystemRightsLanguage where id =1913
/
delete from SystemRights where id =1913
/
insert into SystemRights (id,rightdesc,righttype) values (1913,'功能管理赋权','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1913,7,'功能管理赋权','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1913,8,'Functional management empowerment','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1913,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1913,9,'功能管理賦權','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43139,'功能管理赋权','HrmEffectManageEmpower:Edit',1913) 
/