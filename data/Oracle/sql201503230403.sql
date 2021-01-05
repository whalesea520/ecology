alter table moderightinfo add conditiontype int
/
alter table moderightinfo add conditionsql varchar2(4000)
/
alter table moderightinfo add conditiontext varchar2(4000)
/
CREATE TABLE mode_expressions(
	id int NOT NULL ,
	rightid int ,
	relation int ,
	expids varchar2(1000) ,
	expbaseid int 
) 
/
create table mode_expressionbase (
	id int not null,
	fieldid int,
	fieldname varchar2(100),
	fieldlabel varchar2(200),
	rightid int,
	compareopion int ,
	compareopionlabel varchar2(200),
	htmltype varchar2(100),
	fieldtype varchar2(100),
	fielddbtype varchar2(1000),
	fieldvalue varchar2(1000),
	fieldtext varchar2(1000),
	relationtype int,
	valetype int
)
/