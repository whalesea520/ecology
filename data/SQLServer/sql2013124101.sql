delete from HtmlLabelIndex where id=30480 
GO
delete from HtmlLabelInfo where indexid=30480 
GO
INSERT INTO HtmlLabelIndex values(30480,'��Ŀ��������') 
GO
INSERT INTO HtmlLabelInfo VALUES(30480,'��Ŀ��������',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(30480,'The subjects their respective departments',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(30480,'��Ŀ���ٲ��T',9) 
GO

delete from HtmlLabelIndex where id=32389 
GO
delete from HtmlLabelInfo where indexid=32389 
GO
INSERT INTO HtmlLabelIndex values(32389,'�Ƿ����ⲿ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(32389,'�Ƿ����ⲿ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32389,'Is Virtual',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32389,'�Ƿ�̓�ⲿ�T',9) 
GO
alter table FnaExpenseInfo add shareRequestId VARCHAR(200)
GO