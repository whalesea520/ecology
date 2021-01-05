CREATE TABLE MailSign (
	id int IDENTITY (1, 1) NOT NULL ,
	userId int NULL ,
	signName varchar (100) ,
	signDesc varchar(200),
	signContent text
)
GO
