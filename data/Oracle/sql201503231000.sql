delete from SystemRightDetail where rightid =1833
/
delete from SystemRightsLanguage where id =1833
/
delete from SystemRights where id =1833
/
insert into SystemRights (id,rightdesc,righttype) values (1833,'���û��ܱ��鿴','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1833,10,'���ӧ�էߧѧ� ��ѧҧݧڧ�� ��ѧ���է��','���ӧ�էߧѧ� ��ѧҧݧڧ�� ��ѧ���է��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1833,7,'���û��ܱ��鿴','���û��ܱ��鿴') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1833,8,'cost summary query','cost summary query') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1833,9,'�M�Ï������鿴','�M�Ï������鿴') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43064,'���û��ܱ��鿴','costSummary:qry',1833) 
/