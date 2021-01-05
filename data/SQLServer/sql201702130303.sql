create table mode_batchimp_log(
	id int IDENTITY(1,1),
	modeid int,
	operatetype int,
	ipaddress varchar(50),
	operator int,
	optdatetime varchar(50),
	addrow int,
	updaterow int,
	delrow int,
	adddetailrow int,
	deldetailrow int
)
GO