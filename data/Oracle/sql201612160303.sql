CREATE TABLE Social_FileDownloadLog(
	id int primary key,
	fileid varchar2(100),
	userid int,
	lastsavepath varchar2(255),
	downloadcount int
)
/