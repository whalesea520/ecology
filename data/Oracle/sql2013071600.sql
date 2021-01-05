delete from SystemRightDetail where rightid =457
/
delete from SystemRightsLanguage where id =457
/
delete from SystemRights where id =457
/
insert into SystemRights (id,rightdesc,righttype) values (457,'知识积累创新报表查看权限','1') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (457,7,'知识积累创新报表查看权限','知识积累创新报表查看权限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (457,8,'doc creative report','doc creative report') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3148,'知识积累创新报表查看权限','docactiverep:view',457) 
/