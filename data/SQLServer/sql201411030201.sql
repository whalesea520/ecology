delete from SystemRightDetail where rightid =1767
GO
delete from SystemRightsLanguage where id =1767
GO
delete from SystemRights where id =1767
GO
insert into SystemRights (id,rightdesc,righttype) values (1767,'���п���Ϣά��','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1767,8,'BankAccountInfoOperation','BankAccountInfoOperation') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1767,7,'���п���Ϣά��','���п���Ϣά��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1767,9,'�y�п���Ϣ�S�o','�y�п���Ϣ�S�o') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43002,'���п���Ϣά��','BankAccountInfo:Operate',1767) 
GO