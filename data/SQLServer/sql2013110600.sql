delete from SystemRights  where id=712
go
delete from SystemRightsLanguage  where id=712
go
delete from SystemRightDetail  where id=4220
go
insert into SystemRights (id,rightdesc,righttype) values (712,'��������Ȩ��','1')
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (712,8,'IndexManager','IndexManager')
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (712,7,'������������','������������')
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4220,'��������','searchIndex:manager',712)
GO