delete from SystemRightDetail where rightid =457
/
delete from SystemRightsLanguage where id =457
/
delete from SystemRights where id =457
/
insert into SystemRights (id,rightdesc,righttype) values (457,'֪ʶ���۴��±����鿴Ȩ��','1') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (457,7,'֪ʶ���۴��±����鿴Ȩ��','֪ʶ���۴��±����鿴Ȩ��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (457,8,'doc creative report','doc creative report') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3148,'֪ʶ���۴��±����鿴Ȩ��','docactiverep:view',457) 
/