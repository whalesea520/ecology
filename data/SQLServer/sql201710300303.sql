ALTER TABLE FnaBudgetfeeType ALTER COLUMN groupDispalyOrder VARCHAR(500)
GO


ALTER TABLE FnaBatch4Subject ALTER COLUMN groupDispalyOrder VARCHAR(500)
GO


delete from HtmlLabelIndex where id=131946 
GO
delete from HtmlLabelInfo where indexid=131946 
GO
INSERT INTO HtmlLabelIndex values(131946,'�������п�Ŀ������˳������') 
GO
INSERT INTO HtmlLabelInfo VALUES(131946,'�������п�Ŀ������˳������',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(131946,'Update all subjects [sorting sequence] data',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(131946,'�������п�Ŀ��������򡿔���',9) 
GO

delete from HtmlLabelIndex where id=131947 
GO
delete from HtmlLabelInfo where indexid=131947 
GO
INSERT INTO HtmlLabelIndex values(131947,'��ǰ��Ŀ�Ѿ��б��ƹ�Ԥ���ȣ����ܹرա��ɱ���Ԥ�㡿ѡ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(131947,'��ǰ��Ŀ�Ѿ��б��ƹ�Ԥ���ȣ����ܹرա��ɱ���Ԥ�㡿ѡ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(131947,'The current subject has already been budgeted and cannot be closed',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(131947,'��ǰ��Ŀ�ѽ��о����^�A���~�ȣ������P�]���ɾ����A�㡿�x�',9) 
GO