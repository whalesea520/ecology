delete from HtmlLabelIndex where id=21004 
GO
delete from HtmlLabelInfo where indexid=21004 
GO
INSERT INTO HtmlLabelIndex values(21004,'是否自动刷屏') 
GO
INSERT INTO HtmlLabelInfo VALUES(21004,'是否自动刷屏',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21004,'isAutoRefresh',8) 
GO

delete from HtmlLabelIndex where id=21005 
GO
delete from HtmlLabelInfo where indexid=21005 
GO
INSERT INTO HtmlLabelIndex values(21005,'自动刷屏间隔时间(分钟)') 
GO
INSERT INTO HtmlLabelInfo VALUES(21005,'自动刷屏间隔时间(分钟)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21005,'MinsOfRefresh',8) 
GO