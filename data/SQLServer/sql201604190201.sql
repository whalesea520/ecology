
delete from HtmlLabelIndex where id=81501
GO
delete from HtmlLabelIndex where id=81502
GO
delete from HtmlLabelIndex where id=81503
GO
delete from HtmlLabelIndex where id=81504
GO
delete from HtmlLabelIndex where id=81505
GO
delete from HtmlLabelIndex where id=81506
GO

delete from HtmlLabelInfo where indexid=81501
GO
delete from HtmlLabelInfo where indexid=81502
GO
delete from HtmlLabelInfo where indexid=81503
GO
delete from HtmlLabelInfo where indexid=81504
GO
delete from HtmlLabelInfo where indexid=81505
GO
delete from HtmlLabelInfo where indexid=81506
GO

INSERT INTO HtmlLabelIndex values(81501,'���ڵ㲿��������Ҫ�ȱ�������ͼ���ܽ����޸�')
GO
INSERT INTO HtmlLabelIndex values(81502,'��Ҫ�ȱ�������ͼ���ܶ������ڵ�ͳ��ڽ�����ϸ��������')
GO
INSERT INTO HtmlLabelIndex values(81503,'ֻ����һ�������ڵ㣡')
GO
INSERT INTO HtmlLabelIndex values(81504,'�ڵ����Ʋ�����ͬ��')
GO
INSERT INTO HtmlLabelIndex values(81505,'�������Ʋ���Ϊ��')
GO
INSERT INTO HtmlLabelIndex values(81506,'�ڵ����Ʋ���Ϊ��')
GO

INSERT INTO HtmlLabelInfo values(81501,'���ڵ㲿��������Ҫ�ȱ�������ͼ���ܽ����޸�',7)
GO
INSERT INTO HtmlLabelInfo values(81501,'Some attributes of the node could be modified only after the flow chart is saved.',8)
GO
INSERT INTO HtmlLabelInfo values(81501,'�����c���֌�����Ҫ�ȱ������̈D�����M���޸�',9)
GO
INSERT INTO HtmlLabelInfo values(81502,'��Ҫ�ȱ�������ͼ���ܶ������ڵ�ͳ��ڽ�����ϸ��������',7)
GO
INSERT INTO HtmlLabelInfo values(81502,'It is needed to?save the?flow chart?before?detailed?property settings for new?nodes and?outlets.',8)
GO
INSERT INTO HtmlLabelInfo values(81502,'��Ҫ�ȱ������̈D���܌��������c�ͳ����M��Ԕ�������O��',9)
GO
INSERT INTO HtmlLabelInfo values(81503,'ֻ����һ�������ڵ㣡',7)
GO
INSERT INTO HtmlLabelInfo values(81503,'There can be only one?node creation!',8)
GO
INSERT INTO HtmlLabelInfo values(81503,'ֻ����һ���������c��',9)
GO
INSERT INTO HtmlLabelInfo values(81504,'�ڵ����Ʋ�����ͬ��',7)
GO
INSERT INTO HtmlLabelInfo values(81504,'Node names must not be same!',8)
GO
INSERT INTO HtmlLabelInfo values(81504,'���c���Q������ͬ��',9)
GO
INSERT INTO HtmlLabelInfo values(81505,'�������Ʋ���Ϊ��',7)
GO
INSERT INTO HtmlLabelInfo values(81505,'Outlets''?name cannot be empty.',8)
GO
INSERT INTO HtmlLabelInfo values(81505,'�������Q���ܞ��',9)
GO
INSERT INTO HtmlLabelInfo values(81506,'�ڵ����Ʋ���Ϊ��',7)
GO
INSERT INTO HtmlLabelInfo values(81506,'Node?name cannot be empty',8)
GO
INSERT INTO HtmlLabelInfo values(81506,'���c���Q���ܞ��',9)
GO

