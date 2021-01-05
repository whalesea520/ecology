delete from HtmlLabelIndex where id=21758 
GO
delete from HtmlLabelInfo where indexid=21758 
GO
INSERT INTO HtmlLabelIndex values(21758,'扫描频率') 
GO
INSERT INTO HtmlLabelInfo VALUES(21758,'扫描频率',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21758,'Scanning frequency',8) 
GO

delete from HtmlLabelIndex where id=21759 
GO
delete from HtmlLabelInfo where indexid=21759 
GO
INSERT INTO HtmlLabelIndex values(21759,'扫描频率时间必须大于0！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21759,'扫描频率时间必须大于0！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21759,'Scanning frequency must be greater than 0!',8) 
GO

delete from HtmlLabelIndex where id=21760 
GO
delete from HtmlLabelInfo where indexid=21760 
GO
INSERT INTO HtmlLabelIndex values(21760,'此设置需重启服务才能生效') 
GO
INSERT INTO HtmlLabelInfo VALUES(21760,'此设置需重启服务才能生效',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21760,'This duplication of services to be set to take effect',8) 
GO