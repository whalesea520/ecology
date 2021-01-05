delete from SystemRightDetail where rightid =1771
/
delete from SystemRightsLanguage where id =1771
/
delete from SystemRights where id =1771
/
insert into SystemRights (id,rightdesc,righttype) values (1771,'代码认证管理员','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1771,7,'代码认证管理员','代码认证管理员') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1771,8,'code administrator','code administrator') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1771,9,'代码认证管理员','代码认证管理员') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43006,'代码认证管理员','code:Administrator',1771) 
/