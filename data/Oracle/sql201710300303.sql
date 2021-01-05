ALTER TABLE FnaBudgetfeeType modify groupDispalyOrder VARCHAR2(500)
/


ALTER TABLE FnaBatch4Subject modify groupDispalyOrder VARCHAR2(500)
/


delete from HtmlLabelIndex where id=131946 
/
delete from HtmlLabelInfo where indexid=131946 
/
INSERT INTO HtmlLabelIndex values(131946,'更新所有科目【排序顺序】数据') 
/
INSERT INTO HtmlLabelInfo VALUES(131946,'更新所有科目【排序顺序】数据',7) 
/
INSERT INTO HtmlLabelInfo VALUES(131946,'Update all subjects [sorting sequence] data',8) 
/
INSERT INTO HtmlLabelInfo VALUES(131946,'更新所有科目【排序順序】數據',9) 
/

delete from HtmlLabelIndex where id=131947 
/
delete from HtmlLabelInfo where indexid=131947 
/
INSERT INTO HtmlLabelIndex values(131947,'当前科目已经有编制过预算额度，不能关闭【可编制预算】选项') 
/
INSERT INTO HtmlLabelInfo VALUES(131947,'当前科目已经有编制过预算额度，不能关闭【可编制预算】选项',7) 
/
INSERT INTO HtmlLabelInfo VALUES(131947,'The current subject has already been budgeted and cannot be closed',8) 
/
INSERT INTO HtmlLabelInfo VALUES(131947,'當前科目已經有編制過預算額度，不能關閉【可編制預算】選項',9) 
/