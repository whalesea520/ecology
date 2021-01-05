delete from HtmlLabelIndex where id=21410 
GO
delete from HtmlLabelInfo where indexid=21410 
GO
INSERT INTO HtmlLabelIndex values(21410,'是否启用RTX流程到达提醒') 
GO
delete from HtmlLabelIndex where id=21411 
GO
delete from HtmlLabelInfo where indexid=21411 
GO
INSERT INTO HtmlLabelIndex values(21411,'使用邮件功能时是否自动关闭系统左菜单') 
GO
INSERT INTO HtmlLabelInfo VALUES(21410,'是否启用RTX流程到达提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21410,'Is use RTX alert',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21411,'使用邮件功能时是否自动关闭系统左菜单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21411,'Auto close left menu when open mail',8) 
GO