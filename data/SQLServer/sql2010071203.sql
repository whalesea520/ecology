CREATE TABLE DocChangeFieldConfig (
	chageFlag varchar(50) NULL ,
	companyid int NULL,
	version int NULL,
	workflowid int NULL,
	fieldname varchar(50) NULL ,
	outerfieldname varchar(50) NULL ,
	rulesopt varchar(10) NULL
)
GO

alter table DocChangeReceive add chageFlag varchar(50)
GO
alter table DocChangeReceive add flagTitle varchar(250)
GO

CREATE TABLE DocChangeReceiveField (
	chageFlag varchar(50) NULL ,
	companyid int NULL,
	sn int NULL,
	version int NULL,
	fieldid varchar(50) NULL ,
	fieldname varchar(50) NULL,
	fieldvalue varchar(4000) NULL
)
GO

alter table DocChangeSetting add pathcategory varchar(250)
GO
alter table DocChangeSetting add maincategory int
GO
alter table DocChangeSetting add subcategory int
GO
alter table DocChangeSetting add seccategory int
GO
