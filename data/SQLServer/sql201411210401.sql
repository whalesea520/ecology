delete from HtmlLabelIndex where id=17748 
GO
delete from HtmlLabelInfo where indexid=17748 
GO
INSERT INTO HtmlLabelIndex values(17748,'自定义组') 
GO
INSERT INTO HtmlLabelInfo VALUES(17748,'自定义组',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17748,'group',8) 
GO