delete from SystemRightDetail where rightid =2022
GO
delete from SystemRightsLanguage where id =2022
GO
delete from SystemRights where id =2022
GO
insert into SystemRights (id,rightdesc,righttype) values (2022,'��Ա���ֲ鿴','5') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2022,9,'�ɆT�u�ֲ鿴','�ɆT�u�ֲ鿴') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2022,7,'��Ա���ֲ鿴','��Ա���ֲ鿴') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2022,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2022,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2022,8,'View member ratings','View member ratings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2022,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2022,12,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43239,'��Ա���ֲ鿴','workflow_ratingview',2022) 
GO


delete from HtmlLabelIndex where id=128664 
GO
delete from HtmlLabelInfo where indexid=128664 
GO
INSERT INTO HtmlLabelIndex values(128664,'�ŵ�') 
GO
INSERT INTO HtmlLabelInfo VALUES(128664,'�ŵ�',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128664,'Advantage',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128664,'���c',9) 
GO

delete from HtmlLabelIndex where id=128665 
GO
delete from HtmlLabelInfo where indexid=128665 
GO
INSERT INTO HtmlLabelIndex values(128665,'ȱ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(128665,'ȱ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128665,'Shortcoming',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128665,'ȱ�c',9) 
GO

delete from HtmlLabelIndex where id=128666 
GO
delete from HtmlLabelInfo where indexid=128666 
GO
INSERT INTO HtmlLabelIndex values(128666,'�Ľ�����') 
GO
INSERT INTO HtmlLabelInfo VALUES(128666,'�Ľ�����',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128666,'Improvement suggestions',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128666,'���M���h',9) 
GO

delete from HtmlLabelIndex where id=128691 
GO
delete from HtmlLabelInfo where indexid=128691 
GO
INSERT INTO HtmlLabelIndex values(128691,'������������') 
GO
INSERT INTO HtmlLabelInfo VALUES(128691,'������������',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128691,'Name of the person being evaluated',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128691,'���u��������',9) 
GO