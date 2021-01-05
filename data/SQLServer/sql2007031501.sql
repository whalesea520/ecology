
delete from HtmlLabelIndex where id=20237
GO
delete from HtmlLabelInfo where indexid=20237
GO
INSERT INTO HtmlLabelIndex values(20237,'自定义列表') 
GO
INSERT INTO HtmlLabelInfo VALUES(20237,'自定义列表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20237,'Custom Field',8) 
GO

