delete from SystemRightDetail where rightid =1611
GO
delete from SystemRightsLanguage where id =1611
GO
delete from SystemRights where id =1611
GO
insert into SystemRights (id,rightdesc,righttype) values (1611,'�½��ͻ�Ȩ��','0') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1611,9,'�½��͑�����','�½��͑�����') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1611,7,'�½��ͻ�Ȩ��','�½��ͻ�Ȩ��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1611,8,'New customer rights','New customer rights') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42841,'�½��ͻ�Ȩ��','crm:addMenu',1611) 
GO


delete from HtmlLabelIndex where id=32493 
GO
delete from HtmlLabelInfo where indexid=32493 
GO
INSERT INTO HtmlLabelIndex values(32493,'Ӫҵִ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(32493,'Ӫҵִ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32493,'business license',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32493,'�I�I����',9) 
GO

delete from HtmlLabelIndex where id=32494 
GO
delete from HtmlLabelInfo where indexid=32494 
GO
INSERT INTO HtmlLabelIndex values(32494,'�ӹ�����֤') 
GO
INSERT INTO HtmlLabelInfo VALUES(32494,'�ӹ�����֤',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32494,'Processing License',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32494,'�ӹ��S���C',9) 
GO

delete from HtmlLabelIndex where id=32495 
GO
delete from HtmlLabelInfo where indexid=32495 
GO
INSERT INTO HtmlLabelIndex values(32495,'��֯�ṹ����֤') 
GO
INSERT INTO HtmlLabelInfo VALUES(32495,'��֯�ṹ����֤',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32495,'Organization Code Certificate',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32495,'�M���Y�����a�C',9) 
GO

delete from HtmlLabelIndex where id=32497 
GO
delete from HtmlLabelInfo where indexid=32497 
GO
INSERT INTO HtmlLabelIndex values(32497,'��ҵ����') 
GO
INSERT INTO HtmlLabelInfo VALUES(32497,'��ҵ����',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32497,'type of enterprise',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32497,'��I���',9) 
GO

delete from HtmlLabelIndex where id=31187 
GO
delete from HtmlLabelInfo where indexid=31187 
GO
INSERT INTO HtmlLabelIndex values(31187,'���ֻ���ϴ�5������') 
GO
INSERT INTO HtmlLabelInfo VALUES(31187,'���ֻ���ϴ�5������',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(31187,'Can only upload up to five attachments',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(31187,'����b���ς�5������',9) 
GO
