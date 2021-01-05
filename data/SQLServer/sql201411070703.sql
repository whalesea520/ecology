create table mode_customSearchButton(
	id int IDENTITY(1,1) NOT NULL,
	objid int,
	buttonname varchar(100),
	hreftype int,
	hreftargetParid varchar(100),
	hreftargetParval varchar(100),
	hreftarget varchar(1000),
	jsmethodname varchar(100),
	jsParameter varchar(1000),
	jsmethodbody text,
	isshow int,
	describe varchar(4000),
    showorder decimal(15, 2),
)
go
