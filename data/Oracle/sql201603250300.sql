delete from SystemRightDetail where rightid =1292
/
delete from SystemRightsLanguage where id =1292
/
delete from SystemRights where id =1292
/
insert into SystemRights (id,rightdesc,righttype) values (1292,'��ְ��Ա�鿴','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1292,7,'��ְ��Ա�鿴','��ְ��Ա�鿴') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1292,9,'�x�ˆT�鿴','�x�ˆT�鿴') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1292,8,'Departure View','Departure View') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42569,'��ְ��Ա�鿴','hrm:departureView',1292) 
/