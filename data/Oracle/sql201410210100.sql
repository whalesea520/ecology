delete from SystemRightDetail where rightid =1757
/
delete from SystemRightsLanguage where id =1757
/
delete from SystemRights where id =1757
/
insert into SystemRights (id,rightdesc,righttype) values (1757,'���̽ӿڿ���','5') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1757,8,'Workflow Interface development','Workflow Interface development') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1757,7,'���̽ӿڿ���','���̽ӿڿ���') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1757,9,'���̽ӿ��_�l','���̽ӿ��_�l') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42990,'���̽ӿڿ���Ȩ��','Workflow:InterfaceDev',1757) 
/


delete from SystemRightDetail where rightid =301
/
delete from SystemRightsLanguage where id =301
/
delete from SystemRights where id =301
/

delete from SystemRightDetail where rightid =1749
/
delete from SystemRightsLanguage where id =1749
/
delete from SystemRights where id =1749
/
insert into SystemRights (id,rightdesc,righttype) values (1749,'���̷���ά��','5') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1749,9,'���̷���S�o','���̷���S�o') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1749,7,'���̷���ά��','���̷���ά��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1749,8,'workflow Reverse maintenance','workflow Reverse maintenance') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42979,'���̷���ά��','Workflow:permission',1749) 
/