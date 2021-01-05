delete from HtmlLabelIndex where id=126436 
GO
delete from HtmlLabelInfo where indexid=126436 
GO
INSERT INTO HtmlLabelIndex values(126436,'¿ì½ÝËÑË÷') 
GO
INSERT INTO HtmlLabelInfo VALUES(126436,'¿ì½ÝËÑË÷',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126436,'quick search',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126436,'¿ì½ÝËÑË÷',9) 
GO
alter table mode_customtree add isQuickSearch int
GO

