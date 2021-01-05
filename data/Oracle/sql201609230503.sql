CREATE TABLE ImageFileRef(
	id int primary key,
	imagefileid int NULL,
	computercode varchar(64) NULL,
	diskPath varchar(255) NULL,
	relativePath varchar(255) NULL,
	fileName varchar(255) NULL,
	createdate varchar(10) NULL,
	createtime varchar(8) NULL,
	createrid int NULL,
	modifydate varchar(10) NULL,
	modifytime varchar(8) NULL,
	modifierid int NULL,
	filepathmd5 varchar(200) NULL,
	comefrom varchar(64) NULL,
	categoryid int NULL
)
/

create sequence ImageFileRef_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger ImageFileRef_id_Tri
before insert on ImageFileRef
for each row
begin
select ImageFileRef_id.nextval into :new.id from dual;
end;
/

CREATE TABLE ImageFileReftemp(
	id int primary key,
	imagefileid int NULL,
	computercode varchar(64) NULL,
	diskPath varchar(255) NULL,
	relativePath varchar(255) NULL,
	fileName varchar(255) NULL,
	createdate varchar(10) NULL,
	createtime varchar(8) NULL,
	createrid int NULL,
	modifydate varchar(10) NULL,
	modifytime varchar(8) NULL,
	modifierid int NULL,
	filepathmd5 varchar(200) NULL,
	comefrom varchar(64) NULL,
	categoryid int NULL,
	fileSize int NULL,
	tempFilePath varchar(255) NULL,
	uploadSize int NULL,
	uploadfileguid varchar(64) NULL
)

/

create sequence ImageFileReftemp_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger ImageFileReftemp_id_Tri
before insert on ImageFileReftemp
for each row
begin
select ImageFileReftemp_id.nextval into :new.id from dual;
end;
/

CREATE TABLE RdeploySyncSetting(
	id int primary key,
	mid int NULL,
	computerName varchar(255) NULL,
	localPath varchar(255) NULL,
	isUse int NULL,
	guid varchar(128) NULL,
	categoryid int NULL
)

/

create sequence RdeploySyncSetting_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger RdeploySyncSetting_id_Tri
before insert on RdeploySyncSetting
for each row
begin
select RdeploySyncSetting_id.nextval into :new.id from dual;
end;
/

CREATE TABLE RdeploySyncSettingMain(
	id int primary key,
	loginid varchar(25) NULL,
	synctime varchar(10) NULL,
	isOpen int NULL
) 

/

create sequence RdeploySyncSettingMain_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger RdeploySyncSettingMain_id_Tri
before insert on RdeploySyncSettingMain
for each row
begin
select RdeploySyncSettingMain_id.nextval into :new.id from dual;
end;
/

CREATE TABLE NetworkfileLog(
	id int primary key,
	imagefileid int NULL,
	fileName varchar(255) NULL,
	relativePath varchar(255) NULL,
	categoryid int NULL,
	fileSize int NULL,
	userid int NULL,
	"uid" varchar(64) NULL,
	lastDate varchar(10) NULL,
	lastTime varchar(8) NULL,
	opType int NULL,
	isDelete int NULL
)

/

create sequence NetworkfileLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger NetworkfileLog_id_Tri
before insert on NetworkfileLog
for each row
begin
select NetworkfileLog_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Networkfileshare(
	id int primary key,
	fileid int NULL,
	sharerid int NULL,
	tosharerid int NULL,
	sharedate varchar(10) NULL,
	sharetime varchar(10) NULL,
	sharetype int NULL,
	filetype int NULL
) 

/

create sequence Networkfileshare_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger Networkfileshare_id_Tri
before insert on Networkfileshare
for each row
begin
select Networkfileshare_id.nextval into :new.id from dual;
end;
/

CREATE TABLE DownloadFileTemp(
	fileid nvarchar2(500) NOT NULL,
	localpath nvarchar2(500) NOT NULL,
	clientguid nvarchar2(500) NOT NULL,
	userid nvarchar2(500) NOT NULL,
	downloaddate date NOT NULL,
	type int NULL,
	downloadfileguid varchar(64) NULL
) 

/

ALTER TABLE DownloadFileTemp modify downloaddate DEFAULT sysdate
/
