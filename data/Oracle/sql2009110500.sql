delete from SystemRightDetail where rightid = 876
/
delete from SystemRightsLanguage where id = 876
/
delete from SystemRights where id = 876
/

insert into SystemRights (id,rightdesc,righttype) values (876,'�ֻ��汾����','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (876,7,'�ֻ��汾����','�ֻ��汾����') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (876,8,'Ecology Mobile Setting','Ecology Mobile Setting') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (876,9,'�֙C�汾�O��','�֙C�汾�O��') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4398,'�ֻ��汾����','Mobile:Setting',876) 
/
