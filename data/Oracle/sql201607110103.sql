alter table fnaFeeWfInfoField add isWfFieldLinkage integer
/

update fnaFeeWfInfoField set isWfFieldLinkage = 0
/

delete from HtmlLabelIndex where id=127850 
/
delete from HtmlLabelInfo where indexid=127850 
/
INSERT INTO HtmlLabelIndex values(127850,'字段联动实现') 
/
INSERT INTO HtmlLabelInfo VALUES(127850,'字段联动实现',7) 
/
INSERT INTO HtmlLabelInfo VALUES(127850,'Field linkage implementation',8) 
/
INSERT INTO HtmlLabelInfo VALUES(127850,'字段聯動實現',9) 
/
