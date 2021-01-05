alter table hpelement add shareuser varchar(1000)
GO
update hpelement set shareuser = '5_1' 
GO
alter table hpinfo add maintainer varchar(200)
GO
