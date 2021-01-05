delete from SystemRightDetail where rightid =1625
/
delete from SystemRightsLanguage where id =1625
/
delete from SystemRights where id =1625
/
insert into SystemRights (id,rightdesc,righttype) values (1625,'微信管理','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1625,7,'微信公众平台管理','微信公众平台管理') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1625,8,'wechat managermenet','wechat managermenet') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1625,9,'微信公衆平台管理','微信公衆平台管理') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42861,'微信公众平台管理','Wechat:Mgr',1625) 
/


delete from SystemRightDetail where rightid =1631
/
delete from SystemRightsLanguage where id =1631
/
delete from SystemRights where id =1631
/
insert into SystemRights (id,rightdesc,righttype) values (1631,'微信应用设置','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1631,8,'Wechat Setting','Wechat Setting') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1631,7,'微信应用设置','微信应用设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1631,9,'微信應用設置','微信應用設置') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42866,'微信应用设置','Wechat:Set',1631) 
/