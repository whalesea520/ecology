create table actionsetting
(
	id int IDENTITY(1,1) NOT NULL,
	actionname varchar(200),
	actionclass varchar(2000),
	typename varchar(20)
)
GO