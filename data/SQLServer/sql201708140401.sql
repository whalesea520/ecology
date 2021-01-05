delete from HtmlLabelIndex where id=81868 
GO
delete from HtmlLabelInfo where indexid=81868 
GO
INSERT INTO HtmlLabelIndex values(81868,'被禁用') 
GO
INSERT INTO HtmlLabelInfo VALUES(81868,'被禁用',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(81868,'is forbidden',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(81868,'被禁用',9) 
GO