delete from MobileConfig where mc_type = 0
GO
insert into MobileConfig(mc_type,mc_name,mc_value) values(0,'target','0')
GO