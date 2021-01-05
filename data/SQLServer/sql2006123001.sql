DELETE FROM HtmlLabelIndex WHERE id = 20113
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20113
GO
INSERT INTO HtmlLabelIndex values(20113,'多个会议') 
GO
INSERT INTO HtmlLabelInfo VALUES(20113,'多个会议',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20113,'Multi-meeting',8) 
GO