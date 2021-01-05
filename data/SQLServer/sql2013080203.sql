CREATE TABLE ofUpdateInfo ( 
    id int IDENTITY PRIMARY KEY,
    InfoName varchar(20),
    InfoStatus int
   
) 
GO

insert into ofUpdateInfo(InfoName,InfoStatus) values ('userRole',0)
GO
