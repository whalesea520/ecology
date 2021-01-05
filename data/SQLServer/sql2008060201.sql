delete from HtmlLabelIndex where id=21472 
GO
delete from HtmlLabelInfo where indexid=21472 
GO
INSERT INTO HtmlLabelIndex values(21472,'标题必须选择') 
GO
INSERT INTO HtmlLabelInfo VALUES(21472,'标题必须选择!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21472,'Title is needed!',8) 
GO
