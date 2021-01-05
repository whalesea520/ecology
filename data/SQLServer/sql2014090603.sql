create table MobileMPCData(
	entityid int not null,
	businessid varchar(50) not null,
	mpcid varchar(50) not null,
	content varchar(4000)
)
go
alter table MobileMPCData add constraint MobileMPCData_PK primary key (entityid,businessid,mpcid)
go