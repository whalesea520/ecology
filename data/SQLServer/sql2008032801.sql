delete from HtmlLabelIndex where id=21402 
GO
delete from HtmlLabelInfo where indexid=21402 
GO
INSERT INTO HtmlLabelIndex values(21402,'服务器被重启，请复制下重要信息重新登录后再填写信息提交！') 
GO
delete from HtmlLabelIndex where id=21403 
GO
delete from HtmlLabelInfo where indexid=21403 
GO
INSERT INTO HtmlLabelIndex values(21403,'网络故障或其它原因导致您连接不上服务器，请复制下重要信息稍候再提交！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21402,'服务器被重启，请复制下重要信息重新登录后再填写信息提交！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21402,'server restarted ,please logon then submit again',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21403,'网络故障或其它原因导致您连接不上服务器，请复制下重要信息稍候再提交！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21403,'you can not connect server,please wait to submit',8) 
GO

delete from HtmlLabelIndex where id=21791 
GO
delete from HtmlLabelInfo where indexid=21791 
GO
INSERT INTO HtmlLabelIndex values(21791,'按【确定】继续,按【取消】停留在本页!') 
GO
INSERT INTO HtmlLabelInfo VALUES(21791,'按【确定】继续,按【取消】停留在本页!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21791,'Click 【OK】 to continue. Click 【Cancel】 to back.',8) 
GO
