alter table fnaFeeWfInfoField add isWfFieldLinkage int
GO

update fnaFeeWfInfoField set isWfFieldLinkage = 0
GO

delete from HtmlLabelIndex where id=127850 
GO
delete from HtmlLabelInfo where indexid=127850 
GO
INSERT INTO HtmlLabelIndex values(127850,'�ֶ�����ʵ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(127850,'�ֶ�����ʵ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127850,'Field linkage implementation',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127850,'�ֶ��ӌ��F',9) 
GO