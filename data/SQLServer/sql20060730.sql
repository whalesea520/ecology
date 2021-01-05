update HtmlLabelIndex set indexdesc='系统不支持10层以上的收（发）文单位！' where id=19319
GO
update HtmlLabelInfo set labelname='系统不支持10层以上的收（发）文单位！'   where indexid=19319 and languageid=7
GO
update HtmlLabelInfo set labelname='The system doesn''t support 10 level of receive(dispatch) unit!'  where indexid=19319 and languageid=8
GO

update HtmlLabelIndex set indexdesc='收（发）文单位' where id=19309
GO
update HtmlLabelInfo set labelname='收（发）文单位'   where indexid=19309 and languageid=7
GO
update HtmlLabelInfo set labelname='Receive(Dispatch) Unit'  where indexid=19309 and languageid=8
GO

update HtmlLabelIndex set indexdesc='收（发）文员' where id=19311
GO
update HtmlLabelInfo set labelname='收（发）文员'   where indexid=19311 and languageid=7
GO
update HtmlLabelInfo set labelname='Receiver(Dispatcher)'  where indexid=19311 and languageid=8
GO
