create table carbasic
(
	id int primary key identity(1,1),
	workflowid int,
	workflowname varchar(100),
	typeid int,
	wtype int,
	formid int,
	isuse int,
	modifydate varchar(20)
)
go
create table mode_carrelatemode
(
    id int primary key identity(1,1),
    mainid int,
    carfieldid int,
    modefieldid int
)
go