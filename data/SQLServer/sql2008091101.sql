delete from HtmlLabelIndex where id=21823 
GO
delete from HtmlLabelInfo where indexid=21823 
GO
INSERT INTO HtmlLabelIndex values(21823,'RSS读取类型设置') 
GO
delete from HtmlLabelIndex where id=21822 
GO
delete from HtmlLabelInfo where indexid=21822 
GO
INSERT INTO HtmlLabelIndex values(21822,'RSS读取类型') 
GO
INSERT INTO HtmlLabelInfo VALUES(21822,'RSS读取类型',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21822,'RSS read type',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21823,'RSS读取类型设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21823,'Set type of RSS reading',8) 
GO