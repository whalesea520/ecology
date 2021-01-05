alter table WX_MsgRuleSetting add isenable tinyint
go

update WX_MsgRuleSetting set isenable=1
go