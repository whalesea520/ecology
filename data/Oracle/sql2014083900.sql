delete from SystemRightDetail where rightid =1660
/
delete from SystemRightsLanguage where id =1660
/
delete from SystemRights where id =1660
/
insert into SystemRights (id,rightdesc,righttype) values (1660,'Ԥ������Ȩ��','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) 
values (1660,7,'Ԥ������Ȩ��','Ԥ������Ȩ��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) 
values (1660,9,'�A���O�Ù���','�A���O�Ù���') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) 
values (1660,8,'Budget organization structure is permission settings','Budget organization structure is permission settings') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) 
values (42890,'Ԥ������Ȩ��','BudgetOrgPermission:settings',1660) 
/

delete from SystemRightDetail where rightid =1679
/
delete from SystemRightsLanguage where id =1679
/
delete from SystemRights where id =1679
/
insert into SystemRights (id,rightdesc,righttype) values (1679,'�ѿط���','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) 
values (1679,7,'�ѿط���','�ѿط���') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) 
values (1679,9,'�M�ط���','�M�ط���') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) 
values (1679,8,'fna control scheme','fna control scheme') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) 
values (42905,'�ѿط���','fnaControlScheme:set',1679) 
/

delete from SystemRightDetail where rightid =1666
/
delete from SystemRightsLanguage where id =1666
/
delete from SystemRights where id =1666
/
insert into SystemRights (id,rightdesc,righttype) values (1666,'�ѿ���������','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) 
values (1666,7,'�ѿ���������','�ѿ���������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) 
values (1666,8,'Cost control procedure','Cost control procedure') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) 
values (1666,9,'�M�������O��','�M�������O��') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) 
values (42893,'�ѿ���������','CostControlProcedure:set',1666) 
/