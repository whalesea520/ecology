IF OBJECT_ID (N'MobileDocSetting', N'U') IS NOT NULL
DROP TABLE MobileDocSetting
GO

CREATE TABLE MobileDocSetting(
	columnid int IDENTITY NOT NULL,
	scope int NOT NULL,
	name varchar(100) NOT NULL,
	source int NOT NULL,
	showOrder int,
	isreplay int
)
GO

IF OBJECT_ID (N'MobileDocColSetting', N'U') IS NOT NULL
DROP TABLE MobileDocColSetting
GO

CREATE TABLE MobileDocColSetting(
	columnid int NOT NULL,
	docid int NOT NULL
)
GO

DELETE FROM MobileSetting
GO