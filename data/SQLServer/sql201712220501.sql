delete from HtmlLabelIndex where id=132261 
GO
delete from HtmlLabelInfo where indexid=132261 
GO
INSERT INTO HtmlLabelIndex values(132261,'第{0}个Sheet第{1}行为空白行，导入终止') 
GO
INSERT INTO HtmlLabelInfo VALUES(132261,'第{0}个Sheet第{1}行为空白行，导入终止',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132261,'{0} Sheet {1} behavior blank line, import termination',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132261,'第{0}個Sheet第{1}行為空白行，導入終止',9) 
GO