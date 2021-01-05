CREATE TABLE HRSYNCSETADDFIELD 
   (	ID int NOT NULL, 
	TABLENAME varchar(200), 
	FIELDNAME varchar(200), 
	LABELID int
   )
GO
insert into hrsyncsetaddfield(id,tablename,fieldname,labelid)values(1,'hrmsubcompany','outkey',126059)
GO
insert into hrsyncsetaddfield(id,tablename,fieldname,labelid)values(2,'hrmdepartment','outkey',126059)
GO
insert into hrsyncsetaddfield(id,tablename,fieldname,labelid)values(3,'hrmresource','outkey',126059)
GO
insert into hrsyncsetaddfield(id,tablename,fieldname,labelid)values(4,'hrmresource','password',83865)
GO