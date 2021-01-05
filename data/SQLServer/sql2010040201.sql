delete from ErrorMsgIndex where id=62
GO
delete from ErrorMsgInfo where indexid=62
GO
insert into ErrorMsgIndex(id, indexdesc) values (62, '«Î≤Â»Îµ«¬ºU-Key')
GO
insert into ErrorMsgInfo(indexid, msgname, languageid) values (62, '«Î≤Â»Îµ«¬ºU-Key', 7)
GO
insert into ErrorMsgInfo(indexid, msgname, languageid) values (62, 'Please insert the usb-key', 8)
GO
insert into ErrorMsgInfo(indexid, msgname, languageid) values (62, '’à≤Â»Îµ«‰õU-Key', 9)
GO
