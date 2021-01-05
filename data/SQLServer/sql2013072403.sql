CREATE TABLE PluginMessageRecent(
	id int IDENTITY(1,1) NOT NULL,
	fromUid varchar(50) NOT NULL,
	toUid varchar(50) NOT NULL,
	RecentTime varchar(22) NOT NULL,
	source varchar(1) NOT NULL
)

GO
