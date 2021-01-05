create table CRM_CardRegSettings
(  
id int identity(1,1) primary key, 
isopen int,
url varchar(200),
loginid varchar(50),
password varchar(50),
modifydate varchar(50),
modifytime varchar(50),
modifyuser varchar(10)
)
GO
insert into CRM_CardRegSettings (isopen) values (0)
GO