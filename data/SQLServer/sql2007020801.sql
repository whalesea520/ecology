DELETE FROM HtmlLabelIndex WHERE id = 20238
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20238
GO
INSERT INTO HtmlLabelIndex values(20238,'日程提醒时间未被选定！') 
GO
INSERT INTO HtmlLabelInfo VALUES(20238,'日程提醒时间未被选定！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20238,'Remind time of workplan is not been selected!',8) 
GO