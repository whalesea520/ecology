CREATE TABLE SERIALNUM(
   ID INT primary key identity(1,1),
   NUM INT,
   CODEMAINID INT,
   FIELD1 VARCHAR(20),
   FIELD2 VARCHAR(20),
   FIELD3 VARCHAR(20),
   FIELD4 VARCHAR(20),
   FIELD5 VARCHAR(20),
   FIELD6 VARCHAR(20)
)
go
ALTER TABLE modecodeDetail ADD isSerial int
go
alter table modecode add startCode int
go
alter table ModeCodeDetail add tablename varchar(50)
go
alter table ModeCodeDetail add fieldname varchar(50)
go