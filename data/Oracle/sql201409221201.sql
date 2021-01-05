delete from ErrorMsgIndex where id=172 
/
delete from ErrorMsgInfo where indexid=172 
/
INSERT INTO ErrorMsgIndex values(172,'已过有效期') 
/
INSERT INTO ErrorMsgInfo VALUES(172,'已过有效期',7) 
/
INSERT INTO ErrorMsgInfo VALUES(172,'Expired',8) 
/
INSERT INTO ErrorMsgInfo VALUES(172,'已過有效期',9) 
/