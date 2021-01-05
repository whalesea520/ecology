CREATE TABLE sensitive_settings(
	id int IDENTITY(1,1) NOT NULL,
	status int NULL,
	handleWay varchar(50) NULL,
	remindUsers varchar(100) NULL
) 

GO

ALTER TABLE sensitive_settings ADD  CONSTRAINT [DF_sensitive_settings_status]  DEFAULT ((0)) FOR [status]
GO

ALTER TABLE sensitive_settings ADD  CONSTRAINT [DF_sensitive_settings_handleWay]  DEFAULT ((0)) FOR [handleWay]
GO

ALTER TABLE sensitive_settings ADD  CONSTRAINT [DF_sensitive_settings_remindUsers]  DEFAULT ((1)) FOR [remindUsers]
GO

insert into sensitive_settings(status,handleWay,remindUsers) values(0,'0','1')

GO

CREATE TABLE sensitive_words(
	id int IDENTITY(1,1) NOT NULL,
	word varchar(500) NOT NULL
) 

GO

CREATE TABLE sensitive_logs(
	id int IDENTITY(1,1) NOT NULL,
	module varchar(100) NULL,
	path varchar(2000) NULL,
	doccontent varchar(4000) NULL,
	sensitiveWords varchar(4000) NULL,
	handleWay varchar(50) NULL,
	userid int NULL,
	submitTime varchar(50) NULL,
	clientAddress varchar(50) NULL
)

GO