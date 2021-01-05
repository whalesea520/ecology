CREATE TABLE Social_FileDownloadLog(
	id int IDENTITY(1,1) NOT NULL,
	fileid varchar(100) NULL,
	userid int NULL,
	lastsavepath varchar(255) NULL,
	downloadcount int NULL
)
GO