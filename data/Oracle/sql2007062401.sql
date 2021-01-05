delete from HtmlLabelIndex where id in (20520,20521)
/
delete from HtmlLabelInfo where indexid in (20520,20521)
/


INSERT INTO HtmlLabelIndex values(20520,'导入任务') 
/
INSERT INTO HtmlLabelIndex values(20521,'导出任务') 
/
INSERT INTO HtmlLabelInfo VALUES(20520,'导入任务',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20520,'Import Tasks',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20521,'导出任务',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20521,'Export Tasks',8) 
/


