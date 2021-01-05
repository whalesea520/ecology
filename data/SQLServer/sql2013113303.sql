CREATE TABLE blog_Group
	(
	id   INT IDENTITY,
	groupname VARCHAR (200) NULL,
	userid     INT NULL
	)
GO
CREATE TABLE blog_userGroup
	(
	id   INT IDENTITY,
	groupid int NULL,
	userid     INT NULL
	)
GO
