delete HtmlLabelIndex where id=20822
GO
delete HtmlLabelInfo where indexid=20822
GO
INSERT INTO HtmlLabelIndex values(20822,'此模板必须先保存然后才能预览！') 
GO
INSERT INTO HtmlLabelInfo VALUES(20822,'此模板必须先保存然后才能预览！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20822,'Preview Need Save This Before',8) 
GO