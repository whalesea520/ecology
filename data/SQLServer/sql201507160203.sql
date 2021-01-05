CREATE TABLE cloudoa_conf (
id int NOT NULL IDENTITY(1,1) ,
confname varchar(50),
confvalue varchar(50)
)
GO

INSERT INTO cloudoa_conf (confname,confvalue) VALUES ('blockstatus', '1');
GO