CREATE TABLE WorkFlow_UserRef(
	keyid int IDENTITY(1,1) NOT NULL,
	name varchar(50) NULL,
	pwd varchar(50) NULL,
	userids varchar(500) NULL,
	usertype int NULL
)
GO