ALTER TABLE MailResourceFile ADD  timeMillis float NULL DEFAULT 0
GO 
UPDATE MailResourceFile SET timeMillis = 0
GO 
CREATE INDEX MailResourceFile_timeMillis ON MailResourceFile(timeMillis)
GO
ALTER PROCEDURE MailResourceFile_Insert (
	@mailid_1 INT,
	@filename_2 VARCHAR (600),
	@filetype_3 VARCHAR (60),
	@filerealpath_4 VARCHAR (255),
	@iszip_5 CHAR (1),
	@isencrypt_6 CHAR (1),
	@isfileattrachment_7 CHAR (1),
	@fileContentId_8 VARCHAR (100),
	@isEncoded_9 CHAR (1),
	@filesize_10 INT,
	@timeMillis_11 FLOAT,
	@flag INT output,
	@msg VARCHAR (80) output
) AS 
INSERT INTO MailResourceFile (
	mailid,
	filename,
	filetype,
	filerealpath,
	iszip,
	isencrypt,
	isfileattrachment,
	fileContentId,
	isEncoded,
	filesize,
	timeMillis
)
VALUES
	(
		@mailid_1,
		@filename_2,
		@filetype_3,
		@filerealpath_4,
		@iszip_5,
		@isencrypt_6,
		@isfileattrachment_7,
		@fileContentId_8,
		@isEncoded_9,
		@filesize_10,
		@timeMillis_11
	) 
GO
