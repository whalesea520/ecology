delete from SystemRightDetail where rightid =1727
/
delete from SystemRightsLanguage where id =1727
/
delete from SystemRights where id =1727
/
insert into SystemRights (id,rightdesc,righttype) values (1727,'�ƶ���ģ����','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1727,7,'�ƶ���ģ����','�ƶ���ģ����') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1727,8,'Mobile Mode Settings','Mobile Mode Settings') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1727,9,'�Ƅӽ�ģ�O��','�Ƅӽ�ģ�O��') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42953,'�ƶ���ģ������ȫ����Ȩ��','MobileModeSet:All',1727) 
/