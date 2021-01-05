delete from HtmlLabelIndex where id=20170
GO
delete from HtmlLabelIndex where id=20171
GO
delete from HtmlLabelIndex where id=20172
GO
delete from HtmlLabelInfo where indexid=20170
GO
delete from HtmlLabelInfo where indexid=20171
GO
delete from HtmlLabelInfo where indexid=20172
GO
INSERT INTO HtmlLabelIndex values(20170,'密码设置') 
GO
INSERT INTO HtmlLabelIndex values(20171,'密码最小长度') 
GO
INSERT INTO HtmlLabelIndex values(20172,'密码长度不能小于') 
GO
INSERT INTO HtmlLabelInfo VALUES(20170,'密码设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20170,'password preference',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20171,'密码最小长度',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20171,'Password Min. Length',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20172,'密码长度不能小于',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20172,'The password length can''t less than',8) 
GO