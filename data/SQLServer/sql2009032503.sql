CREATE TABLE DocFTPConfig (
	id int identity (1, 1) not null,
	FTPConfigName varchar(100) null ,
	FTPConfigDesc varchar(200) null ,
	serverIP varchar(200) null ,
	serverPort varchar(10) null ,
	userName varchar(100) null ,
	userPassword varchar(200) null ,
	defaultRootDir varchar(200) null  ,
	maxConnCount int null   ,
	showOrder decimal(6,2) null 
)
GO


CREATE TABLE DocMainCatFTPConfig (
	id int identity (1, 1) not null,
	mainCategoryId int null ,
	refreshSubAndSec char(1) null ,
	isUseFTP char(1) null ,
	FTPConfigId int null  
)
GO

CREATE TABLE DocSubCatFTPConfig (
	id int identity (1, 1) not null,
	subCategoryId int null ,
	refreshSec char(1) null ,
	isUseFTP char(1) null ,
	FTPConfigId int null  
)
GO


CREATE TABLE DocSecCatFTPConfig (
	id int identity (1, 1) not null,
	secCategoryId int null ,
	isUseFTP char(1) null ,
	FTPConfigId int null  
)
GO


ALTER TABLE ImageFile ADD isFTP char(1) NULL
GO

ALTER TABLE ImageFile ADD FTPConfigId int NULL
GO
