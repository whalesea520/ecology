delete from ErrorMsgIndex where id=169 
GO
delete from ErrorMsgInfo where indexid=169 
GO
INSERT INTO ErrorMsgIndex values(169,'�����¼ʱ�䲻�Ϸ�') 
GO
INSERT INTO ErrorMsgInfo VALUES(169,'�����¼ʱ�䲻�Ϸ�',7) 
GO
INSERT INTO ErrorMsgInfo VALUES(169,'SSO TS is invalid',8) 
GO
INSERT INTO ErrorMsgInfo VALUES(169,'���c��䛕r�g���Ϸ�',9) 
GO

delete from ErrorMsgIndex where id=170 
GO
delete from ErrorMsgInfo where indexid=170 
GO
INSERT INTO ErrorMsgIndex values(170,'�����¼tokenΪ��') 
GO
INSERT INTO ErrorMsgInfo VALUES(170,'�����¼tokenΪ��',7) 
GO
INSERT INTO ErrorMsgInfo VALUES(170,'SSO token is Empty',8) 
GO
INSERT INTO ErrorMsgInfo VALUES(170,'���c���token����',9) 
GO

delete from ErrorMsgIndex where id=171 
GO
delete from ErrorMsgInfo where indexid=171 
GO
INSERT INTO ErrorMsgIndex values(171,'�����¼tokenУ�鲻һ��') 
GO
INSERT INTO ErrorMsgInfo VALUES(171,'�����¼tokenУ�鲻һ��',7) 
GO
INSERT INTO ErrorMsgInfo VALUES(171,'SSO token verify fail',8) 
GO
INSERT INTO ErrorMsgInfo VALUES(171,'���c���tokenУ򞲻һ�@',9) 
GO