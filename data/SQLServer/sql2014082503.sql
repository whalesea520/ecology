
CREATE TABLE MailConfigureInfo(
	innerMail INT ,
	outterMail INT,
	filePath VARCHAR(1000),
	totalAttachmentSize INT,
	perAttachmentSize INT,
	attachmentCount INT
)
GO

CREATE TABLE MailLog(
	id           INT IDENTITY NOT NULL,
	submiter     INT NULL,
	submitdate   VARCHAR (30) NULL,
	logtype      CHAR (2) NULL,
	clientip     CHAR (15) NULL,
	subject 	 VARCHAR(1200)
)
GO

ALTER TABLE  webmail_domain DROP COLUMN IS_SSL_AUTH
GO

ALTER TABLE  webmail_domain ADD  IS_SSL_POP VARCHAR(100)
GO

ALTER TABLE  webmail_domain ADD  IS_SSL_SMTP VARCHAR(100)
GO

ALTER TABLE webmail_domain ADD NEED_SAVE INT
go

ALTER TABLE webmail_domain ADD AUTO_RECEIVE INT 
go

ALTER TABLE webmail_domain ADD RECEIVE_SCOPT INT 
GO

ALTER TABLE DocMailMould ADD moulddesc VARCHAR(100)
GO

ALTER TABLE HrmResource ADD totalSpace FLOAT DEFAULT 100
GO

ALTER TABLE HrmResource ADD occupySpace FLOAT DEFAULT 0 
GO

update HrmResource set totalSpace = 100 , occupySpace = 0
GO

DECLARE @id INT
DECLARE @size   FLOAT
DECLARE @totalsize FLOAT
DECLARE sizecursor CURSOR FOR SELECT id FROM MailResource where isInternal = 1 and originalMailId is null 
OPEN sizecursor
FETCH next FROM sizecursor INTO @id
WHILE(@@FETCH_STATUS = 0)
BEGIN
	SELECT @size = isnull(sum(filesize),0) FROM MailResourceFile WHERE mailid = @id 
	
	SELECT @totalsize = DATALENGTH(content)+DATALENGTH(subject) + @size FROM MailResource WHERE id = @id
	
	UPDATE MailResource SET size_n = @totalsize WHERE id = @id
	UPDATE MailResource SET size_n = @totalsize WHERE originalMailId = id
FETCH next FROM sizecursor INTO @id
END 
CLOSE sizecursor
DEALLOCATE sizecursor
GO


DECLARE @id INT
DECLARE @size   FLOAT
DECLARE @totalsize FLOAT
DECLARE sizecursor CURSOR FOR SELECT id FROM MailResource where size_n is null or size_n <= 0 
OPEN sizecursor
FETCH next FROM sizecursor INTO @id
WHILE(@@FETCH_STATUS = 0)
BEGIN
	SELECT @size = isnull(sum(filesize),0) FROM MailResourceFile WHERE mailid = @id 
	
	SELECT @totalsize = DATALENGTH(content)+DATALENGTH(subject) + @size FROM MailResource WHERE id = @id
	
	UPDATE MailResource SET size_n = @totalsize WHERE id = @id
	
FETCH next FROM sizecursor INTO @id
END 
CLOSE sizecursor
DEALLOCATE sizecursor
GO

DECLARE @id INT
DECLARE @size FLOAT
DECLARE statecursor CURSOR FOR SELECT DISTINCT resourceid , sum(CAST(size_n AS DECIMAL(18,2))) AS size FROM MailResource  where canview=1 GROUP BY resourceid
OPEN statecursor
FETCH next FROM statecursor INTO @id , @size
WHILE(@@FETCH_STATUS = 0)
BEGIN
	UPDATE HrmResource SET occupySpace = round(convert(FLOAT,@size)/(1024  * 1024),2) WHERE id = @id
FETCH next FROM statecursor INTO @id, @size
END 
CLOSE statecursor
DEALLOCATE statecursor
GO


UPDATE MainMenuInfo SET defaultLevel = 1, defaultParentId = 0 ,  parentId = 0 WHERE id = 1047
GO
UPDATE MainMenuInfo SET defaultLevel = 1, defaultParentId = 0 ,  parentId = 0 WHERE id = 359
GO
UPDATE MainMenuInfo SET defaultLevel = 1, defaultParentId = 0 ,  parentId = 0 WHERE id = 1381
GO

ALTER TABLE DocMailMould ADD mouldSubject VARCHAR(100)
GO