alter table menushareinfo add jobtitlelevel varchar(1000)
GO
alter table menushareinfo add jobtitlesharevalue varchar(1000)
GO
alter table shareinnerhp add jobtitlelevel varchar(1000)
GO
alter table shareinnerhp add jobtitlesharevalue varchar(1000)
GO
alter table ptaccesscontrollist add jobtitle varchar(1000)
GO
alter table ptaccesscontrollist add jobtitlelevel varchar(1000)
GO
alter table ptaccesscontrollist add jobtitlesharevalue varchar(1000)
GO
create table elementshareinfo (
	id int identity(1,1) primary key not null,
	eid int,
	sharetype varchar(1000),
	sharevalue varchar(1000),
	seclevel varchar(1000),
	seclevelmax varchar(1000),
	rolelevel varchar(1000),
	includeSub varchar(1),
	jobtitlelevel varchar(1000),
	jobtitlesharevalue varchar(1000)
)
GO
