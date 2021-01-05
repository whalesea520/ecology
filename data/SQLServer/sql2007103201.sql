delete from HtmlLabelIndex where id=21011
GO
delete from HtmlLabelInfo where indexid=21011
GO
INSERT INTO HtmlLabelIndex values(21011,'系统标识重复')
GO
INSERT INTO HtmlLabelInfo VALUES(21011,'系统标识重复',7)
GO
INSERT INTO HtmlLabelInfo VALUES(21011,'System Id Duplicated',8)
GO