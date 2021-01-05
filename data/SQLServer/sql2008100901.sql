delete from HtmlLabelIndex where id=21897 
GO
delete from HtmlLabelInfo where indexid=21897 
GO
INSERT INTO HtmlLabelIndex values(21897,'启用自定义落款') 
GO
INSERT INTO HtmlLabelInfo VALUES(21897,'启用自定义落款',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21897,'Use custom sender',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21897,'',9) 
GO
delete from HtmlLabelIndex where id=21915 
GO
delete from HtmlLabelInfo where indexid=21915 
GO
INSERT INTO HtmlLabelIndex values(21915,'短信发送页面增加一个必填的落款输入框') 
GO
INSERT INTO HtmlLabelInfo VALUES(21915,'短信发送页面增加一个必填的落款输入框',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21915,'Add a input "Sender" which is must be writen',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21915,'',9) 
GO
delete from HtmlLabelIndex where id=21801 
GO
delete from HtmlLabelInfo where indexid=21801 
GO
INSERT INTO HtmlLabelIndex values(21801,'落款不能为空！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21801,'落款不能为空！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21801,'Sender can not be empty !',8) 
GO
delete from HtmlLabelIndex where id=21800 
GO
delete from HtmlLabelInfo where indexid=21800 
GO
INSERT INTO HtmlLabelIndex values(21800,'落款') 
GO
INSERT INTO HtmlLabelInfo VALUES(21800,'落款',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21800,'Sender',8) 
GO