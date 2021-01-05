alter table WX_MsgRuleSetting add iftoall smallint
/

update WX_MsgRuleSetting set iftoall=2
/