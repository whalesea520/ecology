delete from SystemRightDetail where rightid =1834
GO
delete from SystemRightsLanguage where id =1834
GO
delete from SystemRights where id =1834
GO
insert into SystemRights (id,rightdesc,righttype) values (1834,'����Ԥ��ϸ����','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1834,10,'��ѧ���է� �ҧ�էا֧�� �ڧ���ߧ�֧ߧڧ� ��ѧҧݧڧ�� �����ާ����','��ѧ���է� �ҧ�էا֧�� �ڧ���ߧ�֧ߧڧ� ��ѧҧݧڧ�� �����ާ����') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1834,7,'����Ԥ��ϸ�����鿴','����Ԥ��ϸ�����鿴') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1834,8,'Budget detailed table query','Budget detailed table query') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1834,9,'�M���A�㼚�����鿴','�M���A�㼚�����鿴') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43065,'����Ԥ��ϸ����','fnaRptBudgetDetailed:qry',1834) 
GO