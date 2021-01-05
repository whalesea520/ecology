delete from HtmlLabelIndex where id=127327 
GO
delete from HtmlLabelInfo where indexid=127327 
GO
INSERT INTO HtmlLabelIndex values(127327,'转发、转办、意见征询短信提醒设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(127327,'转发、转办、意见征询短信提醒设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127327,'forwarding, comments and advice to remind the setting',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127327,'轉發、轉辦、意見征詢短信提醒設置',9) 
GO
alter table workflow_base add sendtomessagetype char(1)
GO