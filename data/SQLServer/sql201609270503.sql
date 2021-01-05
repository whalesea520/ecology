CREATE TABLE  FullSearch_CusLabel (
id int NOT NULL IDENTITY(1,1) ,
type varchar(100) ,
sourceid int NOT NULL ,
label varchar(1000),
updateTime datetime
)
GO