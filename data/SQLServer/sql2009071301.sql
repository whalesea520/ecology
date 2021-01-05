delete from HtmlLabelIndex where id=17583 
GO
delete from HtmlLabelInfo where indexid=17583 
GO
INSERT INTO HtmlLabelIndex values(17583,'不发送AM提醒') 
GO
INSERT INTO HtmlLabelInfo VALUES(17583,'不发送AM提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17583,'no message remind',8) 
GO