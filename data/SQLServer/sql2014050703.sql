CREATE TABLE MobileSetting(
	id integer IDENTITY NOT NULL, 
	scope integer NOT NULL, 
	module integer NOT NULL, 
	fields varchar(50), 
	value varchar(200)
)
GO

create table workflowBlacklist(
	id integer IDENTITY NOT NULL,
	userid integer NOT NULL, 
	workflowid integer NOT NULL
)
GO