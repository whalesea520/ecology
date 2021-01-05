delete from ErrorMsgIndex where id=60
GO
delete from ErrorMsgInfo where indexid=60
GO
insert into ErrorMsgIndex(id, indexdesc) values (60, '获取域名或登陆名错误！')
GO
insert into ErrorMsgInfo(indexid, msgname, languageid) values (60, '获取域名或登陆名错误！', 7)
GO
insert into ErrorMsgInfo(indexid, msgname, languageid) values (60, 'Get Domain Name or Login ID Error !', 8)
GO
insert into ErrorMsgInfo(indexid, msgname, languageid) values (60, '獲取域名或登陸名錯誤！', 9)
GO

delete from ErrorMsgIndex where id=61
GO
delete from ErrorMsgInfo where indexid=61
GO
insert into ErrorMsgIndex(id, indexdesc) values (61, '你还没有登陆域')
GO
insert into ErrorMsgInfo(indexid, msgname, languageid) values (61, '你还没有登陆域', 7)
GO
insert into ErrorMsgInfo(indexid, msgname, languageid) values (61, 'Demain Name Error !', 8)
GO
insert into ErrorMsgInfo(indexid, msgname, languageid) values (61, '你還沒有登陸域', 9)
GO
