if exists (select * from dbo.sysobjects where id = object_id(N'hpElementImg') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table hpElementImg
GO

CREATE TABLE hpElementImg (
	imagefileid int NOT NULL ,
	eid int NOT NULL ,
	filerealpath varchar (200) not null,
	miniimgpath varchar (200) not null,
	iszip varchar (1) not null,
	imgsize varchar (50) null
)
GO