delete from HtmlLabelIndex where id=129666 
GO
delete from HtmlLabelInfo where indexid=129666 
GO
INSERT INTO HtmlLabelIndex values(129666,'��ѯ�����Ƿ�չ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(129666,'��ѯ�����Ƿ�չ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(129666,'Whether the query conditions',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(129666,'��ԃ�l���Ƿ�չ�_',9) 
GO
alter table mode_customsearch add isShowQueryCondition int
GO