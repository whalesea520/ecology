delete from HtmlLabelIndex where id=21707 
GO
delete from HtmlLabelInfo where indexid=21707 
GO
INSERT INTO HtmlLabelIndex values(21707,'该文档没有附件，不能查看') 
GO
INSERT INTO HtmlLabelInfo VALUES(21707,'该文档没有附件，不能查看',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21707,'This document has no accessory',8) 
GO
delete from HtmlLabelIndex where id=21710 
GO
delete from HtmlLabelInfo where indexid=21710 
GO
INSERT INTO HtmlLabelIndex values(21710,'附件已与正文相关联，请在正文中查看附件！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21710,'附件已与正文相关联，请在正文中查看附件！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21710,'look over the accessory at the text',8) 
GO
