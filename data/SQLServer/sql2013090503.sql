CREATE TABLE cpcchangenotice
(
       id int primary key not null identity(1,1), 
       c_companyid  int,
       c_type int,
       c_year  int,
       c_month int,
       c_time   varchar(20),
       c_desc  varchar(400)
)
GO

