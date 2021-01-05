create table templetecheck_matchresult(
id int identity(1,1) not null,
filepath  varchar(200) not null,
workflowname varchar(200) null,
nodename varchar(200) null,
detail varchar(2000) null
)
GO