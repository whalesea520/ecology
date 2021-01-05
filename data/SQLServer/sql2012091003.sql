create table SAPCONN(
	code varchar(20) primary key,
	HostName varchar(100),
	Language varchar(100),
	SystemNumber varchar(100),
	SAPClient varchar(100),
	Userid varchar(100),
	Password varchar(100),
	isdefault int
)
GO

alter table workflow_base add SAPSource varchar(20)
GO
alter table SAPData_Auth_setting add sources varchar(4000)
GO