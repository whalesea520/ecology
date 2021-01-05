delete from HtmlLabelIndex where id=21265 
GO
delete from HtmlLabelInfo where indexid=21265 
GO
INSERT INTO HtmlLabelIndex values(21265,'是否包含历史版本') 
GO
INSERT INTO HtmlLabelInfo VALUES(21265,'是否包含历史版本',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21265,'Include Historical Version Or Not',8) 
GO