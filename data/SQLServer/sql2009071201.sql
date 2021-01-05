delete from HtmlLabelIndex where id=23509 
GO
delete from HtmlLabelInfo where indexid=23509 
GO
INSERT INTO HtmlLabelIndex values(23509,'是否在流转日志中显示') 
GO
INSERT INTO HtmlLabelInfo VALUES(23509,'是否在流转日志中显示',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23509,'whether show in the log of workflow',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23509,'是否在流轉日誌中顯示',9) 
GO