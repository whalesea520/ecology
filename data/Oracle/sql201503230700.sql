delete from SystemRightDetail where rightid =1834
/
delete from SystemRightsLanguage where id =1834
/
delete from SystemRights where id =1834
/
insert into SystemRights (id,rightdesc,righttype) values (1834,'����Ԥ��ϸ����','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1834,10,'��ѧ���է� �ҧ�էا֧�� �ڧ���ߧ�֧ߧڧ� ��ѧҧݧڧ�� �����ާ����','��ѧ���է� �ҧ�էا֧�� �ڧ���ߧ�֧ߧڧ� ��ѧҧݧڧ�� �����ާ����') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1834,7,'����Ԥ��ϸ�����鿴','����Ԥ��ϸ�����鿴') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1834,8,'Budget detailed table query','Budget detailed table query') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1834,9,'�M���A�㼚�����鿴','�M���A�㼚�����鿴') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43065,'����Ԥ��ϸ����','fnaRptBudgetDetailed:qry',1834) 
/