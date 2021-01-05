delete from ErrorMsgIndex where id=172 
GO
delete from ErrorMsgInfo where indexid=172 
GO
INSERT INTO ErrorMsgIndex values(172,'已过有效期') 
GO
INSERT INTO ErrorMsgInfo VALUES(172,'已过有效期',7) 
GO
INSERT INTO ErrorMsgInfo VALUES(172,'Expired',8) 
GO
INSERT INTO ErrorMsgInfo VALUES(172,'已過有效期',9) 
GO