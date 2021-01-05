alter table MODE_CUSTOMBROWSER add isworkflowdata int
/
delete from HtmlLabelIndex where id=84644 
/
delete from HtmlLabelInfo where indexid=84644 
/
INSERT INTO HtmlLabelIndex values(84644,'包含流程数据') 
/
INSERT INTO HtmlLabelInfo VALUES(84644,'包含流程数据',7) 
/
INSERT INTO HtmlLabelInfo VALUES(84644,'Contain process data',8) 
/
INSERT INTO HtmlLabelInfo VALUES(84644,'包含流程數據',9) 
/