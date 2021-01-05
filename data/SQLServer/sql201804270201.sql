delete from HtmlLabelIndex where id=383210 
GO
delete from HtmlLabelInfo where indexid=383210 
GO
INSERT INTO HtmlLabelIndex values(383210,'批量撤销账号') 
GO
INSERT INTO HtmlLabelInfo VALUES(383210,'将Ecology中所有用户账号与LDAP账号做撤销操作，即所有用户都使用Ecology数据库认证方式进行登录；注意：请确保Ecology用户账号都有密码,否则会影响用户登录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(383210,'All user accounts and LDAP accounts in Ecology are revoked,that is,all users use the Ecology database authentication method to log in.Notice:please make sure that the Ecology user account has a password,otherwise the user will log in',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(383210,'將Ecology中所有用戶帳號與LDAP帳號做撤銷操作，即所有用戶都使用Ecology資料庫認證管道進行登入；注意：請確保Ecology用戶帳號都有密碼，否則會影響用戶登錄',9) 
GO