delete from HtmlLabelIndex where id=21008 
GO
delete from HtmlLabelInfo where indexid=21008 
GO
INSERT INTO HtmlLabelIndex values(21008,'临时LICENSE申请') 
GO
delete from HtmlLabelIndex where id=21007 
GO
delete from HtmlLabelInfo where indexid=21007 
GO
INSERT INTO HtmlLabelIndex values(21007,'临时LICENSE') 
GO
delete from HtmlLabelIndex where id=21009 
GO
delete from HtmlLabelInfo where indexid=21009 
GO
INSERT INTO HtmlLabelIndex values(21009,'临时LICENSE清零') 
GO
INSERT INTO HtmlLabelInfo VALUES(21007,'临时LICENSE',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21007,'TEMP LICENSE',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21008,'临时LICENSE申请',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21008,'TEMP LICENSE APPLAY',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21009,'临时LICENSE清零',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21009,'TEMP LICENSE RESET',8) 
GO