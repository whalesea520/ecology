delete from HtmlLabelIndex where id=30480 
/
delete from HtmlLabelInfo where indexid=30480 
/
INSERT INTO HtmlLabelIndex values(30480,'��Ŀ��������') 
/
INSERT INTO HtmlLabelInfo VALUES(30480,'��Ŀ��������',7) 
/
INSERT INTO HtmlLabelInfo VALUES(30480,'The subjects their respective departments',8) 
/
INSERT INTO HtmlLabelInfo VALUES(30480,'��Ŀ���ٲ��T',9) 
/

delete from HtmlLabelIndex where id=32389 
/
delete from HtmlLabelInfo where indexid=32389 
/
INSERT INTO HtmlLabelIndex values(32389,'�Ƿ����ⲿ��') 
/
INSERT INTO HtmlLabelInfo VALUES(32389,'�Ƿ����ⲿ��',7) 
/
INSERT INTO HtmlLabelInfo VALUES(32389,'Is Virtual',8) 
/
INSERT INTO HtmlLabelInfo VALUES(32389,'�Ƿ�̓�ⲿ�T',9) 
/
alter table FnaExpenseInfo add shareRequestId VARCHAR(200)
/