delete from SystemRightDetail where rightid =1828
GO
delete from SystemRightsLanguage where id =1828
GO
delete from SystemRights where id =1828
GO
insert into SystemRights (id,rightdesc,righttype) values (1828,'���ò�ѯͳ�Ʊ���ѯ','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1828,10,'��ѧ���է� �٧ѧ���� ���ѧ�ڧ��ڧ�֧�ܧڧ� ��ѧҧݧڧ�� �٧ѧ������','��ѧ���է� �٧ѧ���� ���ѧ�ڧ��ڧ�֧�ܧڧ� ��ѧҧݧڧ�� �٧ѧ������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1828,8,'The cost of query statistics table query','The cost of query statistics table query') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1828,7,'���ò�ѯͳ�Ʊ���ѯ','���ò�ѯͳ�Ʊ���ѯ') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1828,9,'�M�ò�ԃ�yӋ����ԃ','�M�ò�ԃ�yӋ����ԃ') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43060,'���ò�ѯͳ�Ʊ���ѯ','TheCostOfQueryStatistics:query',1828) 
GO