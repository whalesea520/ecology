delete from HtmlLabelIndex where id=24024 
GO
delete from HtmlLabelInfo where indexid=24024 
GO
INSERT INTO HtmlLabelIndex values(24024,'Office文档最大') 
GO
delete from HtmlLabelIndex where id=24025 
GO
delete from HtmlLabelInfo where indexid=24025 
GO
INSERT INTO HtmlLabelIndex values(24025,'建议不要大于8M') 
GO
INSERT INTO HtmlLabelInfo VALUES(24024,'Office文档最大',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24024,'Max of office document',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24024,'Office文檔最大',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(24025,'建议不要大于8M',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24025,'We do not recommend more than 8M',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24025,'建議不要大於8M',9) 
GO