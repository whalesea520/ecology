CREATE TABLE cowork_quiter(
id int identity(1,1) NOT NULL ,
itemid int NULL ,
userid int NULL ,
quitdate char(10) NULL ,
quittime char(8) NULL ,
coworkothers ntext NULL, 
PRIMARY KEY CLUSTERED 
(
	id ASC
)
) 

GO