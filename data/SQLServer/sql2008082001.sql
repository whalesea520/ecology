delete from HtmlLabelIndex where id=21800 
GO
delete from HtmlLabelInfo where indexid=21800 
GO
INSERT INTO HtmlLabelIndex values(21800,'落款') 
GO
INSERT INTO HtmlLabelInfo VALUES(21800,'落款',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21800,'Sender',8) 
GO
delete from HtmlLabelIndex where id=21801 
GO
delete from HtmlLabelInfo where indexid=21801 
GO
INSERT INTO HtmlLabelIndex values(21801,'落款不能为空！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21801,'落款不能为空！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21801,'Sender can not be empty !',8) 
GO