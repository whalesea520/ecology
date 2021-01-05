delete from HtmlLabelIndex where id=22213 
GO
delete from HtmlLabelInfo where indexid=22213 
GO
INSERT INTO HtmlLabelIndex values(22213,'计划任务删除失败，请返回重试') 
GO
INSERT INTO HtmlLabelInfo VALUES(22213,'计划任务删除失败，请返回重试',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22213,'Worktask delete error, please try again',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22213,'',9) 
GO
