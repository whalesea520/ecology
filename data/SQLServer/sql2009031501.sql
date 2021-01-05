delete from HtmlLabelIndex where id=22432 
GO
delete from HtmlLabelInfo where indexid=22432 
GO
INSERT INTO HtmlLabelIndex values(22432,'顶部') 
GO
delete from HtmlLabelIndex where id=22433 
GO
delete from HtmlLabelInfo where indexid=22433 
GO
INSERT INTO HtmlLabelIndex values(22433,'底部') 
GO
INSERT INTO HtmlLabelInfo VALUES(22432,'顶部',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22432,'Top',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22432,'頂部',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22433,'底部',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22433,'Bottom',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22433,'底部',9) 
GO
