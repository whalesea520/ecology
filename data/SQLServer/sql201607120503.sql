create table social_sysremind(
	id int IDENTITY,
  	remindtype int,
  	requestid int,
  	requesttitle varchar(100),
  	requestdetails varchar(2000),
  	sendtime char(20),
  	extra varchar(1000)
)
GO
create table social_sysremindreceiver(
	id int IDENTITY,
  	remindid int,
  	receiverid int
)
GO
create table social_sysremindtype(
	id int IDENTITY,
  	remindtype int,
  	remindname varchar(100),
  	surl varchar(200)
)
GO
create index social_receiverid_index on social_sysremindreceiver(receiverid)
GO
create index social_sysrid_index on social_sysremind(id)
GO
create index social_sysrtypeid_index on social_sysremindtype(remindtype)
GO

create table social_sysremindsetting(
	id int IDENTITY,
  	remindtype int,
  	userid int,
  	ifon char(1),
  	ifDeskRemind char(1)
)
GO
create index social_settingtype_index on social_sysremindsetting(remindtype)
GO







