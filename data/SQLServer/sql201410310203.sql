alter table  sypara_expressions add wfexid varchar(100)
GO
create table sywfexinfo(sourceid varchar(100) not null,wfid varchar(100),wfexid varchar(100) not null)
GO
alter table sypara_variablebase add  filterformid varchar(100)
GO
alter table sypara_variablebase add  filterisbill varchar (2)
GO
alter table sypara_variablebase add  filtername varchar(100)
GO
alter table sypara_expressionbase add wfexid VARCHAR(100)
GO
