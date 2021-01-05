ALTER TABLE DocPopUpInfo ADD  pop_type int null
Go

create table DocPopUpUser(
    id  int  IDENTITY(1,1) primary key CLUSTERED,
    userid  int,
    docid  int,
    haspopnum  int,
    beiyong varchar(200)
)
go