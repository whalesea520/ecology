create table ldapsynclog (
Id int identity(1,1),
DataId int,
DataType int,
OperationType int,
CreateDate varchar(10),
CreateTime varchar(8)
)
go