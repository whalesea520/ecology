create table SqlFileLogInfo(
	id int IDENTITY (1, 1) NOT NULL,
	sqlfilename varchar(200) NOT NULL,
	rundate varchar(10),
  runtime varchar(10)
)
GO
