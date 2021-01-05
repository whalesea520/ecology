alter table hpinfo add menustyleid varchar2(100) null
/
update hpinfo set menustyleid=styleid
/
