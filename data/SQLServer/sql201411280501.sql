delete from HtmlLabelIndex where id=81686 
GO
delete from HtmlLabelInfo where indexid=81686 
GO
INSERT INTO HtmlLabelIndex values(81686,'用户名或密码有误！') 
GO
INSERT INTO HtmlLabelInfo VALUES(81686,'用户名或密码有误！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(81686,'The user name or password is incorrect！',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(81686,'用戶名或密碼有誤！',9) 
GO