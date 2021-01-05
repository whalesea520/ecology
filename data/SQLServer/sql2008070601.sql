delete HtmlLabelIndex where id=20098
GO
delete HtmlLabelInfo where indexid=20098
GO
INSERT INTO HtmlLabelIndex values(20098,'工作人员') 
GO
INSERT INTO HtmlLabelInfo VALUES(20098,'工作人员',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20098,'employee',8) 
GO
