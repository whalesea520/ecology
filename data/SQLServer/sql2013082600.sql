delete from SystemRightDetail where rightid =1535
GO
delete from SystemRightsLanguage where id =1535
GO
delete from SystemRights where id =1535
GO
insert into SystemRights (id,rightdesc,righttype) values (1535,'���������ĵ�����','1') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1535,8,'Document Sharing','Document Sharing') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1535,7,'���������ĵ�����','���������ĵ�����') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1535,9,'�����{���ęn����','�����{���ęn����') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42782,'���������ĵ�����','DocShareRight:all',1535) 
GO