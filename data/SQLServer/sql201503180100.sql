delete from SystemRightDetail where rightid =1829
GO
delete from SystemRightsLanguage where id =1829
GO
delete from SystemRights where id =1829
GO
insert into SystemRights (id,rightdesc,righttype) values (1829,'Ԥ��ִ�������','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1829,7,'Ԥ��ִ�������','Ԥ��ִ�������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1829,10,'���ѧҧݧڧ�� �ڧ���ݧߧ֧ߧڧ� �ҧ�էا֧��','���ѧҧݧڧ�� �ڧ���ݧߧ֧ߧڧ� �ҧ�էا֧��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1829,8,'The implementation of the budget table','The implementation of the budget table') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1829,9,'�A�������r��','�A�������r��') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43061,'Ԥ��ִ�������','fnaRptImplementation:qry',1829) 
GO