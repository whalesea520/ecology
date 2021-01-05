create table  hp_nonstandard_func_server(
	id int identity(1,1) not null,
	funcid int  not null,
	serverid int not null,
	status int 
)
GO

create table  hp_server_info(
	id int identity(1,1) not null,
	serverIP varchar(1000) not null,
	serverType int
)
GO