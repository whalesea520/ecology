delete from HtmlLabelIndex where id=3648 
GO
delete from HtmlLabelInfo where indexid=3648 
GO
INSERT INTO HtmlLabelIndex values(3648,'�Զ�����ʱ������')
GO
INSERT INTO HtmlLabelInfo VALUES(3648,'�Զ�����ʱ������',7)
GO
INSERT INTO HtmlLabelInfo VALUES(3648,'AutoOffLine Time Settings',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(3648,'�Ԅ��¾��r�L�O��',9) 
GO

delete from HtmlLabelIndex where id=3649
GO
delete from HtmlLabelInfo where indexid=3649 
GO
INSERT INTO HtmlLabelIndex values(3649,'�����Զ�����')
GO
INSERT INTO HtmlLabelInfo VALUES(3649,'�����Զ�����',7)
GO
INSERT INTO HtmlLabelInfo VALUES(3649,'Enabled AutoOffLine Time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(3649,'�����Ԅ��¾�',9) 
GO

delete from HtmlLabelIndex where id=3650
GO
delete from HtmlLabelInfo where indexid=3650 
GO
INSERT INTO HtmlLabelIndex values(3650,'��������ʱ��')
GO
INSERT INTO HtmlLabelInfo VALUES(3650,'��������ʱ��',7)
GO
INSERT INTO HtmlLabelInfo VALUES(3650,'Allow AutoOffLine Time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(3650,'���S�ھ��r�L',9) 
GO

delete from HtmlLabelIndex where id=3651
GO
delete from HtmlLabelInfo where indexid=3651 
GO
INSERT INTO HtmlLabelIndex values(3651,'���ѿ����ʱ��')
GO
INSERT INTO HtmlLabelInfo VALUES(3651,'���ѿ����ʱ��',7)
GO
INSERT INTO HtmlLabelInfo VALUES(3651,'Allow AutoOffLine Time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(3651,'���ѿ���F�r�g',9) 
GO

delete from ErrorMsgIndex where id=175
GO
delete from ErrorMsgInfo where indexid=175
GO
insert into ErrorMsgIndex values (175,'���ѱ�����Աǿ�����ߣ�')
GO
insert into ErrorMsgInfo values (175,'���ѱ�����Աǿ�����ߣ�',7)
GO
insert into ErrorMsgInfo values (175,'You have been forced to logoff administrator!',8)
GO 
insert into ErrorMsgInfo values(175,'���ѱ�����T�����¾���',9)
GO