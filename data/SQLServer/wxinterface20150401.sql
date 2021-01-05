alter table WX_MsgRuleSetting add iftoall tinyint
go

update WX_MsgRuleSetting set iftoall=2
go