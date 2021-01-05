CREATE TABLE blog_notes
	(
	id         INT IDENTITY NOT NULL,
	userid     INT NOT NULL,
	updatedate VARCHAR (10) NULL,
	content    text NULL,
	isRemind   INT NULL
	)
GO