delete from SystemRightDetail where rightid =1260
/
delete from SystemRightsLanguage where id =1260
/
delete from SystemRights where id =1260
/
insert into SystemRights (id,rightdesc,righttype) values (1260,'���̲���Ȩ��','5') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1260,7,'���̲���Ȩ��','���̲���Ȩ��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1260,9,'���̜yԇ����','���̜yԇ����') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1260,8,'Workflow Test Authority','Workflow Test Authority') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42537,'��������ɾ��','Delete:TestRequest',1260) 
/