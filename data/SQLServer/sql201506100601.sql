delete from ErrorMsgIndex where id=178 
GO
delete from ErrorMsgInfo where indexid=178 
GO
INSERT INTO ErrorMsgIndex values(178,'该国家简称已经存在，不能保存') 
GO
INSERT INTO ErrorMsgInfo VALUES(178,'该国家简称已经存在，不能保存',7) 
GO
INSERT INTO ErrorMsgInfo VALUES(178,'The country has simply been there and can''''t be saved',8) 
GO
INSERT INTO ErrorMsgInfo VALUES(178,'該國家簡稱已經存在，不能保存',9) 
GO

delete from ErrorMsgIndex where id=179 
GO
delete from ErrorMsgInfo where indexid=179 
GO
INSERT INTO ErrorMsgIndex values(179,'该国家全称已经存在，不能保存') 
GO
INSERT INTO ErrorMsgInfo VALUES(179,'该国家全称已经存在，不能保存',7) 
GO
INSERT INTO ErrorMsgInfo VALUES(179,'The full name of the country already exists and can not be saved',8) 
GO
INSERT INTO ErrorMsgInfo VALUES(179,'該國家全稱已經存在，不能保存',9) 
GO