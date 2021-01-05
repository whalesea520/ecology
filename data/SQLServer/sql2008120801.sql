delete from HtmlLabelIndex where id=22150 
GO
delete from HtmlLabelInfo where indexid=22150 
GO
INSERT INTO HtmlLabelIndex values(22150,'我的信息') 
GO
INSERT INTO HtmlLabelInfo VALUES(22150,'我的信息',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22150,'My message',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22150,'我的信息',9) 
GO