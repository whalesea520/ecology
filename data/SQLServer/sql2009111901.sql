delete from HtmlLabelIndex where id=23852 
GO
delete from HtmlLabelInfo where indexid=23852 
GO
INSERT INTO HtmlLabelIndex values(23852,'强制') 
GO
INSERT INTO HtmlLabelInfo VALUES(23852,'强制',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23852,'needed',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23852,'强制',9) 
GO

delete from HtmlLabelIndex where id=23853 
GO
delete from HtmlLabelInfo where indexid=23853 
GO
INSERT INTO HtmlLabelIndex values(23853,'非强制') 
GO
INSERT INTO HtmlLabelInfo VALUES(23853,'非强制',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23853,'not needed',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23853,'非强制',9) 
GO
