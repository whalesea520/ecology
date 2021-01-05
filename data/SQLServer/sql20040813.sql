/* 文档自定义新增功能*/
CREATE TABLE cus_fielddata (
    seqorder int IDENTITY (1, 1) NOT NULL,
    scope varchar(50) NOT NULL ,
    scopeid int NOT NULL,
	id int NOT NULL 
)
GO

CREATE TABLE cus_formdict (
	id int NOT NULL ,
	fielddbtype varchar (40) ,
	fieldhtmltype char (1) ,
	type int 
)
GO

CREATE TABLE cus_formfield (
	scope varchar(50) NOT NULL ,
    scopeid int NOT NULL ,
    fieldlable varchar(100),
	fieldid int NOT NULL ,
    fieldorder int NOT NULL,
    ismand char(1)
)
GO

CREATE TABLE cus_selectitem (
	fieldid int NOT NULL,
    selectvalue int NOT NULL,
    selectname varchar(250),
    fieldorder int NOT NULL
)
GO