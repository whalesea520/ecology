delete from ErrorMsgIndex where id=60
/
delete from ErrorMsgInfo where indexid=60
/
insert into ErrorMsgIndex(id, indexdesc) values (60, '获取域名或登陆名错误！')
/
insert into ErrorMsgInfo(indexid, msgname, languageid) values (60, '获取域名或登陆名错误！', 7)
/
insert into ErrorMsgInfo(indexid, msgname, languageid) values (60, 'Get Domain Name or Login ID Error !', 8)
/
insert into ErrorMsgInfo(indexid, msgname, languageid) values (60, '獲取域名或登陸名錯誤！', 9)
/

delete from ErrorMsgIndex where id=61
/
delete from ErrorMsgInfo where indexid=61
/
insert into ErrorMsgIndex(id, indexdesc) values (61, '你还没有登陆域')
/
insert into ErrorMsgInfo(indexid, msgname, languageid) values (61, '你还没有登陆域', 7)
/
insert into ErrorMsgInfo(indexid, msgname, languageid) values (61, 'Demain Name Error !', 8)
/
insert into ErrorMsgInfo(indexid, msgname, languageid) values (61, '你還沒有登陸域', 9)
/
