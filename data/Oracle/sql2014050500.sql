
delete from SystemRightDetail where rightid =1643
/
delete from SystemRightsLanguage where id =1643
/
delete from SystemRights where id =1643
/
insert into SystemRights (id,rightdesc,righttype) values (1643,'����Ӧ������','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1643,9,'���ő����O��','���ő����O��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1643,7,'����Ӧ������','����Ӧ������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1643,8,'Sms Setting','Sms Setting') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42875,'����Ӧ������','Sms:Set',1643) 
/