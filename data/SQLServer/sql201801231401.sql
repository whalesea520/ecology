delete from HtmlLabelIndex where id=382265 
GO
delete from HtmlLabelInfo where indexid=382265 
GO
INSERT INTO HtmlLabelIndex values(382265,'此用户不允许修改密码') 
GO
delete from HtmlLabelIndex where id=382266 
GO
delete from HtmlLabelInfo where indexid=382266 
GO
INSERT INTO HtmlLabelIndex values(382266,'旧密码不正确') 
GO
delete from HtmlLabelIndex where id=382267 
GO
delete from HtmlLabelInfo where indexid=382267 
GO
INSERT INTO HtmlLabelIndex values(382267,'新密码长度不符合规范') 
GO
INSERT INTO HtmlLabelInfo VALUES(382267,'新密码长度不符合规范',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382267,'New password length does not conform to specification',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382267,'新密碼長度不符合規範',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(382266,'旧密码不正确',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382266,'The old password is not correct',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382266,'舊密碼不正確',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(382265,'此用户不允许修改密码',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(382265,'This user is not allowed to modify the password',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(382265,'此用戶不允許修改密碼',9) 
GO