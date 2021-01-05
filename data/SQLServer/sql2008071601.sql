delete from HtmlLabelIndex where id=21675 
GO
delete from HtmlLabelInfo where indexid=21675 
GO
INSERT INTO HtmlLabelIndex values(21675,'隐藏没有内容的区域') 
GO
delete from HtmlLabelIndex where id=21676 
GO
delete from HtmlLabelInfo where indexid=21676 
GO
INSERT INTO HtmlLabelIndex values(21676,'显示没有内容的区域') 
GO
INSERT INTO HtmlLabelInfo VALUES(21675,'隐藏没有内容的区域',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21675,'Hidden No Content Area',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21676,'显示没有内容的区域',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21676,'Show No Content Area',8) 
GO

delete from HtmlLabelIndex where id=21657 
GO
delete from HtmlLabelInfo where indexid=21657 
GO
INSERT INTO HtmlLabelIndex values(21657,'显示模式') 
GO
INSERT INTO HtmlLabelInfo VALUES(21657,'显示模式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21657,'Mode type',8) 
GO
