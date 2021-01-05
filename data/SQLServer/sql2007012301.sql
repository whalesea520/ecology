delete from HtmlLabelIndex where id=20186
go
delete from HtmlLabelInfo where indexid=20186
go
delete from HtmlLabelIndex where id=20187
go
delete from HtmlLabelInfo where indexid=20187
go
INSERT INTO HtmlLabelIndex values(20186,'是否只是外网IP登陆需要验证码') 
go
INSERT INTO HtmlLabelIndex values(20187,'局域网IP规则') 
go
INSERT INTO HtmlLabelInfo VALUES(20186,'是否只是外网IP登陆需要验证码',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20186,'whether only logining from WAN IP need validate code',8) 
go
INSERT INTO HtmlLabelInfo VALUES(20187,'局域网IP规则',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20187,'LAN IP Rule',8) 
go