CREATE TABLE cowork_base_set(
id int identity(1,1) NOT NULL ,
itemstate varchar(2) NULL ,
infostate varchar(2) NULL ,
userid int NULL ,
createdate char(10) NULL ,
createtime char(8) NULL ,
dealchangeminute varchar(200) NULL, 
PRIMARY KEY CLUSTERED 
(
	id ASC
)
) 

GO



CREATE TABLE cowork_votes(
id int identity(1,1) NOT NULL ,
itemid int NULL ,
discussID int NULL ,
userid int NULL ,
createdate char(10) NULL ,
createtime char(5) NULL ,
status varchar(2) NULL, 
PRIMARY KEY CLUSTERED 
(
	id ASC
)
) 

GO


CREATE TABLE cowork_collect(
id int identity(1,1) NOT NULL ,
itemid int NULL ,
discussID int NULL ,
userid int NULL ,
createdate char(10) NULL ,
createtime char(8) NULL ,
iscollect varchar(2) NULL, 
PRIMARY KEY CLUSTERED 
(
	id ASC
)
) 

GO