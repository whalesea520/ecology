delete from HtmlLabelIndex where id=125539 
GO
delete from HtmlLabelInfo where indexid=125539 
GO
INSERT INTO HtmlLabelIndex values(125539,'���ת������Ϊ�Զ���sql�������ò�ѯ���ǵ�ǰϵͳ����ʽΪ��select �����ֶ� from tablename where �����ֶ�={?currentvalue}��{?currentvalue}Ϊ�̶���ʽ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(125539,'���ת������Ϊ�Զ���sql�������ò�ѯ���ǵ�ǰϵͳ����ʽΪ��select �����ֶ� from tablename where �����ֶ�={?currentvalue}��{?currentvalue}Ϊ�̶���ʽ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125539,'If the conversion rules for the custom SQL, this query is the current system, in the format: select fields from tablename where field={?currentvalue}, {?currentvalue} is a fixed format.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125539,'����D�QҎ�t���Զ��xsql�����O�ò�ԃ���Ǯ�ǰϵ�y����ʽ����select ��K�ֶ� from tablename where �l���ֶ�={?currentvalue}��{?currentvalue}���̶���ʽ��',9) 
GO

delete from HtmlLabelIndex where id=125540 
GO
delete from HtmlLabelInfo where indexid=125540 
GO
INSERT INTO HtmlLabelIndex values(125540,'�������ϸ����') 
GO
INSERT INTO HtmlLabelInfo VALUES(125540,'�������ϸ����',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125540,'Save after detailed settings',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125540,'������Ԕ���O��',9) 
GO

delete from HtmlLabelIndex where id=125608 
GO
delete from HtmlLabelInfo where indexid=125608 
GO
INSERT INTO HtmlLabelIndex values(125608,'����������/�ڵ�') 
GO
INSERT INTO HtmlLabelInfo VALUES(125608,'����������/�ڵ�',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125608,'Referenced process/node',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125608,'����������/���c',9) 
GO