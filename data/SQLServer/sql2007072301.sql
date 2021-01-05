DELETE FROM HtmlLabelIndex WHERE id = 2047
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 2047
GO
INSERT INTO HtmlLabelIndex values(2047,'发件日期') 
GO
INSERT INTO HtmlLabelInfo VALUES(2047,'发件日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(2047,'Sending Date',8) 
GO