delete from SystemRightDetail where rightid =1933
/
delete from SystemRightsLanguage where id =1933
/
delete from SystemRights where id =1933
/
insert into SystemRights (id,rightdesc,righttype) values (1933,'Ԥ�������ʼ��Ȩ��','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1933,7,'Ԥ�������ʼ��Ȩ��','Ԥ�������ʼ��Ȩ��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1933,8,'Budget initialization operation permissions','Budget initialization operation permissions') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1933,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1933,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1933,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1933,9,'�A�������ʼ������','�A�������ʼ������') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43153,'Ԥ�������ʼ��Ȩ��','BudgetOperation:Restoration',1933) 
/