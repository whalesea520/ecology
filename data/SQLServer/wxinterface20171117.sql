alter table WX_MsgRuleSetting add startdate varchar(20)
go
alter table WX_MsgRuleSetting add startcentext varchar(4000)
go
alter table WX_MsgRuleSetting add enddate varchar(20)
go
alter table WX_MsgRuleSetting add endcentext varchar(4000)
go
alter table WX_MsgRuleSetting add resourceids varchar(20)
go
alter table WX_MsgRuleSetting add resourcenames varchar(4000)
go
alter table WX_MsgRuleSetting add resourcetype varchar(20)
go
alter table wx_scanlog add logtime varchar(20)
go
alter table wx_scanlog add logdate varchar(100)
go
alter table wx_scanlog add status varchar(20)
go