delete from ErrorMsgIndex where id=169 
GO
delete from ErrorMsgInfo where indexid=169 
GO
INSERT INTO ErrorMsgIndex values(169,'单点登录时间不合法') 
GO
INSERT INTO ErrorMsgInfo VALUES(169,'单点登录时间不合法',7) 
GO
INSERT INTO ErrorMsgInfo VALUES(169,'SSO TS is invalid',8) 
GO
INSERT INTO ErrorMsgInfo VALUES(169,'單點登錄時間不合法',9) 
GO

delete from ErrorMsgIndex where id=170 
GO
delete from ErrorMsgInfo where indexid=170 
GO
INSERT INTO ErrorMsgIndex values(170,'单点登录token为空') 
GO
INSERT INTO ErrorMsgInfo VALUES(170,'单点登录token为空',7) 
GO
INSERT INTO ErrorMsgInfo VALUES(170,'SSO token is Empty',8) 
GO
INSERT INTO ErrorMsgInfo VALUES(170,'單點登錄token爲空',9) 
GO

delete from ErrorMsgIndex where id=171 
GO
delete from ErrorMsgInfo where indexid=171 
GO
INSERT INTO ErrorMsgIndex values(171,'单点登录token校验不一致') 
GO
INSERT INTO ErrorMsgInfo VALUES(171,'单点登录token校验不一致',7) 
GO
INSERT INTO ErrorMsgInfo VALUES(171,'SSO token verify fail',8) 
GO
INSERT INTO ErrorMsgInfo VALUES(171,'單點登錄token校驗不一緻',9) 
GO