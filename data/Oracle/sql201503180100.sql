delete from SystemRightDetail where rightid =1829
/
delete from SystemRightsLanguage where id =1829
/
delete from SystemRights where id =1829
/
insert into SystemRights (id,rightdesc,righttype) values (1829,'Ԥ��ִ�������','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1829,7,'Ԥ��ִ�������','Ԥ��ִ�������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1829,10,'���ѧҧݧڧ�� �ڧ���ݧߧ֧ߧڧ� �ҧ�էا֧��','���ѧҧݧڧ�� �ڧ���ݧߧ֧ߧڧ� �ҧ�էا֧��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1829,8,'The implementation of the budget table','The implementation of the budget table') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1829,9,'�A�������r��','�A�������r��') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43061,'Ԥ��ִ�������','fnaRptImplementation:qry',1829) 
/