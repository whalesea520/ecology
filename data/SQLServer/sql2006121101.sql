DELETE FROM HtmlLabelIndex WHERE id=19990
GO
DELETE FROM HtmlLabelInfo WHERE indexid=19990
GO
DELETE FROM HtmlLabelIndex WHERE id=19991
GO
DELETE FROM HtmlLabelInfo WHERE indexid=19991
GO
DELETE FROM HtmlLabelIndex WHERE id=19992
GO
DELETE FROM HtmlLabelInfo WHERE indexid=19992
GO
INSERT INTO HtmlLabelIndex values(19990,'确认是否提交?') 
GO
INSERT INTO HtmlLabelIndex values(19992,'确认是否转发?') 
GO
INSERT INTO HtmlLabelIndex values(19991,'确认是否退回?') 
GO
INSERT INTO HtmlLabelInfo VALUES(19990,'确认是否提交?',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19990,'sure to submit?',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19991,'确认是否退回?',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19991,'sure to back?',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19992,'确认是否转发?',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19992,'sure to transmit?',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id=19998
GO
DELETE FROM HtmlLabelInfo WHERE indexid=19998
GO
DELETE FROM HtmlLabelIndex WHERE id=20011
GO
DELETE FROM HtmlLabelInfo WHERE indexid=20011
GO
DELETE FROM HtmlLabelIndex WHERE id=20012
GO
DELETE FROM HtmlLabelInfo WHERE indexid=20012
GO
INSERT INTO HtmlLabelIndex values(19998,'附件大小') 
GO
INSERT INTO HtmlLabelInfo VALUES(19998,'附件大小',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19998,'size of accessory',8) 
GO
INSERT INTO HtmlLabelIndex values(20011,'附件合计大小') 
GO
INSERT INTO HtmlLabelIndex values(20012,'附件单个大小') 
GO
INSERT INTO HtmlLabelInfo VALUES(20011,'附件合计大小',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20011,'size of all accessory',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20012,'附件单个大小',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20012,'size of single accessory',8) 
GO
