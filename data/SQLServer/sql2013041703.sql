alter table workflow_nodelink add startDirection int
go
alter table workflow_nodelink add endDirection int
go
alter table workflow_nodelink add points varchar(255)
go

create table workflow_groupinfo (
	id int primary key identity(1, 1), 
	workflowid int not null, 
	groupname nvarchar(255),
	direction int,
	x decimal,
	y decimal,
	width decimal,
	height decimal
)
go