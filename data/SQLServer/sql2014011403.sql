CREATE TABLE ImageFileTempPic(
	id int identity (1, 1) NOT NULL ,
	imagefileid int NOT NULL,
	docid int NULL,
	createid int NULL,
	createdate char(10) NULL,
	createtime char(8) NULL
)
GO

create index temppic_imagefileid_idx on ImageFileTempPic(imagefileid)
GO