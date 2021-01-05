ALTER TABLE MailResource ADD timingdate VARCHAR(30)
GO

ALTER TABLE MailResource ADD timingdatestate INT
GO

ALTER TABLE MailResource ADD needReceipt INT
GO

ALTER TABLE MailAccount ADD receiveScope INT 
GO

ALTER TABLE MailAccount ADD receiveDateScope VARCHAR(50)
GO

ALTER TABLE MailResource ADD recallState CHAR(1) 
GO

ALTER TABLE MailResource ADD receiveNeedReceipt CHAR(1) 
GO

CREATE TABLE MailAutoRespond
(
	id          INT IDENTITY NOT NULL,
	userId      INT NULL,
	isAuto      CHAR (1) NULL,
	isContactReply CHAR(1) NULL,
	content     TEXT NULL
)
GO