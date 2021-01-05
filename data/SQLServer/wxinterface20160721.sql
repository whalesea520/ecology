alter table WX_MsgRuleSetting add ifwftodo int
go
alter table WX_MsgRuleSetting add ifwffinish int
go
alter table WX_MsgRuleSetting add ifwftimeout int
go
alter table WX_MsgRuleSetting add ifwfreject int
go
update  WX_MsgRuleSetting set ifwftodo=1 where type=1 and (wfsettype in (0,2) or wfsettype is null)
go
update  WX_MsgRuleSetting set ifwffinish=1 where type=1 and wfsettype in (1,2)
go
update  WX_MsgRuleSetting set ifwftimeout=1,ifwfreject=1 where type=1
go