create table configFileManager(
id INTEGER PRIMARY key not null,
labelid INTEGER null,
filetype INTEGER , 
filename varchar(200) not null,
filepath varchar(200) not null, 
fileinfo varchar(500) null,
qcnumber varchar(15) null,
kbversion varchar(30) null,
createdate varchar(10) null,
createtime varchar(8) null
)
/
CREATE SEQUENCE configFileManager_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger configFileManager_Tri
before insert on configFileManager
for each row
begin
select configFileManager_seq.nextval into :new.id from dual;
end;
/
create table configPropertiesFile(
id INTEGER PRIMARY key not null,
configfileid INTEGER not null,
attrname  varchar(200) not null,
attrvalue varchar(200) not null,
attrnotes varchar(500) null,
createdate varchar(10) null,
createtime varchar(8) null,
issystem  INTEGER  default 0  
)
/
CREATE SEQUENCE configPropertiesFile_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger configPropertiesFile_Tri
before insert on configPropertiesFile
for each row
begin
select configPropertiesFile_seq.nextval into :new.id from dual;
end;
/
create table configXmlFile(
id INTEGER PRIMARY key not null,
configfileid INTEGER not null,
attrvalue varchar(1000) not null,
attrnotes varchar(500) null,
createdate varchar(10) null,
createtime varchar(8) null,
issystem  INTEGER  default 0  
)
/
CREATE SEQUENCE configXmlFile_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger configXmlFile_Tri
before insert on configXmlFile
for each row
begin
select configXmlFile_seq.nextval into :new.id from dual;
end;
/
CREATE TABLE KBQCDetail(
id INTEGER PRIMARY key not null,
qcnumber INTEGER not null,
sysversion varchar(200),
kbversion VARCHAR(200),
versiontype char(1) ,
description varchar(500) null
)
/
CREATE SEQUENCE KBQCDetail_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger KBQCDetailm_Tri
before insert on KBQCDetail
for each row
begin
select KBQCDetail_seq.nextval into :new.id from dual;
end;
/
CREATE TABLE CustomerKBVersion(
id INTEGER PRIMARY key not null,
name VARCHAR(200),
sysversion VARCHAR(200) 
)
/
CREATE SEQUENCE CustomerKBVersion_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger CustomerKBVersion_Tri
before insert on CustomerKBVersion
for each row
begin
select CustomerKBVersion_seq.nextval into :new.id from dual;
end;
/
CREATE TABLE CustomerSysVersion(
id INTEGER PRIMARY key not null,
name VARCHAR(200)
)
/
CREATE SEQUENCE CustomerSysVersion_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger CustomerSysVersion_Tri
before insert on CustomerSysVersion
for each row
begin
select CustomerSysVersion_seq.nextval into :new.id from dual;
end;
/
