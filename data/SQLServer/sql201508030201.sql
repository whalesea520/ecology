alter table MailResource add flag int
GO
delete from HtmlLabelIndex where id=125055 
GO
delete from HtmlLabelInfo where indexid=125055 
GO
INSERT INTO HtmlLabelIndex values(125055,'��ת��') 
GO
INSERT INTO HtmlLabelInfo VALUES(125055,'��ת��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125055,'forwarded',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125055,'���D�l',9) 
GO
delete from HtmlLabelIndex where id=125056 
GO
delete from HtmlLabelInfo where indexid=125056 
GO
INSERT INTO HtmlLabelIndex values(125056,'�ѻظ�') 
GO
INSERT INTO HtmlLabelInfo VALUES(125056,'�ѻظ�',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125056,'replied',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125056,'�ѻ��}',9) 
GO
delete from HtmlLabelIndex where id=125057 
GO
delete from HtmlLabelInfo where indexid=125057 
GO
INSERT INTO HtmlLabelIndex values(125057,'��ת�����ѻظ�') 
GO
INSERT INTO HtmlLabelInfo VALUES(125057,'��ת�����ѻظ�',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125057,'Have forwarded and reply',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125057,'���D�l���ѻ��}',9) 
GO
delete from HtmlLabelIndex where id=24714 
GO
delete from HtmlLabelInfo where indexid=24714 
GO
INSERT INTO HtmlLabelIndex values(24714,'�ڲ��ʼ�') 
GO
INSERT INTO HtmlLabelInfo VALUES(24714,'�ڲ��ʼ�',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24714,'Inner Email',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24714,'�Ȳ��]��',9) 
GO