CREATE TABLE HrmMessagerGroup (
	groupname int IDENTITY (1, 1) NOT NULL ,
	groupdesc  varchar(1000)  NOT NULL 
) 
GO

CREATE TABLE HrmMessagerGroupUsers (
	id int IDENTITY (1, 1) NOT NULL ,
	userloginid  varchar(100) NOT NULL ,
	groupname  int NOT NULL ,
	isadmin  char(1) NOT NULL 
) 
GO

CREATE TABLE HrmMessagerContact (
	id int IDENTITY (1, 1) NOT NULL ,
	loginid varchar(50) not null,
	contactLoginid  varchar(50) not null,
	lastContactTime varchar(20) not null
) 
GO

alter table hrmresource  add messagerurl  varchar(100) 
GO

CREATE TABLE HrmMessagerMsg (
	id int IDENTITY (1, 1) NOT NULL ,
	jidCurrent varchar(50) not null,
	sendTo  varchar(50) not null,
	msg varchar(1000)  null,
	strTime varchar(22) not null
) 
GO

create index i_msgJid on HrmMessagerMsg(jidCurrent)
go

CREATE TABLE HrmMessagerSetting (
	id int IDENTITY (1, 1) NOT NULL ,
	name varchar(50) not null,
	value  varchar(50) not null
) 
GO
