delete from HtmlLabelIndex where id=21151 
GO
delete from HtmlLabelInfo where indexid=21151 
GO
INSERT INTO HtmlLabelIndex values(21151,'该考核项目已被引用，不能删除') 
GO
INSERT INTO HtmlLabelInfo VALUES(21151,'该考核项目已被引用，不能删除',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21151,'CanNotbeDelete',8) 
GO