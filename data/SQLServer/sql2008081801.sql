delete from HtmlLabelIndex where id=21799 
GO
delete from HtmlLabelInfo where indexid=21799 
GO
INSERT INTO HtmlLabelIndex values(21799,'此合同模板已被引用，不能直接删除') 
GO
INSERT INTO HtmlLabelInfo VALUES(21799,'此合同模板已被引用，不能直接删除',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21799,'This contract template has been invoked, can not directly delete',8) 
GO