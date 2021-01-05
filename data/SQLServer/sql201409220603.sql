CREATE TABLE HrmResourceFile(
	id int IDENTITY(1,1) NOT NULL,
	resourceid int NULL,
	fieldid int NULL,
	docid int NULL,
	docname varchar(4000) NULL,
	doccreater int NULL,
	createdate varchar(10) NULL,
	createtime varchar(8) NULL,
	scopeId int NULL
)
GO