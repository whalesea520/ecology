CREATE TABLE DocChangeFieldConfig (
	chageFlag varchar(50) NULL ,
	companyid int NULL,
	version int NULL,
	workflowid int NULL,
	fieldname varchar(50) NULL ,
	outerfieldname varchar(50) NULL ,
	rulesopt varchar(10) NULL
)
/

alter table DocChangeReceive add chageFlag varchar(50)
/
alter table DocChangeReceive add flagTitle varchar(250)
/

CREATE TABLE DocChangeReceiveField (
	chageFlag varchar(50) NULL ,
	companyid int NULL,
	sn int NULL,
	version int NULL,
	fieldid varchar(50) NULL ,
	fieldname varchar(50) NULL,
	fieldvalue varchar(4000) NULL
)
/

alter table DocChangeSetting add pathcategory varchar(250)
/
alter table DocChangeSetting add maincategory int
/
alter table DocChangeSetting add subcategory int
/
alter table DocChangeSetting add seccategory int
/
