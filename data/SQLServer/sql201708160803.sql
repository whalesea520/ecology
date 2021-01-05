create table configFileManager(
id int identity(1,1) not null,
labelid int null,
filetype int ,
filename varchar(200) not null,
filepath varchar(200) not null,
fileinfo varchar(500) null,
qcnumber varchar(15) null,
kbversion varchar(30) null,
createdate varchar(10) null,	
createtime varchar(8) null,
)
GO
create table configPropertiesFile(
id int identity(1,1) not null,
configfileid int not null,
attrname  varchar(200) not null,
attrvalue varchar(200) not null,
attrnotes varchar(500) null,	
createdate varchar(10) null,
createtime varchar(8) null,
issystem  int  default 0
)
GO
create table configXmlFile(
id int identity(1,1) not null,
configfileid int not null,
attrvalue varchar(1000) not null,	
attrnotes varchar(500) null,	
createdate varchar(10) null,
createtime varchar(8) null,
issystem  int  default 0
)
GO
CREATE TABLE KBQCDetail(
id int identity(1,1) not null,
qcnumber int not null,
sysversion varchar(200),
kbversion VARCHAR(200),
versiontype char(1) ,
description varchar(500) null
)
GO
CREATE TABLE CustomerKBVersion(
id int identity(1,1) not null,
name VARCHAR(200),
sysversion VARCHAR(200)
)
GO
CREATE TABLE CustomerSysVersion(
id int identity(1,1) not null,
name VARCHAR(200)
)
GO	