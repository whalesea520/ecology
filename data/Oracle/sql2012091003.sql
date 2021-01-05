create table SAPCONN(
	code varchar2(20) primary key,
	HostName varchar2(100),
	Language varchar2(100),
	SystemNumber varchar2(100),
	SAPClient varchar2(100),
	Userid varchar2(100),
	Password varchar2(100),
	isdefault int
)
/

alter table workflow_base add SAPSource varchar2(20)
/
alter table SAPData_Auth_setting add sources varchar2(4000)
/