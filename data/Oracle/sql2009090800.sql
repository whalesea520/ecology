delete from SystemRightDetail where rightid = 869
/
delete from SystemRightsLanguage where id = 869
/
delete from SystemRights where id = 869
/

insert into SystemRights (id,rightdesc,righttype) values (869,'配置文件设置','0') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (869,8,'service file setting','service file setting') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (869,7,'配置文件设置','配置文件设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (869,9,'配置文件設置','配置文件設置') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4391,'配置文件设置','ServiceFile:Manage',869) 
/
