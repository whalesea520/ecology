delete from HtmlLabelIndex where id=20278
GO
delete from HtmlLabelIndex where id=20280
GO
delete from HtmlLabelIndex where id=20279
GO
delete from HtmlLabelIndex where id=20286
GO
delete from HtmlLabelIndex where id=20289
GO
delete from HtmlLabelInfo where indexid=20278
GO
delete from HtmlLabelInfo where indexid=20280
GO
delete from HtmlLabelInfo where indexid=20279
GO
delete from HtmlLabelInfo where indexid=20286
GO
delete from HtmlLabelInfo where indexid=20289
GO

INSERT INTO HtmlLabelIndex values(20278,'动态密码设置')
GO
INSERT INTO HtmlLabelIndex values(20280,'动态密码长度')
GO
INSERT INTO HtmlLabelIndex values(20279,'是否需要使用动态密码功能')
GO
INSERT INTO HtmlLabelInfo VALUES(20278,'动态密码设置',7)
GO
INSERT INTO HtmlLabelInfo VALUES(20278,'Dynamic Password Setting',8)
GO
INSERT INTO HtmlLabelInfo VALUES(20279,'是否需要使用动态密码功能',7)
GO
INSERT INTO HtmlLabelInfo VALUES(20279,'Is valible dynamic password',8)
GO
INSERT INTO HtmlLabelInfo VALUES(20280,'动态密码长度',7)
GO
INSERT INTO HtmlLabelInfo VALUES(20280,'Length of Password',8)
GO
INSERT INTO HtmlLabelIndex values(20289,'请使用动态密码')
GO
INSERT INTO HtmlLabelInfo VALUES(20289,'请使用动态密码',7)
GO
INSERT INTO HtmlLabelInfo VALUES(20289,'Please use dynamic password',8)
GO
INSERT INTO HtmlLabelIndex values(20286,'使用动态密码')
GO
INSERT INTO HtmlLabelInfo VALUES(20286,'使用动态密码',7)
GO
INSERT INTO HtmlLabelInfo VALUES(20286,'Use Dynamic Password',8)
GO
