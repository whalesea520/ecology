delete from HtmlLabelIndex where id=127119
GO
delete from HtmlLabelInfo where indexid=127119
GO
INSERT INTO HtmlLabelIndex values(127119,'web�Ϳͻ���emessage�������')
GO
INSERT INTO HtmlLabelInfo VALUES(127119,'web�Ϳͻ���emessage�������',7)
GO
INSERT INTO HtmlLabelInfo VALUES(127119,'Emessage for Web and client related settings',8)
GO
INSERT INTO HtmlLabelInfo VALUES(127119,'web�Ϳ͑���emessage���P�O��',9)
GO
update MainMenuInfo set appdesc = '127119' where id=10238
GO