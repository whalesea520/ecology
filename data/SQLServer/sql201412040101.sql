delete from HtmlLabelIndex where id=81723 
GO
delete from HtmlLabelInfo where indexid=81723 
GO
INSERT INTO HtmlLabelIndex values(81723,'��Ŀ��Ƭ��ʾ��Ŀ') 
GO
INSERT INTO HtmlLabelInfo VALUES(81723,'��Ŀ��Ƭ��ʾ��Ŀ',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(81723,'PrjCardItem',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(81723,'�Ŀ��Ƭ�@ʾ��Ŀ',9) 
GO

delete from HtmlLabelIndex where id=81724 
GO
delete from HtmlLabelInfo where indexid=81724 
GO
INSERT INTO HtmlLabelIndex values(81724,'�ʲ���Ƭ��ʾ��Ŀ') 
GO
INSERT INTO HtmlLabelInfo VALUES(81724,'�ʲ���Ƭ��ʾ��Ŀ',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(81724,'CptCardItem',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(81724,'�Y�b��Ƭ�@ʾ��Ŀ',9) 
GO

delete from HtmlLabelInfo where indexid=81725 
GO
INSERT INTO HtmlLabelIndex values(81725,'�ʲ���Ƭ�ֶζ���') 
GO
INSERT INTO HtmlLabelInfo VALUES(81725,'�ʲ���Ƭ�ֶζ���',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(81725,'CptCardFieldDefine',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(81725,'�Y�b��Ƭ�ֶζ��x',9) 
GO


delete from HtmlLabelIndex where id=81726 
GO
delete from HtmlLabelInfo where indexid=81726 
GO
INSERT INTO HtmlLabelIndex values(81726,'�ʲ�������������') 
GO
INSERT INTO HtmlLabelInfo VALUES(81726,'�ʲ�������������',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(81726,'CptManageWorkflowCfg',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(81726,'�Y�b������������',9) 
GO


update HtmlLabelInfo set labelname='ͨ����Ŀ�ֶζ���' where indexid=33091 and languageid=7
go
update HtmlLabelInfo set labelname='ͨ���Ŀ��λ��ӆ' where indexid=33091 and languageid=9
go

update HtmlLabelInfo set labelname='��Ŀ�����ֶζ���' where indexid=18630 and languageid=7
go
update HtmlLabelInfo set labelname='�Ŀ��͙�λ��ӆ' where indexid=18630 and languageid=9
go