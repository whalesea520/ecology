delete from SystemRightDetail where rightid =1292
GO
delete from SystemRightsLanguage where id =1292
GO
delete from SystemRights where id =1292
GO
insert into SystemRights (id,rightdesc,righttype) values (1292,'��ְ��Ա�鿴','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1292,7,'��ְ��Ա�鿴','��ְ��Ա�鿴') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1292,9,'�x�ˆT�鿴','�x�ˆT�鿴') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1292,8,'Departure View','Departure View') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42569,'��ְ��Ա�鿴','hrm:departureView',1292) 
GO