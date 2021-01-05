CREATE TABLE PluginMessages (
	id int IDENTITY NOT NULL,
	fromUid varchar(50) NOT NULL,
	sendTo varchar(50) NOT NULL,
	msg varchar(1000) NULL,
	receiveTime varchar(22) NOT NULL
)

GO