ALTER TABLE FnaBudgetfeeType modify groupDispalyOrder VARCHAR2(500)
/


ALTER TABLE FnaBatch4Subject modify groupDispalyOrder VARCHAR2(500)
/


delete from HtmlLabelIndex where id=131946 
/
delete from HtmlLabelInfo where indexid=131946 
/
INSERT INTO HtmlLabelIndex values(131946,'�������п�Ŀ������˳������') 
/
INSERT INTO HtmlLabelInfo VALUES(131946,'�������п�Ŀ������˳������',7) 
/
INSERT INTO HtmlLabelInfo VALUES(131946,'Update all subjects [sorting sequence] data',8) 
/
INSERT INTO HtmlLabelInfo VALUES(131946,'�������п�Ŀ��������򡿔���',9) 
/

delete from HtmlLabelIndex where id=131947 
/
delete from HtmlLabelInfo where indexid=131947 
/
INSERT INTO HtmlLabelIndex values(131947,'��ǰ��Ŀ�Ѿ��б��ƹ�Ԥ���ȣ����ܹرա��ɱ���Ԥ�㡿ѡ��') 
/
INSERT INTO HtmlLabelInfo VALUES(131947,'��ǰ��Ŀ�Ѿ��б��ƹ�Ԥ���ȣ����ܹرա��ɱ���Ԥ�㡿ѡ��',7) 
/
INSERT INTO HtmlLabelInfo VALUES(131947,'The current subject has already been budgeted and cannot be closed',8) 
/
INSERT INTO HtmlLabelInfo VALUES(131947,'��ǰ��Ŀ�ѽ��о����^�A���~�ȣ������P�]���ɾ����A�㡿�x�',9) 
/