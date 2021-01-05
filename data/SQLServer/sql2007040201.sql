delete HtmlLabelIndex where id=20276
GO
delete HtmlLabelInfo where indexid=20276
GO
INSERT INTO HtmlLabelIndex values(20276,'您没有可显示的首页！') 
GO
INSERT INTO HtmlLabelInfo VALUES(20276,'您没有可显示的首页！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20276,'You have none to show!',8) 
GO
