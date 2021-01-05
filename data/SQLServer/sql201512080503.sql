alter table ImageFile add objId  int
GO
alter table ImageFile add objotherpara  varchar(1000)
GO

create table ImageFileSource (
	id int IDENTITY(1,1) NOT NULL primary key,
	imageFileId int  null,
	comefrom varchar(1000)  null,
	objId int  null,
	objotherpara varchar(1000)  null
)
GO