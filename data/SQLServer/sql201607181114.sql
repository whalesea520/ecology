delete from HtmlLabelIndex where id=81869 
GO
delete from HtmlLabelInfo where indexid=81869 
GO
INSERT INTO HtmlLabelIndex values(81869,'�Ѿ���ʹ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(81869,'�Ѿ���ʹ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(81869,'has been used',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(81869,'�ѽ���ʹ��',9) 
GO

delete from HtmlLabelIndex where id=127156 
GO
delete from HtmlLabelInfo where indexid=127156 
GO
INSERT INTO HtmlLabelIndex values(127156,'�칹ϵͳע��') 
GO
delete from HtmlLabelIndex where id=127157 
GO
delete from HtmlLabelInfo where indexid=127157 
GO
INSERT INTO HtmlLabelIndex values(127157,'��������ע��') 
GO
INSERT INTO HtmlLabelInfo VALUES(127157,'��������ע��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127157,'Flow type registration',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127157,'�������ע��',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(127156,'�칹ϵͳע��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127156,'Heterogeneous system registration',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127156,'����ϵ�yע��',9) 
GO


delete from SystemLogItem where itemid='164'
GO
insert into SystemLogItem(itemid,lableid,itemdesc,typeid) values('164','127156','�칹ϵͳע��','0')
GO

delete from SystemLogItem where itemid='165'
GO
insert into SystemLogItem(itemid,lableid,itemdesc,typeid) values('165','127157','��������ע��','0')
GO