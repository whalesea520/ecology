DELETE FROM HtmlLabelIndex WHERE id = 20404
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20404
GO
INSERT INTO HtmlLabelIndex values(20404,'对于被转移人和转移人均被流转过的流程，将不会被转移！') 
GO
INSERT INTO HtmlLabelInfo VALUES(20404,'对于被转移人和转移人均被流转过的流程，将不会被转移！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20404,'The workflow which contains both transfered people and transfer people can not be transfered!',8) 
GO
