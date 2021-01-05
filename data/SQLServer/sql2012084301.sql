delete from HtmlLabelIndex where id=28664 
GO
delete from HtmlLabelInfo where indexid=28664 
GO
INSERT INTO HtmlLabelIndex values(28664,'此布局已被引用, 不能被删除!') 
GO
INSERT INTO HtmlLabelInfo VALUES(28664,'此布局已被引用, 不能被删除!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(28664,'This layout is using,can''''t remove!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(28664,'此布局已被引用, 不能被刪除!',9) 
GO