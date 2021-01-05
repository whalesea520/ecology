alter table hpinfo add menustyleid varchar(100) null
GO
update hpinfo set menustyleid=styleid
GO
