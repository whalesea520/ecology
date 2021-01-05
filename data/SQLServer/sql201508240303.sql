CREATE TABLE outter_network(
	id int IDENTITY(1,1) NOT NULL,
	inceptipaddress varchar(1000) NULL,
	endipaddress varchar(1000) NULL,
	sysid  varchar(1000) NULL
	
)
GO
alter table outter_sys add autologin char(1)
GO
CREATE TABLE outter_encryptclass(
	id int IDENTITY(1,1) NOT NULL,
	encryptclass varchar(1000) NULL,
	encryptmethod varchar(1000) NULL
	
	
)
GO
alter table outter_sys add encryptclassId int 
GO
alter table outter_sys add imagewidth int 
GO
alter table outter_sys add imageheight int 
GO
CREATE TABLE outter_Moreview1(
	id int IDENTITY(1,1) NOT NULL,
	c1 varchar(4000) NULL,
	c2 varchar(4000) NULL,
	c3 varchar(4000) NULL,
	c4 varchar(4000) NULL,
	c5 varchar(4000) NULL
	
)
GO