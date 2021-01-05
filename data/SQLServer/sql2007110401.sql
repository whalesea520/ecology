delete from HtmlLabelIndex where id=21003
GO
delete from HtmlLabelInfo where indexid=21003
GO
delete from HtmlLabelIndex where id=21002
GO
delete from HtmlLabelInfo where indexid=21002
GO
INSERT INTO HtmlLabelIndex values(21002,'自定义单选')
GO
INSERT INTO HtmlLabelInfo VALUES(21002,'自定义单选',7)
GO
INSERT INTO HtmlLabelInfo VALUES(21002,'customlize single select',8)
GO
INSERT INTO HtmlLabelIndex values(21003,'自定义多选')
GO
INSERT INTO HtmlLabelInfo VALUES(21003,'自定义多选',7)
GO
INSERT INTO HtmlLabelInfo VALUES(21003,'customlize multi select',8)
GO
