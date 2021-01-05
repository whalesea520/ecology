delete from HtmlLabelIndex where id=22984 
GO
delete from HtmlLabelInfo where indexid=22984 
GO
INSERT INTO HtmlLabelIndex values(22984,'是否确定取消套红？') 
GO
delete from HtmlLabelIndex where id=22983 
GO
delete from HtmlLabelInfo where indexid=22983 
GO
INSERT INTO HtmlLabelIndex values(22983,'套红取消') 
GO
delete from HtmlLabelIndex where id=22985 
GO
delete from HtmlLabelInfo where indexid=22985 
GO
INSERT INTO HtmlLabelIndex values(22985,'请先取消套红！') 
GO
INSERT INTO HtmlLabelInfo VALUES(22983,'套红取消',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22983,'Use Templet Cancel',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22983,'套紅取消',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22984,'是否确定取消套红？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22984,'Whether or not cancel use templet?',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22984,'是否確定取消套紅？',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22985,'请先取消套红！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22985,'Please cancel use templet first!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22985,'請先取消套紅！',9) 
GO
