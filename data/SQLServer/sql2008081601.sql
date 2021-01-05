delete from HtmlLabelIndex where id=21762 
GO
delete from HtmlLabelInfo where indexid=21762 
GO
INSERT INTO HtmlLabelIndex values(21762,'不需反馈') 
GO
INSERT INTO HtmlLabelInfo VALUES(21762,'不需反馈',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21762,'Needn''t workflow back',8) 
GO

delete from HtmlLabelIndex where id=21761 
GO
delete from HtmlLabelInfo where indexid=21761 
GO
INSERT INTO HtmlLabelIndex values(21761,'需反馈') 
GO
INSERT INTO HtmlLabelInfo VALUES(21761,'需反馈',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21761,'Need workflow back',8) 
GO

