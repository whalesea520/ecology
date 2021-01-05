create table datashowset
(
  id int IDENTITY (1, 1) NOT NULL ,
  showname varchar(200),
  showclass char(1),
  datafrom char(1),
  datasourceid varchar(100),
  sqltext text,
  wsurl varchar(1000),
  wsoperation varchar(1000),
  xmltext text,
  inpara varchar(1000),
  showtype char(1),
  keyfield varchar(100),
  parentfield varchar(1000),
  showfield varchar(1000),
  detailpageurl varchar(1000)
)
GO
alter table datashowset add typename char(1)
GO
alter table datashowset add selecttype char(1)
GO
alter table datashowset add showpageurl varchar(200)
GO