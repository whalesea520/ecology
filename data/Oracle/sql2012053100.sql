delete from SystemRightDetail where rightid =1290
/
delete from SystemRightsLanguage where id =1290
/
delete from SystemRights where id =1290
/
insert into SystemRights (id,rightdesc,righttype) values (1290,'SAP数据授权设置','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1290,7,'SAP数据授权设置','SAP数据授权设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1290,9,'SAP数据授权设置','SAP数据授权设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1290,8,'SAP Data Auth Setting','SAP Data Auth Setting') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42567,'SAP数据授权设置','SAPDataAuthSetting:Manage',1290) 
/

delete from SystemRightDetail where rightid =1291
/
delete from SystemRightsLanguage where id =1291
/
delete from SystemRights where id =1291
/
insert into SystemRights (id,rightdesc,righttype) values (1291,'配置SAP浏览按钮','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1291,8,'Configure SAP Browse button','Configure SAP Browse button') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1291,7,'配置SAP浏览按钮','配置SAP浏览按钮') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1291,9,'配置SAP浏览按钮','配置SAP浏览按钮') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42568,'配置SAP浏览按钮','SAPBrowserSetting:Manage',1291) 
/