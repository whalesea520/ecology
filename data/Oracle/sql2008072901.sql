delete from HtmlLabelIndex where id=21705 
/
delete from HtmlLabelInfo where indexid=21705 
/
INSERT INTO HtmlLabelIndex values(21705,'是否保留正文版本') 
/
delete from HtmlLabelIndex where id=21706 
/
delete from HtmlLabelInfo where indexid=21706 
/
INSERT INTO HtmlLabelIndex values(21706,'编辑该文') 
/
INSERT INTO HtmlLabelInfo VALUES(21705,'是否保留正文版本',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21705,'Hold Text Version Or Not',8) 
/
INSERT INTO HtmlLabelInfo VALUES(21706,'编辑该文',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21706,'edit this document',8) 
/

delete from HtmlLabelIndex where id=21722 
/
delete from HtmlLabelInfo where indexid=21722 
/
INSERT INTO HtmlLabelIndex values(21722,'如选，每次保存正文时，正文被存为新版本。') 
/
INSERT INTO HtmlLabelInfo VALUES(21722,'如选，每次保存正文时，正文被存为新版本。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21722,'If elected, each preserved body, the body was kept for the new version.',8) 
/


delete from SystemRightDetail where id=4301
/
delete from SystemRightsLanguage where id=791
/
delete from SystemRights where id=791
/
insert into SystemRights (id,rightdesc,righttype) values (791,'查看正文历史版本','1') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (791,7,'查看正文历史版本','查看正文历史版本') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (791,8,'View Text His Version','View Text His Version') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4301,'查看正文历史版本','DocExt:ViewHisVersion',791) 
/
