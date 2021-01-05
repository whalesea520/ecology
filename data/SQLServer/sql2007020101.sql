DELETE FROM HtmlLabelIndex WHERE id = 20215
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20215
GO
INSERT INTO HtmlLabelIndex values(20215,'日程提醒') 
GO
INSERT INTO HtmlLabelInfo VALUES(20215,'日程提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20215,'Work Plan Remind',8) 
GO