delete from HtmlLabelIndex where id=81869 
/
delete from HtmlLabelInfo where indexid=81869 
/
INSERT INTO HtmlLabelIndex values(81869,'�Ѿ���ʹ��') 
/
INSERT INTO HtmlLabelInfo VALUES(81869,'�Ѿ���ʹ��',7) 
/
INSERT INTO HtmlLabelInfo VALUES(81869,'has been used',8) 
/
INSERT INTO HtmlLabelInfo VALUES(81869,'�ѽ���ʹ��',9) 
/

delete from HtmlLabelIndex where id=127156 
/
delete from HtmlLabelInfo where indexid=127156 
/
INSERT INTO HtmlLabelIndex values(127156,'�칹ϵͳע��') 
/
delete from HtmlLabelIndex where id=127157 
/
delete from HtmlLabelInfo where indexid=127157 
/
INSERT INTO HtmlLabelIndex values(127157,'��������ע��') 
/
INSERT INTO HtmlLabelInfo VALUES(127157,'��������ע��',7) 
/
INSERT INTO HtmlLabelInfo VALUES(127157,'Flow type registration',8) 
/
INSERT INTO HtmlLabelInfo VALUES(127157,'�������ע��',9) 
/
INSERT INTO HtmlLabelInfo VALUES(127156,'�칹ϵͳע��',7) 
/
INSERT INTO HtmlLabelInfo VALUES(127156,'Heterogeneous system registration',8) 
/
INSERT INTO HtmlLabelInfo VALUES(127156,'����ϵ�yע��',9) 
/

delete from SystemLogItem where itemid='164'
/
insert into SystemLogItem(itemid,lableid,itemdesc,typeid) values('164','127156','�칹ϵͳע��','0')
/

delete from SystemLogItem where itemid='165'
/
insert into SystemLogItem(itemid,lableid,itemdesc,typeid) values('165','127157','��������ע��','0')
/