delete from ErrorMsgIndex where id=58
GO
delete from ErrorMsgInfo where indexid=58
GO
insert into ErrorMsgIndex(id, indexdesc) values (58, '验证客户端签名错误')
GO
insert into ErrorMsgInfo(indexid, msgname, languageid) values (58, '验证客户端签名错误', 7)
GO
insert into ErrorMsgInfo(indexid, msgname, languageid) values (58, 'Check customer sign error', 8)
GO
insert into ErrorMsgInfo(indexid, msgname, languageid) values (58, '驗證客戶端簽名錯誤', 9)
GO


delete from ErrorMsgIndex where id=59
GO
delete from ErrorMsgInfo where indexid=59
GO
insert into ErrorMsgIndex(id, indexdesc) values (59, '数字证书无效')
GO
insert into ErrorMsgInfo(indexid, msgname, languageid) values (59, '数字证书无效', 7)
GO
insert into ErrorMsgInfo(indexid, msgname, languageid) values (59, 'Key is invalid', 8)
GO
insert into ErrorMsgInfo(indexid, msgname, languageid) values (59, '数字证书无效', 9)
GO