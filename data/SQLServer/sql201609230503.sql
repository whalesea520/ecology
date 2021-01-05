CREATE TABLE ImageFileRef(
	id int primary key identity(1,1),
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

GO

CREATE TABLE ImageFileReftemp(
	id int primary key identity(1,1),
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

GO

CREATE TABLE RdeploySyncSetting(
	id int primary key identity(1,1),
	mid int NULL,
	computerName varchar(255) NULL,
	localPath varchar(255) NULL,
	isUse int NULL,
	guid varchar(128) NULL,
	categoryid int NULL
)

GO

CREATE TABLE RdeploySyncSettingMain(
	id int primary key identity(1,1),
	loginid varchar(25) NULL,
	synctime varchar(10) NULL,
	isOpen int NULL
) 

GO

CREATE TABLE NetworkfileLog(
	id int primary key identity(1,1),
	imagefileid int NULL,
	fileName varchar(255) NULL,
	relativePath varchar(255) NULL,
	categoryid int NULL,
	fileSize int NULL,
	userid int NULL,
	uid varchar(64) NULL,
	lastDate varchar(10) NULL,
	lastTime varchar(8) NULL,
	opType int NULL,
	isDelete int NULL
)

GO

CREATE TABLE Networkfileshare(
	id int primary key identity(1,1),
	fileid int NULL,
	sharerid int NULL,
	tosharerid int NULL,
	sharedate varchar(10) NULL,
	sharetime varchar(10) NULL,
	sharetype int NULL,
	filetype int NULL
) 

GO

CREATE TABLE DownloadFileTemp(
	fileid nvarchar(500) NOT NULL,
	localpath nvarchar(500) NOT NULL,
	clientguid nvarchar(500) NOT NULL,
	userid nvarchar(500) NOT NULL,
	downloaddate datetime NOT NULL,
	type int NULL,
	downloadfileguid varchar(64) NULL
) 

GO

ALTER TABLE DownloadFileTemp ADD  CONSTRAINT DF_DownloadFileTemp_downloaddate  DEFAULT (getdate()) FOR downloaddate

GO