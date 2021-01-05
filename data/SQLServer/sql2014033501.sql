delete from HtmlLabelIndex where id=32834 
GO
delete from HtmlLabelInfo where indexid=32834 
GO
INSERT INTO HtmlLabelIndex values(32834,'原直接上级') 
GO
INSERT INTO HtmlLabelInfo VALUES(32834,'原直接上级',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32834,'Original manager',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32834,'原直接上級',9) 
GO

delete from HtmlLabelIndex where id=32835 
GO
delete from HtmlLabelInfo where indexid=32835 
GO
INSERT INTO HtmlLabelIndex values(32835,'现直接上级') 
GO
INSERT INTO HtmlLabelInfo VALUES(32835,'现直接上级',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32835,'Now manager',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32835,'現直接上級',9) 
GO
