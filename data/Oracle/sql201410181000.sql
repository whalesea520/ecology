delete from SystemRightDetail where rightid =1756
/
delete from SystemRightsLanguage where id =1756
/
delete from SystemRights where id =1756
/
insert into SystemRights (id,rightdesc,righttype) values (1756,'邮件设置','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1756,8,'Email Setting','Email Setting') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1756,7,'邮件设置','邮件设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1756,9,'郵件設置','郵件設置') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42986,'邮件系统设置','email:sysSetting',1756) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42987,'邮件模板设置','email:templateSetting',1756) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42988,'企业邮箱设置','email:enterpriseSetting',1756) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42989,'邮箱空间设置','email:spaceSetting',1756) 
/
