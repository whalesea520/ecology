DELETE FROM HtmlLabelIndex WHERE id=19990
GO
DELETE FROM HtmlLabelInfo WHERE indexid=19990
GO
INSERT INTO HtmlLabelIndex values(19990,'确认是否提交？') 
GO
INSERT INTO HtmlLabelInfo VALUES(19990,'确认是否提交？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19990,'sure to submit？',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id=19991
GO
DELETE FROM HtmlLabelInfo WHERE indexid=19991
GO
INSERT INTO HtmlLabelIndex values(19991,'确认是否退回？') 
GO
INSERT INTO HtmlLabelInfo VALUES(19991,'确认是否退回？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19991,'sure to back？',8) 
GO


DELETE FROM HtmlLabelIndex WHERE id=19992
GO
DELETE FROM HtmlLabelInfo WHERE indexid=19992
GO
INSERT INTO HtmlLabelIndex values(19992,'确认是否转发？') 
GO
INSERT INTO HtmlLabelInfo VALUES(19992,'确认是否转发？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19992,'sure to transmit？',8) 
GO
