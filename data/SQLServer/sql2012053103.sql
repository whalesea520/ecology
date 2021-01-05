create table SAPData_Auth_setting(
	id int IDENTITY(1,1) not null,
	name varchar(100),
	browserids varchar(1000),
	resourcetype char(1),
	resourceids varchar(1000),
	roleids varchar(1000),
	wfids varchar(1000)
)
GO

create table SAPData_Auth_setting_detail(
	settingid int not null,
	filtertype char(1),
	browserid varchar(60),
	sapcode varchar(200)
	
)
GO