alter table moderightinfo add conditiontype int
GO
alter table moderightinfo add conditionsql varchar(4000)
GO
alter table moderightinfo add conditiontext varchar(4000)
GO
CREATE TABLE mode_expressions(
	id int NOT NULL ,
	rightid int ,
	relation int ,
	expids varchar(1000) ,
	expbaseid int 
) 
GO
create table mode_expressionbase (
	id int not null,
	fieldid int,
	fieldname varchar(100),
	fieldlabel varchar(200),
	rightid int,
	compareopion int ,
	compareopionlabel varchar(200),
	htmltype varchar(100),
	fieldtype varchar(100),
	fielddbtype varchar(1000),
	fieldvalue varchar(1000),
	fieldtext varchar(1000),
	relationtype int,
	valetype int
)
GO