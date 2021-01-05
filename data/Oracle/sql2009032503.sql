CREATE TABLE DocFTPConfig (
	id int  not null,
	FTPConfigName varchar(100) null ,
	FTPConfigDesc varchar(200) null ,
	serverIP varchar(200) null ,
	serverPort varchar(10) null ,
	userName varchar(100) null ,
	userPassword varchar(200) null ,
	defaultRootDir varchar(200) null  ,
	maxConnCount int null   ,
	showOrder number(6,2) null 
)
/
create sequence DocFTPConfig_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocFTPConfig_Trigger
before insert on DocFTPConfig
for each row
begin
select DocFTPConfig_id.nextval into :new.id from dual;
end;
/

CREATE TABLE DocMainCatFTPConfig (
	id integer  not null,
	mainCategoryId integer null ,
	refreshSubAndSec char(1) null ,
	isUseFTP char(1) null ,
	FTPConfigId integer null  
)
/
create sequence DocMainCatFTPConfig_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocMainCatFTPConfig_Trigger
before insert on DocMainCatFTPConfig
for each row
begin
select DocMainCatFTPConfig_id.nextval into :new.id from dual;
end;
/

CREATE TABLE DocSubCatFTPConfig (
	id integer  not null,
	subCategoryId integer null ,
	refreshSec char(1) null ,
	isUseFTP char(1) null ,
	FTPConfigId integer null  
)
/
create sequence DocSubCatFTPConfig_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocSubCatFTPConfig_Trigger
before insert on DocSubCatFTPConfig
for each row
begin
select DocSubCatFTPConfig_id.nextval into :new.id from dual;
end;
/

CREATE TABLE DocSecCatFTPConfig (
	id integer  not null,
	secCategoryId integer null ,
	isUseFTP char(1) null ,
	FTPConfigId integer null  
)
/
create sequence DocSecCatFTPConfig_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocSecCatFTPConfig_Trigger
before insert on DocSecCatFTPConfig
for each row
begin
select DocSecCatFTPConfig_id.nextval into :new.id from dual;
end;
/

ALTER TABLE ImageFile ADD isFTP char(1) NULL
/

ALTER TABLE ImageFile ADD FTPConfigId integer NULL
/