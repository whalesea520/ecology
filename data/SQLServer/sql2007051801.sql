DELETE FROM HtmlLabelIndex WHERE id = 20392
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20392
GO
INSERT INTO HtmlLabelIndex values(20392,'自定义会议地点') 
GO
INSERT INTO HtmlLabelInfo VALUES(20392,'自定义会议地点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20392,'Customize Meeting Address',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id = 20393
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20393
GO
INSERT INTO HtmlLabelIndex values(20393,'请选择会议地点或者自定义会议地点！') 
GO
INSERT INTO HtmlLabelInfo VALUES(20393,'请选择会议地点或者自定义会议地点！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20393,'It is necessary to input the meeting address or customize meeting address!',8) 
GO

