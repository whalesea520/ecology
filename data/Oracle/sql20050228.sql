INSERT INTO HtmlLabelIndex values(17598,'批量提交') 
/
INSERT INTO HtmlLabelInfo VALUES(17598,'批量提交',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17598,'Multi Submit',8) 
/
INSERT INTO HtmlLabelIndex values(17601,'是否批量提交') 
/
INSERT INTO HtmlLabelInfo VALUES(17601,'是否批量提交',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17601,'is Multi Submit',8) 
/

/*修改workflow_base表结构，记录是否能够批量提交*/
ALTER TABLE workflow_base ADD multiSubmit integer null
/