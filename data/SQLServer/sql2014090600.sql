delete from SystemRightDetail where rightid =1727
go
delete from SystemRightsLanguage where id =1727
go
delete from SystemRights where id =1727
go
insert into SystemRights (id,rightdesc,righttype) values (1727,'�ƶ���ģ����','7') 
go
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1727,7,'�ƶ���ģ����','�ƶ���ģ����') 
go
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1727,8,'Mobile Mode Settings','Mobile Mode Settings') 
go
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1727,9,'�Ƅӽ�ģ�O��','�Ƅӽ�ģ�O��') 
go
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42953,'�ƶ���ģ������ȫ����Ȩ��','MobileModeSet:All',1727) 
go