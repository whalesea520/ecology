CREATE TABLE HandwrittenSignature(
	markId int IDENTITY(1,1) NOT NULL,
	markName varchar(100) NOT NULL,
	hrmresid int NOT NULL,
	password varchar(50) NOT NULL,
	markPath varchar(200) NULL,
	markType varchar(10) NULL,
	markSize int NULL,
	markDate datetime NULL,
	lastmodificationtime datetime NULL
)
GO