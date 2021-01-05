delete from ErrorMsgIndex where id=175 
GO
delete from ErrorMsgInfo where indexid=175 
GO
INSERT INTO ErrorMsgIndex values(175,'您已被管理员强制下线！') 
GO
INSERT INTO ErrorMsgInfo VALUES(175,'您已被管理员强制下线！',7) 
GO
INSERT INTO ErrorMsgInfo VALUES(175,'You have been forced to logoff administrator!',8) 
GO
INSERT INTO ErrorMsgInfo VALUES(175,'您已被管理員強制下線！',9) 
GO
INSERT INTO ErrorMsgInfo VALUES(175,'您已被管理員強制下線！',10) 
GO