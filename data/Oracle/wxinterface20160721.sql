alter table WX_MsgRuleSetting add ifwftodo integer
/
alter table WX_MsgRuleSetting add ifwffinish integer
/
alter table WX_MsgRuleSetting add ifwftimeout integer
/
alter table WX_MsgRuleSetting add ifwfreject integer
/
update  WX_MsgRuleSetting set ifwftodo=1 where type=1 and (wfsettype in (0,2) or wfsettype is null)
/
update  WX_MsgRuleSetting set ifwffinish=1 where type=1 and wfsettype in (1,2)
/
update  WX_MsgRuleSetting set ifwftimeout=1,ifwfreject=1 where type=1
/