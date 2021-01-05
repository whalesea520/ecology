delete from HtmlLabelIndex where id=21619 
GO
delete from HtmlLabelInfo where indexid=21619 
GO
INSERT INTO HtmlLabelIndex values(21619,'正 文') 
GO
delete from HtmlLabelIndex where id=21618 
GO
delete from HtmlLabelInfo where indexid=21618 
GO
INSERT INTO HtmlLabelIndex values(21618,'表 单') 
GO
INSERT INTO HtmlLabelInfo VALUES(21618,'表 单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21618,'Form',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21619,'正 文',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21619,'Text',8) 
GO