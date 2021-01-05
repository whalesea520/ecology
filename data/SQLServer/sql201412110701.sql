delete from ErrorMsgIndex where id=173 
GO
delete from ErrorMsgInfo where indexid=173 
GO
INSERT INTO ErrorMsgIndex values(173,'单点认证地址无法连接') 
GO
INSERT INTO ErrorMsgInfo VALUES(173,'单点认证地址无法连接',7) 
GO
INSERT INTO ErrorMsgInfo VALUES(173,'SSO Url can not connect',8) 
GO
INSERT INTO ErrorMsgInfo VALUES(173,'單點認證地址無法連接',9) 
GO

delete from ErrorMsgIndex where id=174 
GO
delete from ErrorMsgInfo where indexid=174 
GO
INSERT INTO ErrorMsgIndex values(174,'单点认证服务无法使用') 
GO
INSERT INTO ErrorMsgInfo VALUES(174,'单点认证服务无法使用',7) 
GO
INSERT INTO ErrorMsgInfo VALUES(174,'SSO Auth Service can not use',8) 
GO
INSERT INTO ErrorMsgInfo VALUES(174,'單點認證服務無法使用',9) 
GO