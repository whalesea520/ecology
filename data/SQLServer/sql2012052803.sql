CREATE TABLE blog_template
	(
	id          INT IDENTITY NOT NULL,
	tempName    VARCHAR (100) NULL,
	isUsed      INT NULL,
	tempContent TEXT NULL,
	description TEXT NULL,
	CONSTRAINT PK_blog_template PRIMARY KEY (id)
	)
GO

CREATE TABLE blog_tempShare
	(
	id       INT IDENTITY NOT NULL,
	tempid   INT NULL,
	type     INT NULL,
	content  VARCHAR (4000) NULL,
	seclevel INT NULL,
	CONSTRAINT PK_blog_tempShare PRIMARY KEY (id)
	)
GO

CREATE TABLE tokenJscx
	(
	tokenKey VARCHAR (100) NOT NULL,
	authkey  VARCHAR (200) NOT NULL,
	currsucc INT DEFAULT ((0)) NULL,
	currdft  INT DEFAULT ((0)) NULL,
	lastcode VARCHAR (20) NULL,
	lasttime VARCHAR (20) NULL,
	userid   INT NULL
	)
GO

CREATE TABLE blog_specifiedShare
	(
	id              INT IDENTITY NOT NULL PRIMARY KEY,
	specifiedid     INT NULL,
	type            INT NULL,
	content         VARCHAR (4000) NULL,
	seclevel        INT NULL,
	sharelevel      INT NULL
	)
GO

alter table HrmResource add tokenkey varchar(100)
GO

ALTER TABLE tokenJscx ALTER COLUMN authkey VARCHAR(4000)
GO