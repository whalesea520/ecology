alter table mode_dmlactionset add isResetRight int 
GO
alter table mode_dmlactionset add targetModeid int 
GO
delete from HtmlLabelIndex where id=125371 
GO
delete from HtmlLabelInfo where indexid=125371 
GO
INSERT INTO HtmlLabelIndex values(125371,'��������ⲿ����Դ�������������Ϊ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(125371,'��������ⲿ����Դ�������������Ϊ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125371,'If it is not external data sources, it is recommended that this setting is empty',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125371,'��������ⲿ����Դ�����h����O�à���',9) 
GO
delete from HtmlLabelIndex where id=125368 
GO
delete from HtmlLabelInfo where indexid=125368 
GO
INSERT INTO HtmlLabelIndex values(125368,'�Ƿ��ع�����Ȩ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(125368,'�Ƿ��ع�����Ȩ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125368,'reconstructing data permissions',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125368,'�Ƿ��ؘ���������',9) 
GO
delete from HtmlLabelIndex where id=125369 
GO
delete from HtmlLabelInfo where indexid=125369 
GO
INSERT INTO HtmlLabelIndex values(125369,'��������Ŀ��ģ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(125369,'��������Ŀ��ģ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125369,'insert data to the target module',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125369,'���딵��Ŀ��ģ�K',9) 
GO
delete from HtmlLabelIndex where id=125370 
GO
delete from HtmlLabelInfo where indexid=125370 
GO
INSERT INTO HtmlLabelIndex values(125370,'insert����ʱ�����Ҫ���������Ϊģ�����ݣ�����Ҫ���ô���') 
GO
INSERT INTO HtmlLabelInfo VALUES(125370,'insert����ʱ�����Ҫ���������Ϊģ�����ݣ�����Ҫ���ô���',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125370,'Insert operations, if the data you want to insert data for the module, you need to set this',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125370,'insert�����r�����Ҫ����Ĕ�����ģ�K�������t��Ҫ�O�ô��',9) 
GO