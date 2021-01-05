CREATE TABLE hpOutDataTabSetting (
eid int NOT NULL ,
tabid int NULL ,
title varchar(500) NULL ,
type char(1) NULL ,
id int NOT NULL IDENTITY(1,1) 
)
GO
CREATE TABLE hpOutDataSettingField (
id int NOT NULL IDENTITY(1,1) ,
eid int NULL ,
tabid int NULL ,
showfield varchar(500) NULL ,
showfieldname varchar(500) NULL ,
isshowname char(50) NULL ,
transql varchar(500) NULL ,
mainid int NULL 
)
GO
CREATE TABLE hpOutDataSettingDef (
id int NOT NULL IDENTITY(1,1) ,
pattern char(1) NULL ,
source varchar(100) NULL ,
area varchar(500) NULL ,
dataKey varchar(50) NULL ,
eid int NULL ,
tabid int NULL ,
wsaddress varchar(500) NULL ,
wsmethod varchar(500) NULL ,
wspara varchar(500) NULL ,
href varchar(500) NULL ,
sysaddr varchar(50) NULL 
)
GO
CREATE TABLE hpOutDataSettingAddr (
eid int NOT NULL ,
tabid int NULL ,
sourceid int NULL ,
address varchar(500) NULL DEFAULT NULL ,
pos int NULL ,
id int NOT NULL IDENTITY(1,1) 
)
GO