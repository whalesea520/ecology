alter table fnaFeeWfInfoField add isWfFieldLinkage integer
/

update fnaFeeWfInfoField set isWfFieldLinkage = 0
/

delete from HtmlLabelIndex where id=127850 
/
delete from HtmlLabelInfo where indexid=127850 
/
INSERT INTO HtmlLabelIndex values(127850,'�ֶ�����ʵ��') 
/
INSERT INTO HtmlLabelInfo VALUES(127850,'�ֶ�����ʵ��',7) 
/
INSERT INTO HtmlLabelInfo VALUES(127850,'Field linkage implementation',8) 
/
INSERT INTO HtmlLabelInfo VALUES(127850,'�ֶ��ӌ��F',9) 
/