delete from SystemRightDetail where rightid =1767
GO
delete from SystemRightsLanguage where id =1767
GO
delete from SystemRights where id =1767
GO
insert into SystemRights (id,rightdesc,righttype) values (1767,'银行卡信息维护','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1767,8,'BankAccountInfoOperation','BankAccountInfoOperation') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1767,7,'银行卡信息维护','银行卡信息维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1767,9,'銀行卡信息維護','銀行卡信息維護') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43002,'银行卡信息维护','BankAccountInfo:Operate',1767) 
GO