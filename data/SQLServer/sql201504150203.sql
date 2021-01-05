create table DataCenterUserSetting(
	id int identity(1,1) primary key,
	userid varchar(100),
	eid varchar(100),
	openlink varchar(10),
	todo varchar(10),
	todocolor varchar(10),
	asset varchar(10),
	assetcolor varchar(10),
	cowork varchar(10),
	coworkcolor varchar(10),
	proj varchar(10),
	projcolor varchar(10),
	customer varchar(10),
	customercolor varchar(10),
	blog varchar(10),
	blogcolor varchar(10),
	mydoc varchar(10),
	mydoccolor varchar(10)
)
GO