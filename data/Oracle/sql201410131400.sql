delete from SystemRightDetail where rightid =1738
/
delete from SystemRightsLanguage where id =1738
/
delete from SystemRights where id =1738
/
insert into SystemRights (id,rightdesc,righttype) values (1738,'Ԥ��ݸ���������','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1738,9,'�A��ݸ���������','�A��ݸ���������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1738,7,'Ԥ��ݸ���������','Ԥ��ݸ���������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1738,8,'The budget draft batch import','The budget draft batch import') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42969,'Ԥ��ݸ���������','BudgetDraftBatchImport:imp',1738) 
/



delete from SystemRightDetail where rightid =1739
/
delete from SystemRightsLanguage where id =1739
/
delete from SystemRights where id =1739
/
insert into SystemRights (id,rightdesc,righttype) values (1739,'Ԥ��ݸ�������Ч','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1739,8,'The budget draft batch effect','The budget draft batch effect') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1739,7,'Ԥ��ݸ�������Ч','Ԥ��ݸ�������Ч') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1739,9,'�A��ݸ�������Ч','�A��ݸ�������Ч') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42970,'Ԥ��ݸ�������Ч','BudgetDraftBatchEffect:effect',1739) 
/