delete from ErrorMsgIndex where id=185 
GO
delete from ErrorMsgInfo where indexid=185 
GO
INSERT INTO ErrorMsgIndex values(185,'用户名或密码错误') 
GO
INSERT INTO ErrorMsgInfo VALUES(185,'用户名或密码错误',7) 
GO
INSERT INTO ErrorMsgInfo VALUES(185,'User name or password wrong',8) 
GO
INSERT INTO ErrorMsgInfo VALUES(185,'用戶名或密碼錯誤',9) 
GO