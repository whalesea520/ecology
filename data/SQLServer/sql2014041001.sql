delete from HtmlLabelIndex where id=32948 
GO
delete from HtmlLabelInfo where indexid=32948 
GO
INSERT INTO HtmlLabelIndex values(32948,'�ʼ�����') 
GO
INSERT INTO HtmlLabelInfo VALUES(32948,'�ʼ�����',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32948,'Email reports',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32948,'�]�����',9) 
GO

delete from SystemRightDetail where rightid =1642
GO
delete from SystemRightsLanguage where id =1642
GO
delete from SystemRights where id =1642
GO
insert into SystemRights (id,rightdesc,righttype) values (1642,'�ʼ�����','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1642,8,'Email reports','Email reports') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1642,7,'�ʼ�����','�ʼ�����') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1642,9,'�]�����','�]�����') 
GO

delete from SystemRightDetail where rightid =1642
GO
delete from SystemRightsLanguage where id =1642
GO
delete from SystemRights where id =1642
GO
insert into SystemRights (id,rightdesc,righttype) values (1642,'�ʼ�����Ȩ��','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1642,8,'Email reports','Email reports') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1642,7,'�ʼ�����Ȩ��','�ʼ�����Ȩ��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1642,9,'�]��������','�]��������') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42874,'�ʼ�����Ȩ��','email:report',1642) 
GO