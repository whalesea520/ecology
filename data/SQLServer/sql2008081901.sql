delete from HtmlLabelIndex where id=21807 
GO
delete from HtmlLabelInfo where indexid=21807 
GO
INSERT INTO HtmlLabelIndex values(21807,'自动签出') 
GO
delete from HtmlLabelIndex where id=21808 
GO
delete from HtmlLabelInfo where indexid=21808 
GO
INSERT INTO HtmlLabelIndex values(21808,'自动签入') 
GO
delete from HtmlLabelIndex where id=21806 
GO
delete from HtmlLabelInfo where indexid=21806 
GO
INSERT INTO HtmlLabelIndex values(21806,'强制签出') 
GO
INSERT INTO HtmlLabelInfo VALUES(21806,'强制签出',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21806,'Check Out Compellably',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21807,'自动签出',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21807,'Check Out Automatically',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21808,'自动签入',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21808,'Check In Automatically',8) 
GO