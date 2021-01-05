CREATE TABLE HRSYNCSETADDFIELD 
   (	ID number NOT NULL, 
	TABLENAME varchar2(200), 
	FIELDNAME varchar2(200), 
	LABELID number
   )
/
insert into hrsyncsetaddfield(id,tablename,fieldname,labelid)values(1,'hrmsubcompany','outkey',126059)
/
insert into hrsyncsetaddfield(id,tablename,fieldname,labelid)values(2,'hrmdepartment','outkey',126059)
/
insert into hrsyncsetaddfield(id,tablename,fieldname,labelid)values(3,'hrmresource','outkey',126059)
/
insert into hrsyncsetaddfield(id,tablename,fieldname,labelid)values(4,'hrmresource','password',83865)
/