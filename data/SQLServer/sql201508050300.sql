delete from SystemRightDetail where rightid =536
GO
delete from SystemRightsLanguage where id =536
GO
delete from SystemRights where id =536
GO
insert into SystemRights (id,rightdesc,righttype) values (536,'��Ʒ�б�','1') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (536,8,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (536,7,'��Ʒ�б�','��Ʒ�б�ҳ��Ȩ��') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4036,'��Ʒ�б�','ProductList:View',536) 
GO