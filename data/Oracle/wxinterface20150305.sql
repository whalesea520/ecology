alter table WX_MsgRuleSetting add isenable smallint
/

update WX_MsgRuleSetting set isenable=1
/