delete from ErrorMsgIndex where id=162 
GO
delete from ErrorMsgInfo where indexid=162 
GO
INSERT INTO ErrorMsgIndex values(162,'该资产组名已被引用') 
GO
INSERT INTO ErrorMsgInfo VALUES(162,'该资产组名已被引用!',7) 
GO
INSERT INTO ErrorMsgInfo VALUES(162,'A used name you have input!',8) 
GO
INSERT INTO ErrorMsgInfo VALUES(162,'該資產組名已被引用!',9) 
GO