delete from SystemRightDetail where rightid =1776
/
delete from SystemRightsLanguage where id =1776
/
delete from SystemRights where id =1776
/
insert into SystemRights (id,rightdesc,righttype) values (1776,'��¼ǰ�Ż�ά��','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1776,8,'LoginPage Maintenance','LoginPage Maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1776,7,'��¼ǰ�Ż�ά��','��¼ǰ�Ż�ά��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1776,9,'���ǰ�T���S�o','���ǰ�T���S�o') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43010,'��¼ǰ�Ż�ά��','LoginPageMaint',1776) 
/