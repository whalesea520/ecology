delete from SystemRightDetail where rightid =1417
/
delete from SystemRightsLanguage where id =1417
/
delete from SystemRights where id =1417
/
insert into SystemRights (id,rightdesc,righttype) values (1417,'��������Ȩ��','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1417,7,'��������Ȩ��','��������Ȩ��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1417,8,'Financial set permissions','Financial set permissions') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1417,9,'ؔ���O�Ù���','ؔ���O�Ù���') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42672,'��������Ȩ��','FnaSystemSetEdit:Edit',1417) 
/