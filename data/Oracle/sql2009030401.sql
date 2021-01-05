
delete from ErrorMsgIndex where id=58
/
delete from ErrorMsgInfo where indexid=58
/
insert into ErrorMsgIndex(id, indexdesc) values (58, '验证客户端签名错误')
/
insert into ErrorMsgInfo(indexid, msgname, languageid) values (58, '验证客户端签名错误', 7)
/
insert into ErrorMsgInfo(indexid, msgname, languageid) values (58, 'Check customer sign error', 8)
/
insert into ErrorMsgInfo(indexid, msgname, languageid) values (58, '驗證客戶端簽名錯誤', 9)
/
