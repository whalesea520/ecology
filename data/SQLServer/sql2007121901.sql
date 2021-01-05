delete from HtmlLabelIndex where id=21199 
GO
delete from HtmlLabelInfo where indexid=21199 
GO
INSERT INTO HtmlLabelIndex values(21199,'显示流转情况') 
GO
delete from HtmlLabelIndex where id=21200 
GO
delete from HtmlLabelInfo where indexid=21200 
GO
INSERT INTO HtmlLabelIndex values(21200,'隐藏流转情况') 
GO
INSERT INTO HtmlLabelInfo VALUES(21199,'显示流转情况',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21199,'Show Flow Path',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21200,'隐藏流转情况',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21200,'Hidden Flow Path',8) 
GO