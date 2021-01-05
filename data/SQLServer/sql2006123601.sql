DELETE FROM HtmlLabelIndex WHERE id = 20114
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20114
GO
INSERT INTO HtmlLabelIndex values(20114,'已取消') 
GO
INSERT INTO HtmlLabelInfo VALUES(20114,'已取消',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20114,'Have Been Canceled',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id = 20115
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20115
GO
INSERT INTO HtmlLabelIndex values(20115,'取消会议') 
GO
INSERT INTO HtmlLabelInfo VALUES(20115,'取消会议',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20115,'Cancel Meeting',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id = 20117
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20117
GO
INSERT INTO HtmlLabelIndex values(20117,'你确定要取消会议吗？') 
GO
INSERT INTO HtmlLabelInfo VALUES(20117,'你确定要取消会议吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20117,'Are you sure to cancel the meeting?',8) 
GO