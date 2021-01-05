delete from HtmlLabelIndex where id=128284 
/
delete from HtmlLabelInfo where indexid=128284 
/
INSERT INTO HtmlLabelIndex values(128284,'结转超额费用') 
/
INSERT INTO HtmlLabelInfo VALUES(128284,'结转超额费用',7) 
/
INSERT INTO HtmlLabelInfo VALUES(128284,'Carry over cost',8) 
/
INSERT INTO HtmlLabelInfo VALUES(128284,'結轉超額費用',9) 
/


alter table FnaSystemSet add autoMoveMinusAmt INTEGER
/
