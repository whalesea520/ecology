delete from HtmlLabelIndex where id=127327 
GO
delete from HtmlLabelInfo where indexid=127327 
GO
INSERT INTO HtmlLabelIndex values(127327,'ת����ת�졢�����ѯ������������') 
GO
INSERT INTO HtmlLabelInfo VALUES(127327,'ת����ת�졢�����ѯ������������',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127327,'forwarding, comments and advice to remind the setting',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127327,'�D�l���D�k����Ҋ��ԃ���������O��',9) 
GO
alter table workflow_base add sendtomessagetype char(1)
GO