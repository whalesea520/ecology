DELETE FROM HtmlLabelIndex WHERE id = 20098
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20098
GO
INSERT INTO HtmlLabelIndex values(20098,'工作人员') 
GO
INSERT INTO HtmlLabelInfo VALUES(20098,'工作人员',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20098,'employee',8) 
GO