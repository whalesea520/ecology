delete from HtmlLabelIndex where id=21705 
GO
delete from HtmlLabelInfo where indexid=21705 
GO
INSERT INTO HtmlLabelIndex values(21705,'是否保留正文版本') 
GO
delete from HtmlLabelIndex where id=21706 
GO
delete from HtmlLabelInfo where indexid=21706 
GO
INSERT INTO HtmlLabelIndex values(21706,'编辑该文') 
GO
INSERT INTO HtmlLabelInfo VALUES(21705,'是否保留正文版本',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21705,'Hold Text Version Or Not',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21706,'编辑该文',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21706,'edit this document',8) 
GO

delete from HtmlLabelIndex where id=21722 
GO
delete from HtmlLabelInfo where indexid=21722 
GO
INSERT INTO HtmlLabelIndex values(21722,'如选，每次保存正文时，正文被存为新版本。') 
GO
INSERT INTO HtmlLabelInfo VALUES(21722,'如选，每次保存正文时，正文被存为新版本。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21722,'If elected, each preserved body, the body was kept for the new version.',8) 
GO

delete from SystemRightDetail where id=4301
GO
delete from SystemRightsLanguage where id=791
GO
delete from SystemRights where id=791
GO
insert into SystemRights (id,rightdesc,righttype) values (791,'查看正文历史版本','1') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (791,7,'查看正文历史版本','查看正文历史版本') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (791,8,'View Text His Version','View Text His Version') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4301,'查看正文历史版本','DocExt:ViewHisVersion',791) 
GO
