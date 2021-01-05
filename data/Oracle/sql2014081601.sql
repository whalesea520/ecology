delete from ErrorMsgIndex where id=169 
/
delete from ErrorMsgInfo where indexid=169 
/
INSERT INTO ErrorMsgIndex values(169,'单点登录时间不合法') 
/
INSERT INTO ErrorMsgInfo VALUES(169,'单点登录时间不合法',7) 
/
INSERT INTO ErrorMsgInfo VALUES(169,'SSO TS is invalid',8) 
/
INSERT INTO ErrorMsgInfo VALUES(169,'單點登錄時間不合法',9) 
/

delete from ErrorMsgIndex where id=170 
/
delete from ErrorMsgInfo where indexid=170 
/
INSERT INTO ErrorMsgIndex values(170,'单点登录token为空') 
/
INSERT INTO ErrorMsgInfo VALUES(170,'单点登录token为空',7) 
/
INSERT INTO ErrorMsgInfo VALUES(170,'SSO token is Empty',8) 
/
INSERT INTO ErrorMsgInfo VALUES(170,'單點登錄token爲空',9) 
/

delete from ErrorMsgIndex where id=171 
/
delete from ErrorMsgInfo where indexid=171 
/
INSERT INTO ErrorMsgIndex values(171,'单点登录token校验不一致') 
/
INSERT INTO ErrorMsgInfo VALUES(171,'单点登录token校验不一致',7) 
/
INSERT INTO ErrorMsgInfo VALUES(171,'SSO token verify fail',8) 
/
INSERT INTO ErrorMsgInfo VALUES(171,'單點登錄token校驗不一緻',9) 
/
