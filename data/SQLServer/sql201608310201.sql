delete from SystemRightDetail where rightid =2011
GO
delete from SystemRightsLanguage where id =2011
GO
delete from SystemRights where id =2011
GO
insert into SystemRights (id,rightdesc,righttype) values (2011,'�ɹ�Ȩ��','5') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2011,9,'�ɹ�����','�ɹ�����') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2011,7,'�ɹ�Ȩ��','�ɹ�Ȩ��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2011,8,'Dispatching authority','Dispatching authority') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2011,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2011,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2011,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2011,15,'','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43229,'�ɹ�Ȩ��','workflow:Dispatching',2011) 
GO


delete from HtmlLabelIndex where id=128468 
GO
delete from HtmlLabelInfo where indexid=128468 
GO
INSERT INTO HtmlLabelIndex values(128468,'�ֶ�') 
GO
INSERT INTO HtmlLabelInfo VALUES(128468,'�ֶ�',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128468,'Manually',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128468,'�ք�',9) 
GO

delete from HtmlLabelIndex where id=128469 
GO
delete from HtmlLabelInfo where indexid=128469 
GO
INSERT INTO HtmlLabelIndex values(128469,'�ɹ�') 
GO
INSERT INTO HtmlLabelInfo VALUES(128469,'�ɹ�',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128469,'Dispatching',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128469,'�ɹ�',9) 
GO