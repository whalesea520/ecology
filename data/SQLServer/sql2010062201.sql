delete from HtmlLabelIndex where id=24723 
GO
delete from HtmlLabelInfo where indexid=24723 
GO
INSERT INTO HtmlLabelIndex values(24723,'接收端口') 
GO
delete from HtmlLabelIndex where id=24724 
GO
delete from HtmlLabelInfo where indexid=24724 
GO
INSERT INTO HtmlLabelIndex values(24724,'发送端口') 
GO
delete from HtmlLabelIndex where id=24725 
GO
delete from HtmlLabelInfo where indexid=24725 
GO
INSERT INTO HtmlLabelIndex values(24725,'是否SSL协议接收') 
GO
delete from HtmlLabelIndex where id=24726 
GO
delete from HtmlLabelInfo where indexid=24726 
GO
INSERT INTO HtmlLabelIndex values(24726,'是否SSL协议发送') 
GO
INSERT INTO HtmlLabelInfo VALUES(24723,'接收端口',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24723,'acceptPort',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24723,'接收端口',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(24724,'发送端口',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24724,'sendport',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24724,'发送端口',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(24725,'是否SSL协议接收',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24725,'isSSLGet',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24725,'是否SSL协议接收',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(24726,'是否SSL协议发送',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24726,'isSSLSend',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24726,'是否SSL协议发送',9) 
GO
