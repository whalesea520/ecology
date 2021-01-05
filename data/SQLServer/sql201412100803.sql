create table actionsettingdetail
(
    id int IDENTITY(1,1) NOT NULL,
    actionid int,
	attrname varchar(1000),
	attrvalue varchar(1000)
)
GO