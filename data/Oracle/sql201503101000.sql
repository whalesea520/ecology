delete from SystemRightDetail where rightid =1825
/
delete from SystemRightsLanguage where id =1825
/
delete from SystemRights where id =1825
/
insert into SystemRights (id,rightdesc,righttype) values (1825,'Ԥ���ܶ����ѯ','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1825,8,'Total budget table','Total budget table') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1825,7,'Ԥ���ܶ����ѯ','Ԥ���ܶ����ѯ') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1825,9,'�A�㿂�~����ԃ','�A�㿂�~����ԃ') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1825,10,'���ҧ�ѧ� ���ާާ� �ҧ�էا֧��, ��ѧҧݧڧ��','���ҧ�ѧ� ���ާާ� �ҧ�էا֧��, ��ѧҧݧڧ��') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43057,'Ԥ���ܶ��','TotalBudgetTable:qry',1825) 
/