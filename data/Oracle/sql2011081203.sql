insert into mobileconfig(mc_type,mc_module,mc_scope,mc_name,mc_value) values('-1',null,null,'target','2.0')
/
update mobileconfig set mc_value='0' where mc_type='5' and mc_module in ('4','5') and mc_name='visible'
/
