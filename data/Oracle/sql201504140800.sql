delete from SystemRightDetail where rightid =1841
/
delete from SystemRightsLanguage where id =1841
/
delete from SystemRights where id =1841
/
insert into SystemRights (id,rightdesc,righttype) values (1841,'�ʲ�������ѯ����','4') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1841,8,'CapitalBrowser Def','CapitalBrowser Def') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1841,7,'�ʲ�������ѯ����','�ʲ�������ѯ����') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1841,9,'�Y�a�g�[���ԃ���x','�Y�a�g�[���ԃ���x') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (41841,'�ʲ�������ѯ����','CptMaint:CptBrowDef',1841) 
/